#!/usr/bin/env python3

'''
This is a simple script to compile the benchmark suite
'''

import os
import sys
from pathlib import Path
from argparse import ArgumentParser
from utils import logger_info, logger_error, logger_success


system = os.system

parser = ArgumentParser('llvmta benchmark suite compiler')
parser.add_argument('-w', '--wrap', action='store_true',
                    help='Wrap the main function')
parser.add_argument('-m', '--main', type=str, default='main.c',
                    help='Where the real main function is located')
parser.add_argument('-l', '--lib', action='store_true',
                    help='Compile as a library')
parser.add_argument('-f', '--flags', type=str, default='-O0',
                    help='Compiler flags to pass to the compiler, '
                    'default is \"-O0 -fPIC\" if -l is set, otherwise \"-O0\"')
parser.add_argument('-lf', '--ldflags', type=str, default='',
                    help='Compiler flags to pass to the linker, '
                    'default is \"-shared\" if -l is set, otherwise \"\"')
parser.add_argument('-c', '--compiler', type=str, default='gcc',
                    help='Compiler to use, default is \"gcc\"')
parser.add_argument('-s', '--src', type=str, default='./src',
                    help='Directory to compile, default is \"src\"')
parser.add_argument('-o', '--output', type=str, default=None,
                    help='Output directory, default is \"bin\" '
                    'if -l is not set, otherwise \"lib\"')

args = parser.parse_args()

CC = str(args.compiler)
CC_FLAGS = str(args.flags)
LD_FLAGS = str(args.ldflags)

errors = list()

MAIN_REPLACEMENT = r'{}_start' if args.lib else '__wrap_main' if args.wrap else 'main'

if args.lib:
    if CC_FLAGS.find('-fPIC') == -1:
        CC_FLAGS = f'{CC_FLAGS} -fPIC'
    if LD_FLAGS.find('-shared') == -1:
        LD_FLAGS = '-shared'

logger_info(f'Using compiler: {CC}')
logger_info(f'Using compiler flags: {CC_FLAGS}')
logger_info(f'Using linker flags: {LD_FLAGS}')

if args.lib:
    logger_info('Compiling as a library')
else:
    logger_info('Compiling as an executable')

if args.wrap or args.lib:
    logger_info(f'Wrapping the main function to {MAIN_REPLACEMENT}')

OUTPUT_DIR_NAME = args.output if args.output else './lib' if args.lib else './bin'

src_c = Path(os.path.abspath(args.src))
output_dir = Path(os.path.abspath(OUTPUT_DIR_NAME)
                  ) if not args.lib else Path(os.path.abspath('./lib'))

if not src_c.exists():
    logger_error('Source directory does not exist')
    sys.exit(1)

wrapped_obj = os.path.abspath('./wrapped.o')
if args.wrap:
    if not args.main:
        logger_error('No main file specified')
        sys.exit(1)
    if not Path(args.main).exists():
        logger_error(f'Main file({args.main}) does not exist')
        sys.exit(1)

    logger_info(f'Compiling {args.main} to {wrapped_obj}')
    stat = system(f'{CC} {CC_FLAGS} -c {args.main} -o {wrapped_obj}')
    if stat != 0:
        logger_error(f'Failed to compile {args.main}')
        sys.exit(1)


if not output_dir.exists():
    output_dir.mkdir()

for f in output_dir.iterdir():
    f.unlink()


for src in src_c.iterdir():
    HAS_ERROR = False
    old_cwd = os.getcwd()
    os.chdir(src)
    c_files = list(src.glob('*.c'))

    # get the basic name of the file
    output_name = os.path.basename(src)
    if args.lib:
        output_name = output_dir / f'lib{output_name}.so'
    else:
        output_name = output_dir / f'{output_name}'

    if len(c_files) == 0:
        logger_error(f'No C files found in {src}')
        logger_error(f'Skipping {src}')
        continue
    objs = []
    for c_file in c_files:
        obj = c_file.with_suffix('.o')
        logger_info(f'Compile {c_file} to {obj}')
        stat = system(f'{CC} {CC_FLAGS} -c {c_file} -o {obj}')
        if stat == 0:
            objs.append(str(obj))
        else:
            logger_error(f'Failed to compile {c_file}')
            logger_error(f'Skipping {src}')
            HAS_ERROR = True
            break
    if HAS_ERROR:
        continue

    for obj in objs:
        if args.lib:
            MAIN_REP = MAIN_REPLACEMENT.format(os.path.basename(src))
            logger_info(f'Wrapping {obj} replacing main with {MAIN_REP}')
            stat = system(f'objcopy --redefine-sym main={MAIN_REP} {obj}')
            if stat != 0:
                logger_error(f'Failed to wrap {obj}')
                logger_error(f'Skipping {src}')
                HAS_ERROR = True
                break
        elif args.wrap:
            logger_info(
                f'Wrapping {obj} replacing main with {MAIN_REPLACEMENT}')
            stat = system(
                f'objcopy --redefine-sym main={MAIN_REPLACEMENT} {obj}')
            if stat != 0:
                logger_error(f'Failed to wrap {obj}')
                logger_error(f'Skipping {src}')
                HAS_ERROR = True
                break
    if HAS_ERROR:
        continue
    if args.lib:
        logger_info(f'Linking {output_name} from {objs}')
        stat = system(f'{CC} {LD_FLAGS} {" ".join(objs)} -o {output_name}')
        if stat != 0:
            logger_error(f'Failed to link {output_name}')
            logger_error(f'Skipping {src}')
            continue
        else:
            logger_success(f'Compiled {output_name}')
    else:
        if args.wrap:
            objs.append(wrapped_obj)
        logger_info(f'Linking {output_name} from {objs}')
        stat = system(f'{CC} {" ".join(objs)} -o {output_name}')
        if stat != 0:
            logger_error(f'Failed to link {output_name}')
            logger_error(f'Skipping {src}')
            continue
        else:
            logger_success(f'Compiled {output_name}')

    os.chdir(old_cwd)
