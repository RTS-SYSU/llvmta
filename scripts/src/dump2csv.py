#!/usr/bin/env python3

import os
import sys

from argparse import ArgumentParser
from pathlib import Path

from utils import logger_info, logger_error, logger_success


class Data:
    def __init__(self, filedata):
        assert len(filedata) >= 3, 'Invalid data'
        self.c0data = dict()
        self.c1data = dict()
        for i in range(len(filedata)):
            if i == 0:
                c_info = filedata[i].split(',')
                for j in range(len(c_info)):
                    c_info[j] = c_info[j].strip()

                self.core0 = c_info[0].split('core0:')[-1].strip()
                self.core1 = c_info[1].split('core1:')[-1].strip()
            elif i == 1:
                self.percentage = filedata[i].split('percentage:')[-1].strip()
            else:
                key, vals = filedata[i].split(':')
                key = key.strip()
                vals = vals.strip()
                val0, val1 = vals.split()
                self.c0data[key] = val0
                self.c1data[key] = val1

    def get(self, core, feature):
        if core == 0:
            return self.c0data[feature]
        elif core == 1:
            return self.c1data[feature]
        else:
            logger_error(f'Invalid core {core}')
            sys.exit(1)

    def get_percentage(self):
        return self.percentage

    def get_tasks(self):
        return self.core0, self.core1


class CSV:
    def __init__(self, core0, feature):
        self.data = dict()
        self.core0 = core0
        self.feature = feature
        self.percentage = set()

    def add_data(self, core1, percentage, core0_val, core1_val):
        if percentage not in self.percentage:
            self.percentage.add(percentage)

        if self.data.get(core1) is None:
            self.data[core1] = dict()
        if self.data[core1].get(percentage) is None:
            self.data[core1][percentage] = dict()

        self.data[core1][percentage] = {
            self.core0: core0_val, core1: core1_val}

    def dump(self, core):
        if core == 0:
            core = self.core0
        else:
            core = None
        ps = sorted(list(self.percentage))
        result = f'{self.feature},{self.core0}'
        for p in ps:
            result += f',{p}'
        result += '\n'
        keys = sorted(list(self.data.keys()))

        for key in keys:
            for p in ps:
                if ps.index(p) == 0:
                    if core is not None:
                        result += f'{key},{self.data[key][p][core]}'
                    else:
                        result += f'{key},{self.data[key][p][key]}'
                else:
                    if core is not None:
                        result += f',{self.data[key][p][core]}'
                    else:
                        result += f',{self.data[key][p][key]}'

            result += '\n'

        return result

    def get_core(self, core):
        if core == 0:
            return self.core0
        else:
            return 'other'


parser = ArgumentParser('Dump processed data to csv')

parser.add_argument('-d', '--data', type=str,
                    default='./processed', help='Directory to processed data')
parser.add_argument('-o', '--output', type=str,
                    default='./output', help='Output dir')
parser.add_argument('-f', '--features', type=str, nargs='+', choices=[
                    'median', 'mean', 'std', 'min', 'max', 'majority'], default=['max', 'median'], help='Features to dump')

args = parser.parse_args()

data_dir = Path(os.path.abspath(args.data))

if not data_dir.exists():
    logger_error(f'Directory {data_dir} not found')
    sys.exit(1)

output_dir = Path(os.path.abspath(args.output))

if not output_dir.exists():
    output_dir.mkdir()

for f in output_dir.iterdir():
    f.unlink()

output_dict = dict()


for data in data_dir.iterdir():
    d_file_name = data.name
    logger_info(f'Processing {d_file_name}')

    with open(data, 'r') as f:
        pdata = f.readlines()

    d = Data(pdata)
    per = d.get_percentage()
    c0, c1 = d.get_tasks()

    for feature in args.features:
        if output_dict.get(feature) is None:
            csv = CSV(c0, feature)
            csv.add_data(c1, per, d.get(0, feature), d.get(1, feature))
            output_dict[feature] = csv
        else:
            output_dict[feature].add_data(
                c1, per, d.get(0, feature), d.get(1, feature))

    logger_success(f'Processed {d_file_name}')

for feature in args.features:
    with open(output_dir / f'{output_dict[feature].get_core(0)}_{feature}.csv', 'w') as f:
        f.write(output_dict[feature].dump(0))

    with open(output_dir / f'{output_dict[feature].get_core(1)}_{feature}.csv', 'w') as f:
        f.write(output_dict[feature].dump(1))
