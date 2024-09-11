#!/usr/bin/env python3

import os
import re

from argparse import ArgumentParser
from pathlib import Path

parser = ArgumentParser(description='Fill the loop bound for the given file')

parser.add_argument('-d', '--debug', action='store_true', help='Enable debug mode')
parser.add_argument('-s', '--source', type=str, help='The source file to be filled')
parser.add_argument('-r', '--range', type=int, default=3, help='The range to search for loop bound')
args = parser.parse_args()

DEBUG = args.debug
LINES_TO_SEARCH = args.range

def logger_debug(msg: str):
    if DEBUG:
        logger_info(f'\b\b\b\b[D] {msg}')
        
def logger_info(msg: str):
    print(f'[*] {msg}')
    
def logger_success(msg: str):
    print(f'[+] \033[92m{msg}\033[0m')
    
def logger_error(msg: str):
    print(f'[-] \033[91m{msg}\033[0m')
    
FILERE = re.compile(r'Loop in file (.*) near line (.*)')
LOOPRE = re.compile(r'\w*_Pragma\(\s*\"loopbound\s*min\s*(\d+)\s*max\s*(\d+)\s*\"\s*\).*')

FILECACHES = dict()

class Annotation:
    def __init__(self, filename: str):
        self.filename = filename
        
        with open(self.filename, 'r') as f:
            self.lines = f.readlines()
            
        if self.lines[0].startswith('#'):
            self.header = self.lines[0]
            self.lines = self.lines[1:]
        else:
            self.header = None
            
        for i in range(len(self.lines)):
            self.lines[i] = self.lines[i].strip().split('|')
            
            assert len(self.lines[i]) == 4, f'Invalid line {self.lines[i]}'

    def __getitem__(self, index: int):
        logger_debug(f'Get item {index}, Content: {"|".join(self.lines[index])}')
        return '|'.join(self.lines[index])

    def __len__(self):
        return len(self.lines)

    def fill(self, index: int, loopbound: int):
        self.lines[index][3] = loopbound
        
    def get(self, index: int):
        return self.lines[index]

    def save(self):
        with open(self.filename, 'w') as f:
            if self.header:
                f.write(self.header)
            
            for line in self.lines:
                f.write('|'.join(line) + '\n')

def read_file(filename: str, pathbase: Path) -> list:
    with open(pathbase / filename, 'r') as f:
        lines = f.readlines()
        
    for i in range(len(lines)):
        lines[i] = lines[i].strip()
        
    return lines


def get_bound_for(description: str, pathbase: Path) -> int:
    print(f'We get {description} bound')
    segment = description.split('|')
    
    file_info = segment[1]
    pattern = FILERE.match(file_info)
    if pattern:
        filename = pattern.group(1)
        line = pattern.group(2)
        logger_success(f'Extracted file: {filename} and line: {line}')
    else:
        logger_error(f'Cannot extract file and line from {file_info}')
        
    if filename not in FILECACHES:
        FILECACHES[filename] = read_file(filename, pathbase)
        
    else:
        logger_debug(f'File {filename} already in cache')
    
    lines = FILECACHES[filename]
        
    # logger_debug(f'Lines: {lines}')
        
    lines_near = lines[max(0, int(line)-LINES_TO_SEARCH):min(len(lines), int(line)+LINES_TO_SEARCH)]
    loop_line = int(line)
    start_line = max(0, int(line)-LINES_TO_SEARCH)
    logger_debug(f'Start line: {start_line}')
    logger_debug(f'Lines near: {lines_near}')
    
    avail_choice = dict()
    
    for i in range(len(lines_near)):
        line = lines_near[i]
        m = LOOPRE.match(line)
        if m:
            logger_debug(f'Found line: {line}')
            logger_debug(f'Found min: {m.group(1)} and max: {m.group(2)}')
            
            # First get lineno
            lineno = start_line + i
            avail_choice[lineno] = (m.group(1), m.group(2))
            
        else:
            logger_debug(f'Not found line: {line}')
            
    if len(avail_choice) == 0:
        logger_error(f'Cannot find loopbound in file for this loop {description}')
        return -1, -1

    # Choice the nearest line
    logger_debug(f'Available choice: {avail_choice.keys()}')
    lineno = min(list(avail_choice.keys()), key=lambda x: abs(int(x)-int(loop_line)))
    logger_success(f'Found loopbound in line at {lineno}')
    return avail_choice[lineno]

src_dir = Path(os.path.abspath(args.source))

lb = src_dir / 'LLoopAnnotations.csv'
if not lb.exists():
    logger_error(f'Cannot find loop bound file {lb}')
    exit(1)

ub = src_dir / 'LoopAnnotations.csv'
if not ub.exists():
    logger_error(f'Cannot find loop bound file {ub}')
    exit(1)

lbs = Annotation(str(lb))
ubs = Annotation(str(ub))

assert len(lbs) == len(ubs), 'The number of loop bounds is not equal'

for i in range(len(lbs)):
    lb, rb = get_bound_for(lbs[i], src_dir)
    logger_debug(f'Loop bound: {lb} and {rb} for {lbs[i]}')
    lbs.fill(i, lb)
    ubs.fill(i, rb)

lbs.save()
ubs.save()