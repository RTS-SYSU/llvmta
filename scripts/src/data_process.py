#!/usr/bin/env python3

from calendar import c
import json
import os
import sys

from argparse import ArgumentParser
from pathlib import Path
from utils import logger_info, logger_error, logger_success

parser = ArgumentParser('Raspi Execution Counter process script')

parser.add_argument('-d', '--dir', type=str, default='./data',
                    help='Directory to results json files')
parser.add_argument('-p', '--percentages', type=float, nargs='+', default=[
                    95, 99, 99.5, 99.9], help='Percentages to calculate the confidence interval (default: [95, 99, 99.5, 99.9])')
parser.add_argument('-f', '--features', type=str, nargs='+',
                    choices=['median', 'mean', 'std',
                             'min', 'max', 'majority'],
                    default=['median', 'mean', 'std',
                             'min', 'max', 'majority'],
                    help='Features to calculate the confidence interval (default: all)')
parser.add_argument('-o', '--output', type=str, default='./output',
                    help='Output directory to save the results')

args = parser.parse_args()

data_dir = Path(os.path.abspath(args.dir))

if not data_dir.exists():
    logger_error(f'Directory {data_dir} not found')
    sys.exit(1)

output_dir = Path(os.path.abspath(args.output))

if not output_dir.exists():
    os.makedirs(output_dir)

for f in output_dir.iterdir():
    f.unlink()

logger_info(f'Processing data in {data_dir}')
logger_info(f'Saving results in {output_dir}')

for data_file in data_dir.iterdir():
    # if not a json file, skip
    if data_file.suffix != '.json':
        continue
    logger_info(f'Processing {data_file}')
    with open(data_file, 'r') as f:
        data = json.load(f)
    # print(len(data))
    core0, core1 = data
    core0_ = core0['results']
    core1_ = core1['results']

    assert len(core0_) == len(
        core1_), f'Different length of results in {data_file}'
    assert len(core0_) > 0, f'Empty results in {data_file}'
    assert len(core1_) > 0, f'Empty results in {data_file}'

    core0_data = list()
    core1_data = list()

    core0_task = core0_[0]['tasks'][0]['function'].split('_start')[0]
    core1_task = core1_[0]['tasks'][0]['function'].split('_start')[0]

    key_ = list(core0_[0]['tasks'][0].keys())

    for k in key_:
        if k != 'function':
            key = k
            break

    logger_info(f'Processing {core0_task} and {core1_task}')
    logger_info(f'Perf data: {key}')

    for i in range(len(core0_)):
        core0_data.append(core0_[i]['tasks'][0][key])
        core1_data.append(core1_[i]['tasks'][0][key])

    for per in args.percentages:
        sorted_c0 = sorted(core0_data)
        sorted_c1 = sorted(core1_data)

        sorted_c0 = sorted_c0[:int(len(sorted_c0) * per / 100)]
        sorted_c1 = sorted_c1[:int(len(sorted_c1) * per / 100)]

        result_file = output_dir / f'{core0_task}_{core1_task}_{per}.txt'

        with open(result_file, 'w') as fp:
            fp.write(f'core0: {core0_task}, core1: {core1_task}\n')
            fp.write(f'percentage: {per}%\n')

        logger_info(f'Calculating {per}% confidence interval')
        for feat in args.features:
            logger_info(f'Calculating {feat} feature')

            if feat == 'median':
                c0_res = sorted_c0[len(sorted_c0) // 2]
                c1_res = sorted_c1[len(sorted_c1) // 2]
            elif feat == 'mean':
                c0_res = sum(sorted_c0) / len(sorted_c0)
                c1_res = sum(sorted_c1) / len(sorted_c1)
            elif feat == 'std':
                c0_mean = sum(sorted_c0) / len(sorted_c0)
                c1_mean = sum(sorted_c1) / len(sorted_c1)
                c0_res = (
                    sum([(x - c0_mean) ** 2 for x in sorted_c0]) / len(sorted_c0)) ** 0.5
                c1_res = (
                    sum([(x - c1_mean) ** 2 for x in sorted_c1]) / len(sorted_c1)) ** 0.5
            elif feat == 'min':
                c0_res = min(sorted_c0)
                c1_res = min(sorted_c1)
            elif feat == 'max':
                c0_res = max(sorted_c0)
                c1_res = max(sorted_c1)
            elif feat == 'majority':
                c0_res = max(set(sorted_c0), key=sorted_c0.count)
                c1_res = max(set(sorted_c1), key=sorted_c1.count)

            with open(result_file, 'a') as fp:
                fp.write(f'{feat}: {c0_res} {c1_res}\n')
