import csv
import io

from account_info import AccountInfo
from parser_utils import parse_number


class AccountParserForInitialBudget(object):
    def __init__(self):
        pass

    def parse_file(self, fname):
        infolist = []
        label = AccountInfo()
        print('[INFO] Open', fname)
        with open(fname, 'r', newline='', encoding='utf-8') as f:
            csv_reader = csv.reader(f, delimiter=',')
            for line in csv_reader:
                info = self._parse_splitted_line(line)
                is_valid_info = info.valid_info()
                label.overwrite_by_valid_slots(info)
                if is_valid_info:
                    info.refill_to_empty_slots(label)
                    infolist.append(info)
        return infolist

    def _parse_splitted_line(self, data):
        info = AccountInfo()
        info.section = data[0]
        info.organization = data[1]
        info.account_group_code = data[2]
        # (95,011,2,20,4,15) -> '95011220415'
        info.account_code = ''.join(data[3:9])
        info.account_group_name = data[9]
        info.account_name = data[10]
        info.amount = parse_number(data[11])
        return info
