#!/usr/bin/env python3

import json
import os

from argparse import ArgumentParser
from pathlib import Path

tasks = list()

parser = ArgumentParser(description='Generate json files for testing')
parser.add_argument(
    '-s', '--src', help='source directory (default: ./src)', default='./src')

args = parser.parse_args()

src = os.listdir(args.src)
tasks = [f.replace('.c', '') for f in src]
tasks_func = [f.replace('.c', '') for f in src]
libs = [f'lib{f.replace(".c", "")}' for f in src]

# check if the file exists
for lib in libs:
    if not os.path.exists(f'./lib/{lib}.so'):
        print(f'[-] {lib}.so not found')
        exit(1)
    # read symbols to check if the function exists
    p = os.popen(f'nm ./lib/{lib}.so').read()

    idx = libs.index(lib)
    func = tasks_func[idx]
    if func not in p:
        print(f'[-] Function {func} not found in {lib}.so')
        exit(1)

print('[+] All files and functions found')

output_libdir = Path(os.path.abspath('./lib_test'))
if not os.path.exists(output_libdir) or not os.path.isdir(output_libdir):
    os.makedirs(output_libdir)

for i in range(len(libs)):
    for j in range(2):
        os.system(f'cp ./lib/{libs[i]}.so {output_libdir}/{libs[i]}_{j}.so')


# start func
json_path = Path(os.path.abspath('./json'))
if not os.path.exists(json_path) or not os.path.isdir(json_path):
    os.makedirs(json_path)

idx = 0
format_str = r'test_{}.json'

# for i in range(len(tasks)):
core_0_task = {
    "core": 0,
    "tasks": [
        {
            "function": 'ndes_start',
            "lib": f'libndes_0.so'
        }
    ]
}
for j in range(len(tasks)):
    core_1_task = {
        "core": 1,
        "tasks": [
            {
                "function": f'{tasks_func[j]}_start',
                "lib": f'{libs[j]}_1.so'
            }
        ]
    }

    output = [core_0_task, core_1_task]
    with open(json_path / format_str.format(idx), 'w') as f:
        json.dump(output, f, indent=4)
    idx += 1
