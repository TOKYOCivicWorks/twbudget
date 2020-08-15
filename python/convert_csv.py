#!/usr/bin/python3

import re

from account_file_writer import AccountFileWriter
from account_parser import AccountParser
from account_parser_for_initial_budget import AccountParserForInitialBudget

DATA_DIR = 'data/'
FILELIST = [['DL201511001.csv', 'DL201521001.csv'],
            ['DL201611001.csv', 'DL201621001.csv',
                'DL201621002.csv', 'DL201621003.csv'],
            ['DL201711001.csv', 'DL201721001.csv'],
            ['DL201811001.csv', 'DL201821001.csv', 'DL201821002.csv'],
            ['DL201911001.csv', 'DL201921001.csv'],
            ['DL202011001.csv', 'DL202021001.csv', 'DL202021002.csv']]
OUT_PREFIX = 'jp'


def get_year(filename):
    matched = re.findall('DL(20..)', filename)
    if len(matched) == 0:
        return None
    return matched[0]


def test():
    parser = AccountParserForInitialBudget()
    writer = AccountFileWriter()
    infolist = parser.parse_file('test.csv')
    for info in infolist[0:10]:
        info.print()
        print()
    writer.write_file(infolist, 'out.csv', 2015)


def main():
    parser = AccountParser()
    writer = AccountFileWriter()
    for fnames in FILELIST:
        initial_file = fnames[0]
        year = get_year(initial_file)
        out_filename = DATA_DIR + OUT_PREFIX + year + '.csv'
        in_filenames = list(map(lambda f: DATA_DIR + f, fnames))

        infolist = parser.parse_files(in_filenames)
        writer.write_file(infolist, out_filename, year)


if __name__ == '__main__':
    main()
