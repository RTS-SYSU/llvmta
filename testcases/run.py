#!/usr/bin/env python3


import os
import shutil
import subprocess


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
parser.add_argument('-o', '--out', type=str, default='./out', help='The directory to store the result files')
parser.add_argument('-t', '--tmp', type=str, default='./dirforgdb', help='The temporary directory to store the intermediate files')
parser.add_argument('-lf', '--lower_loop_file', type=str, default='LLoopAnnotations.csv', help='The lower bound loop file, relative to the source directory')
parser.add_argument('-uf', '--upper_loop_file', type=str, default='LoopAnnotations.csv', help='The upper bound loop file, relative to the source directory')
parser.add_argument('-c', '--core_info', type=str, default='CoreInfo.json', help='The core info file, relative to the source directory')
parser.add_argument('-n', '--num_cores', type=int, default=2, help='The number of cores to use')
parser.add_argument('-p', action='store_true', help='Generate the proper LoopAnnotations.csv and LLoopAnnotations.csv files')
parser.add_argument('--icache_line_size', type=int, default=64, help='The ICache Line Size, in bytes, default is 64')
parser.add_argument('--icache_assoc', type=int, default=8, help='The ICache Associativity, default is 8')
parser.add_argument('--icache_sets', type=int, default=64, help='The ICache Number of Sets, default is 64')
parser.add_argument('--dcache_line_size', type=int, default=64, help='The DCache Line Size, in bytes, default is 64')
parser.add_argument('--dcache_sets', type=int, default=64, help='The DCache Number of Sets, default is 64')
parser.add_argument('--dcache_assoc', type=int, default=8, help='The DCache Associativity, default is 8')
parser.add_argument('--l2_line_size', type=int, default=64, help='The L2 Cache Line Size, in bytes, default is 64')
parser.add_argument('--l2_assoc', type=int, default=8, help='The L2 Cache Associativity, default is 8')
parser.add_argument('--l2_sets', type=int, default=64, help='The L2 Cache Number of Sets, default is 64')
parser.add_argument('--mem_latency', type=int, default=100, help='The memory latency, default is 100 cycles')
parser.add_argument('--l2_latency', type=int, default=50, help='The L2 cache latency, default is 100 cycles')
parser.add_argument('--l1_latency', type=int, default=10, help='The L1 cache latency, default is 10 cycles')

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
        f"--ta-icache-linesize={args.icache_line_size}",
        f"--ta-icache-nsets={args.icache_sets}",
        f"--ta-icache-assoc={args.icache_assoc}",
        f"--ta-dcache-linesize={args.dcache_line_size}",
        f"--ta-dcache-assoc={args.dcache_assoc}",
        f"--ta-dcache-nsets={args.dcache_sets}",
        f"--ta-l2cache-linesize={args.l2_line_size}",
        f"--ta-l2cache-assoc={args.l2_assoc}",
        f"--ta-l2cache-nsets={args.l2_sets}",
        f"--ta-mem-latency={args.mem_latency}",
        f"--ta-Icache-latency={args.l1_latency}",
        f"--ta-Dcache-latency={args.l1_latency}",
        f"--ta-L2-latency={args.l2_latency}",
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
    os.chdir(args.tmp)
    stat = os.system(' '.join(command))
    if stat != 0:
        logger_error(f'Failed to run llvmta')
        exit(1)
    else:
        # shutil.copy('LoopAnnotations.csv', out_dir / 'LoopAnnotations.csv')
        shutil.copy('LoopAnnotations.csv', 'LLoopAnnotations.csv')

        with open('LoopAnnotations.csv', 'r') as f:
            data = f.readlines()
            
        output_data = list()
            
        for i in range(len(data)):
            if i != 0 and data[i].startswith('#'):
                continue
            output_data.append(data[i])
            
        with open('LoopAnnotations.csv', 'w') as f:
            f.writelines(output_data)
            
        with open('LLoopAnnotations.csv', 'r') as f:
            data = f.readlines()
        
        output_data = list()
        
        for i in range(len(data)):
            if i != 0 and data[i].startswith('#'):
                continue
            output_data.append(data[i])
        
        with open('LLoopAnnotations.csv', 'w') as f:
            f.writelines(output_data)
            
        logger_success(f'Successfully ran llvmta')
        # logger_success(f'Output LoopAnnotations.csv: {str(out_dir / "LoopAnnotations.csv")}')
        # logger_success(f'Output LLoopAnnotations.csv: {str(out_dir / "LLoopAnnotations.csv")}')
        
        shutil.copy('LoopAnnotations.csv', src_dir / 'LoopAnnotations.csv')
        shutil.copy('LoopAnnotations.csv', src_dir / 'LLoopAnnotations.csv')
        
        logger_info(f'Trying to find the loop bound...')
        
        p = subprocess.Popen(
            [
                'python3', 
                'quickGetBound.py',
                '-s',
                f'{str(src_dir)}',
            ], 
            env = os.environ.copy(), 
            cwd = pwd,
            stdout = subprocess.PIPE,
            stderr = subprocess.PIPE
        )
        
        p.wait()
        
        if p.returncode != 0:
            logger_error(f'Failed to find the loop bound')
            logger_error(f'Please manually check the LoopAnnotations.csv and LLoopAnnotations.csv files')
            logger_error(f'STDOUT: {p.stdout.read()}')
            logger_error(f'STDERR: {p.stderr.read()}')
        else:
            logger_success(f'Successfully found the loop bound')
        shutil.copy('LoopAnnotations.csv', out_dir / 'LoopAnnotations.csv')
        shutil.copy('LoopAnnotations.csv', out_dir / 'LLoopAnnotations.csv')
        logger_success(f'Output LoopAnnotations.csv: {str(out_dir / "LoopAnnotations.csv")}')
        logger_success(f'Output LLoopAnnotations.csv: {str(out_dir / "LLoopAnnotations.csv")}')
        
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
        logger_error(f'Lower loop file {str(lf)} does not exist, please check the file exist')
        logger_error(f'If you want to generate the loop files, please use the -p flag')
        exit(1)

    uf = Path(src_dir / args.upper_loop_file)
    if not uf.exists():
        logger_error(f'Upper loop file {str(uf)} does not exist, please check the file exist')
        logger_error(f'If you want to generate the loop files, please use the -p flag')
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
        f"--ta-icache-linesize={args.icache_line_size}",
        f"--ta-icache-nsets={args.icache_sets}",
        f"--ta-icache-assoc={args.icache_assoc}",
        f"--ta-dcache-linesize={args.dcache_line_size}",
        f"--ta-dcache-assoc={args.dcache_assoc}",
        f"--ta-dcache-nsets={args.dcache_sets}",
        f"--ta-l2cache-linesize={args.l2_line_size}",
        f"--ta-l2cache-assoc={args.l2_assoc}",
        f"--ta-l2cache-nsets={args.l2_sets}",
        f"--ta-mem-latency={args.mem_latency}",
        f"--ta-Icache-latency={args.l1_latency}",
        f"--ta-Dcache-latency={args.l1_latency}",
        f"--ta-L2-latency={args.l2_latency}",
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
    os.chdir(args.tmp)
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