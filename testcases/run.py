#!/usr/bin/env python3

import os
import shutil
from argparse import ArgumentParser
from pathlib import Path

def logger_info(msg: str):
    print(f'[*] {msg}')


def logger_success(msg: str):
    # change to green color
    print(f'[+] \033[92m{msg}\033[0m')


def logger_error(msg: str):
    # change to red color
    print(f'[-] \033[91m{msg}\033[0m')

parser = ArgumentParser('Run llvmta')

parser.add_argument('-s', '--src', type=str, required=True, help='The C source file directory, e.g. ./path/to/test')
parser.add_argument('-o', '--out', type=str, default='./out', help='The temporary directory to store the intermediate files')
parser.add_argument('-lf', '--lower-loop-file', type=str, default='LLoopAnnotations.csv', help='The lower bound loop file, relative to the source directory')
parser.add_argument('-uf', '--upper-loop-file', type=str, default='LoopAnnotations.csv', help='The upper bound loop file, relative to the source directory')
parser.add_argument('-c', '--core-info', type=str, default='CoreInfo.json', help='The core info file, relative to the source directory')
parser.add_argument('-n', '--num-cores', type=int, default=2, help='The number of cores to use')
parser.add_argument('-p', action='store_true', help='Generate the proper LoopAnnotations.csv and LLoopAnnotations.csv files')

args = parser.parse_args()

logger_info(f'Using source directory: {args.src}')
logger_info(f'Using output directory: {args.out}')

def handle_generate(args):
    src_dir = Path(os.path.abspath(args.src))
    if not src_dir.exists():
        logger_error(f'Source directory {src_dir} does not exist')
        exit(1)

    if not src_dir.is_dir():
        logger_error(f'Source directory {src_dir} is not a directory')
        exit(1)
        
    cf = Path(src_dir / args.core_info)
    if not cf.exists():
        logger_error(f'Core info file {str(cf)} does not exist, please check the file name')
        exit(1)
        
    out_dir = Path(os.path.abspath(args.out))
    if not out_dir.exists():
        logger_info(f'Creating output directory {out_dir}')
        out_dir.mkdir(parents=True)

    if not out_dir.is_dir():
        logger_error(f'Output directory {out_dir} is not a directory')
        exit(1)

    logger_success(f'All files exist, ready to run llvmta')

    command = [
        "llvmta",
        "-disable-tail-calls",
        "-float-abi=hard",
        "-mattr=-neon,+vfp2",
        "-O0",
        "--ta-muarch-type=outoforder",
        "--ta-memory-type=separatecaches",
        "--ta-strict=false",
        "--ta-num-callsite-tokens=1",
        f"--core-info={str(cf)}",
        f"--core-numbers={args.num_cores}",
        "--shared-cache-Persistence-Analysis=false",
        "--ta-output-unknown-loops",
        "--ta-l2cache-persistence=elementwise",
        "-debug-only=",
        "optimized.ll"
    ]

    logger_info(f'Running llvmta with the following arguments:')
    logger_info(f'Core info file: {str(cf)}')
    logger_info(f'Number of cores: {args.num_cores}')


    logger_info(f'Compiling the source file to LLVM IR')
    # First, we need to compile the source file to LLVM IR
    stat = os.system(f'./runBeforeGDB {str(src_dir)}')
    if stat != 0:
        logger_error(f'Failed to compile the source file to LLVM IR')
        exit(1)
    else:
        logger_success(f'Successfully compiled the source file to LLVM IR')

    logger_info(f'Running llvmta')
    # Run llvmta
    logger_info(f'Using command: {" ".join(command)}')
    # Change working directory to the output directory

    pwd = os.getcwd()
    os.chdir('dirforgdb')
    stat = os.system(' '.join(command))
    if stat != 0:
        logger_error(f'Failed to run llvmta')
        exit(1)
    else:
        shutil.copy('LoopAnnotations.csv', out_dir / 'LoopAnnotations.csv')
        shutil.copy('LoopAnnotations.csv', out_dir / 'LLoopAnnotations.csv')
        
        logger_success(f'Successfully ran llvmta')
        logger_success(f'Output LoopAnnotations.csv: {str(out_dir / "LoopAnnotations.csv")}')
        logger_success(f'Output LLoopAnnotations.csv: {str(out_dir / "LLoopAnnotations.csv")}')

        with open(out_dir / 'LoopAnnotations.csv', 'r') as f:
            data = f.readlines()
            
        output_data = list()
            
        for i in range(len(data)):
            if i != 0 and data[i].startswith('#'):
                continue
            output_data.append(data[i])
            
        with open(out_dir / 'LoopAnnotations.csv', 'w') as f:
            f.writelines(output_data)
            
        with open(out_dir / 'LLoopAnnotations.csv', 'r') as f:
            data = f.readlines()
        
        output_data = list()
        
        for i in range(len(data)):
            if i != 0 and data[i].startswith('#'):
                continue
            output_data.append(data[i])
        
        with open(out_dir / 'LLoopAnnotations.csv', 'w') as f:
            f.writelines(output_data)
            

    os.chdir(pwd)

def handle_run(args):
src_dir = Path(os.path.abspath(args.src))
if not src_dir.exists():
    logger_error(f'Source directory {src_dir} does not exist')
    exit(1)

if not src_dir.is_dir():
    logger_error(f'Source directory {src_dir} is not a directory')
    exit(1)


lf = Path(src_dir / args.lower_loop_file)
if not lf.exists():
    logger_error(f'Lower loop file {str(lf)} does not exist, please check the file name')
    exit(1)

uf = Path(src_dir / args.upper_loop_file)
if not uf.exists():
    logger_error(f'Upper loop file {str(uf)} does not exist, please check the file name')
    exit(1)
    
cf = Path(src_dir / args.core_info)
if not cf.exists():
    logger_error(f'Core info file {str(cf)} does not exist, please check the file name')
    exit(1)
    
out_dir = Path(os.path.abspath(args.out))
if not out_dir.exists():
    logger_info(f'Creating output directory {out_dir}')
    out_dir.mkdir(parents=True)

if not out_dir.is_dir():
    logger_error(f'Output directory {out_dir} is not a directory')
    exit(1)

logger_success(f'All files exist, ready to run llvmta')

command = [
    "llvmta",
    "-disable-tail-calls",
    "-float-abi=hard",
    "-mattr=-neon,+vfp2",
    "-O0",
    "--ta-muarch-type=outoforder",
    "--ta-memory-type=separatecaches",
    "--ta-strict=false",
    f"--ta-loop-bounds-file={str(uf)}",
    f"--ta-loop-lowerbounds-file={str(lf)}",
    "--ta-num-callsite-tokens=1",
    f"--core-info={str(cf)}",
    f"--core-numbers={args.num_cores}",
    "--shared-cache-Persistence-Analysis=false",
    "--ta-l2cache-persistence=elementwise",
    "-debug-only=",
    "optimized.ll"
]

logger_info(f'Running llvmta with the following arguments:')
logger_info(f'Lower loop file: {str(lf)}')
logger_info(f'Upper loop file: {str(uf)}')
logger_info(f'Core info file: {str(cf)}')
logger_info(f'Number of cores: {args.num_cores}')


logger_info(f'Compiling the source file to LLVM IR')
# First, we need to compile the source file to LLVM IR
stat = os.system(f'./runBeforeGDB {str(src_dir)}')
if stat != 0:
    logger_error(f'Failed to compile the source file to LLVM IR')
    exit(1)
else:
    logger_success(f'Successfully compiled the source file to LLVM IR')

logger_info(f'Running llvmta')
# Run llvmta
logger_info(f'Using command: {" ".join(command)}')
# Change working directory to the output directory

pwd = os.getcwd()
os.chdir('dirforgdb')
stat = os.system(' '.join(command))
if stat != 0:
    logger_error(f'Failed to run llvmta')
    exit(1)
else:
    shutil.copy('WCET.json', out_dir)
    logger_success(f'Successfully ran llvmta')
    logger_success(f'Output WCET: {str(out_dir / "WCET.json")}')

os.chdir(pwd)


if args.p:
    handle_generate(args)
else:
    handle_run(args)