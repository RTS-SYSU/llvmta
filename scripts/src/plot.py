#!/usr/bin/env python3

from cProfile import label
from random import shuffle
import matplotlib.pyplot as plt

import json
import sys
import os

from argparse import ArgumentParser
from pathlib import Path

from utils import logger_info, logger_error, logger_success


class Data:
    def __init__(self, filename: str):
        self.filename = filename

    def get_data(self, idx: int):
        raise NotImplementedError("Method not implemented")


class JsonData(Data):
    def __init__(self, filename: str):
        super().__init__(filename)

        with open(filename, "r") as f:
            self.data = json.load(f)

        self.data = self.data[-1]["results"]

    def get_data(self, idx: int):
        return self.data[idx]["tasks"][-1]["ticks"]


class TxtData(Data):
    def __init__(self, filename: str):
        super().__init__(filename)

        with open(filename, "r") as f:
            self.data = f.readlines()

        self.data = [int(x) for x in self.data]

    def get_data(self, idx: int):
        return self.data[idx]


parser = ArgumentParser('Raspi Execution Counter plot script')
parser.add_argument('-p', '--percentages', type=float,
                    default=0.995, help='Percentage to plot')
parser.add_argument('-m', '--max', action='store_true',
                    help='Whether to print the max value')
parser.add_argument('-d', '--directory', type=str,
                    help='Directory to data', required=True)
parser.add_argument('-o', '--output', type=str,
                    help='Output directory', default='./output')

args = parser.parse_args()

input_path = Path(os.path.abspath(args.directory))
if not input_path.exists():
    logger_error(f'Directory {input_path} not found')
    sys.exit(1)

output_path = Path(os.path.abspath(args.output))
if not output_path.exists():
    os.makedirs(output_path)


for f in output_path.iterdir():
    f.unlink()


for f in input_path.iterdir():
    logger_info(f'Processing {f}')
    if f.suffix == '.json':
        data = JsonData(str(f))
    elif f.suffix == '.txt':
        data = TxtData(str(f))
    else:
        logger_error(f'File {f} not supported')
        continue

    data_points = [data.get_data(i) for i in range(len(data.data))]

    data_points = sorted(data_points)
    n = len(data_points)
    idx = int(n * args.percentages)
    logger_info(f'Keeping {args.percentages * 100}% of the data')
    data_points = data_points[:idx]
    shuffle(data_points)

    if args.max:
        logger_info(f'{f.stem} max: {max(data_points)}')

    plt.scatter(x=range(len(data_points)), y=data_points, label=f.stem, c='b')
    plt.legend()
    plt.savefig(output_path / f'{f.stem}.png')  # , dpi=300)

    plt.clf()
    plt.cla()
