#!/usr/bin/env python3
"""
Annotations
"""

from pprint import pformat
import argparse
import os
import re
import subprocess


class Annotations():
    """ Class to hold Loop Annotation data and abstract it """

    class RecursiveDict(dict):
        "Loops"

        def __missing__(self, key):
            value = self[key] = type(self)()
            return value

    def __init__(self):
        self.loops = self.RecursiveDict()
        self.code_funcs = self.RecursiveDict()

    def add_loop(self, file: str, func: str, lid: tuple, max_bound: int):
        """ Add a new loop annotation"""
        self.loops[file][func][lid] = max_bound

    def add_loop_regex(self, regex_data: tuple):
        """ Add a new loop from the output of parsing the Regex"""
        func, file, line, basic_block, bound = regex_data
        self.add_loop(file, func, (int(basic_block), int(line)), int(bound))

    def get_loop_bound(self, file: str, func: str, lid: tuple):
        """ Returns the bound for a specific loop """
        return self.loops[file][func][lid]

    def get_llvmta_files(self):
        """ Returns the list of files in the current Test """
        return self.loops.keys()

    def get_llvmta_funcs(self, s_file):
        """ Returns the list of functions in the given file with a loop """
        return self.loops[s_file].keys()

    def get_loops(self, s_file, s_func):
        """ Return a list of loops in the given function """
        return self.loops[s_file][s_func]

    def add_code_func(self, file: str, func: str, start: int, end: int):
        """ Add data about a function in the source code """
        self.code_funcs[file][func] = (start, end)

    def add_code_func_regex(self, regex_data: tuple):
        """ Add function from Regex output """
        func, file, start, end = regex_data
        self.add_code_func(file, func, int(start), int(end))

    def get_code_func_data(self, fname, func_name):
        """ Return the loop data for a given function in the source code """
        return self.code_funcs[fname][func_name]

    def find_bound(self, s_file: str, s_func: str, line: int) -> int:
        """ Run through the data to find a unique loop matching given
        parameters """
        loop_data = self.get_loops(s_file, s_func)
        # Ensure that we have only one loop with the same line. Else, report to
        # user that a unique loop can't be found (retval = -1)
        # print("%s %s:%s", s_file, s_func, line)
        retval = -999
        for lid in loop_data:
            if lid[1] == line:
                if retval == -999:
                    retval = loop_data[lid]
                else:
                    return -2
        if retval >= 0:
            return retval
        return -2

    def __str__(self):
        return "{}\n{}".format(pformat(self.loops), pformat(self.code_funcs))


LIBRARY_FUNCS = {
    "__udivsi3": 32
}

# OutputFile: str = "{}/LoopAnnotationsRaw.csv".format(sys.argv[1])
LLVMTA_LOOPS = Annotations()

LOOP_REGEX = re.compile(
    r"^(.*)\|Loop in file ([-\w]+\.c) (?:at|near) line (\d+)\|BB#(\d+):.*\|([-]?\d+)$")

TAGS_REGEX = re.compile(
    r"^(\w+)\s+([-\w]+\.c[p]?[p]?)\s+.*;\"\s+line:(\d+)\s+end:(\d+)$")

PRAGMA_REGEX = re.compile(
    r"^\s*_Pragma\s*\(\s*\"loopbound min (\d+) max (\d+)\"\s*\)")


def parse_llvmta_loop_annotations(annot_struct: Annotations, annot_file: str):
    """ Parse the LoopAnnotations.csv file created by LLVMTA into memory """
    with open(annot_file) as llvmta_loop_file:
        filetype = llvmta_loop_file.readline().rstrip().split(' ')[2]
        assert filetype == "Normal"
        for file_line in llvmta_loop_file:
            print(file_line)
            annot_struct.add_loop_regex(LOOP_REGEX.findall(file_line)[0])


def parse_source_loop_annotations(s_loops: Annotations, s_file: str, s_func: str):
    """ Parse the source code searching for Loop Annotation Pragmas """
    if s_func in LIBRARY_FUNCS:
        s_loops.add_loop(s_file, s_func, (0, 0), LIBRARY_FUNCS[s_func])
        return
    f_start, f_end = LLVMTA_LOOPS.get_code_func_data(s_file, s_func)

    func_loops_cmd = \
        "sed -n '{},{}p' {} | nl -ba -v{} | grep '_Pragma'".format(
            f_start, f_end, s_file, f_start)
    p_list = [line.split('\t'.encode('utf-8'), maxsplit=1)
              for line
              in subprocess.check_output(func_loops_cmd,
                                         shell=True).splitlines()]
    # pprint(p_list)
    for pragma in p_list:
        # print(pragma)
        limits = PRAGMA_REGEX.findall(pragma[1].decode('utf-8'))
        # print(limits)
        if limits:
            limits = limits[0]
            s_loops.add_loop(
                s_file, s_func, (0, int(pragma[0])), int(limits[1]))


def str2bool(v):
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')


def parse_args():
    """ Parse arguments """
    parser = argparse.ArgumentParser()
    parser.add_argument("testcase", help="Path to testcase directory")
    parser.add_argument("unknown_loops", help="Path to Unknown Loops file")
    parser.add_argument("output_file", help="Path to output file")
    parser.add_argument("--basecase", default="NotOptimized|HardFloat",
                        help="The base case FLAGS to find the file")
    parser.add_argument("--is-base", default=True, type=str2bool)
    args = parser.parse_args()
    return args


def parse_source_functions():
    """ Parse the source code using Universal CTags to get a list of functions
    and their scope"""

    # Create a tags file with the required tags fields
    subprocess.check_call(
        "ctags --c-kinds=f --fields=en -otags_s *.c", shell=True)

    # Create a list of all the known functions
    with open("tags_s") as tags_file:
        for line in tags_file:
            # print(line)
            func_data = TAGS_REGEX.findall(line)
            # print(func_data)
            if func_data:
                # pprint(func_data)
                LLVMTA_LOOPS.add_code_func_regex(func_data[0])


def get_loop_bounds() -> int:
    """ Gather the loop bounds from all supported sources and create an
    in-memory list"""
    for source_file in LLVMTA_LOOPS.get_llvmta_files():
        for source_func in LLVMTA_LOOPS.get_llvmta_funcs(source_file):
            source_loops = None
            llvmta_loop_data = LLVMTA_LOOPS.get_loops(source_file, source_func)
            # Quick exit path. If all loops were guessed by LLVMTA, then we
            # don't really need to parse the source annotations. This also
            # handles the simpler testcases where LLVMTA always guesses all the
            # loop bounds and we have no annotations at all

            if all(v >= 0 for v in llvmta_loop_data.values()):
                continue
            source_loops = Annotations()
            parse_source_loop_annotations(
                source_loops, source_file, source_func)
            source_loop_data = source_loops.get_loops(source_file, source_func)
            if len(llvmta_loop_data) != len(source_loop_data):
                print("LLVMTA Loops and Annotations don't match. Please check")
                # pprint(llvmta_loop_data)
                # pprint(source_loop_data)
                return 1
            for lid, s_lid in zip(sorted(llvmta_loop_data), sorted(source_loop_data)):
                if llvmta_loop_data[lid] == -1:
                    llvmta_loop_data[lid] = source_loop_data[s_lid]
    return 0


def write_loop_bounds(annot_file: str, output_file: str):
    with open(annot_file) as orig, open(output_file, "w+") as out:
        # Skip the first line which states the file-type
        next(orig)
        out.write("# Type: Normal\n")
        for line in orig:
            loop_data = LOOP_REGEX.findall(line)[0]
            sfunc, sfile, sline, sbb, _ = loop_data
            split_data = line.split('|')
            split_data[-1] = str(LLVMTA_LOOPS.get_loop_bound(sfile,
                                                             sfunc, (int(sbb), int(sline))))
            out.write("|".join(split_data) + '\n')


def base_case_main(unknown_loops_file: str, testdir: str, output_file: str) -> int:
    parse_llvmta_loop_annotations(LLVMTA_LOOPS, unknown_loops_file)
    PWD = os.getcwd()
    os.chdir(testdir)
    parse_source_functions()
    retval = get_loop_bounds()
    os.chdir(PWD)
    if retval == 0:
        write_loop_bounds(unknown_loops_file, output_file)
    return retval


def other_cases_main(unknown_loops_file: str, testdir: str, base: str, output_file: str):
    base_file = "{}/LoopAnnotations_{}.csv".format(testdir, base)
    if not os.path.isfile(base_file):
        return 2
    base_file_annotations = Annotations()
    parse_llvmta_loop_annotations(LLVMTA_LOOPS, unknown_loops_file)
    parse_llvmta_loop_annotations(base_file_annotations, base_file)
    retval = 0
    for file in LLVMTA_LOOPS.get_llvmta_files():
        for func in LLVMTA_LOOPS.get_llvmta_funcs(file):
            llvmta_loop_data = LLVMTA_LOOPS.get_loops(file, func)
            if all(v >= 0 for v in llvmta_loop_data.values()):
                continue

            base_loop_data = base_file_annotations.get_loops(file, func)
            if len(llvmta_loop_data) == len(base_loop_data):
                for lid, s_lid in zip(sorted(llvmta_loop_data), sorted(base_loop_data)):
                    llvmta_loop_data[lid] = base_loop_data[s_lid]
                continue

            for loop in llvmta_loop_data:
                if llvmta_loop_data[loop] >= 0:
                    continue
                if func in LIBRARY_FUNCS:
                    llvmta_loop_data[loop] = LIBRARY_FUNCS[func]
                    continue
                bound = base_file_annotations.find_bound(file, func, loop[1])
                if bound == -2:
                    bound = base_file_annotations.find_bound(
                        file, func, loop[1] - 1)
                llvmta_loop_data[loop] = bound
                if bound == -2:
                    retval = 4
                    continue
    write_loop_bounds(unknown_loops_file, output_file)
    return retval


if __name__ == "__main__":
    ARGS = parse_args()

    output_file = "{}/LoopAnnotations_{}.csv".format(
        ARGS.testcase, ARGS.output_file)

    if ARGS.is_base:
        ret = base_case_main(ARGS.unknown_loops, ARGS.testcase, output_file)
    else:
        ret = other_cases_main(
            ARGS.unknown_loops,
            ARGS.testcase,
            ARGS.basecase,
            output_file
        )
    exit(ret)
