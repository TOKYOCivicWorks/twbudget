import csv
import io

from hash_utils import calc_n_digit_hash
from parser_utils import parse_number
from supplementary_account_info import SupplementaryAccountInfo


class AccountParserForSupplementaryBudget(object):
    def __init__(self):
        pass

    def parse_file(self, fname, infolist):
        label = SupplementaryAccountInfo()
        infolist_map = {}
        for info in infolist:
            infolist_map[self._calc_hash_key(info)] = info
        supplementary_infolist = []

        print('[INFO] Open', fname)
        with open(fname, 'r', newline='', encoding='utf-8') as f:
            csv_reader = csv.reader(f, delimiter=',')
            for line in csv_reader:
                info = self._parse_splitted_line(line)
                is_valid_nonzero_info = info.valid_nonzero_info()
                label.overwrite_by_valid_slots(info)
                if is_valid_nonzero_info:
                    info.refill_to_empty_slots(label)
                    supplementary_infolist.append(info)

        print('[DEBUG] supplementary_infolist.length: %d' %
              len(supplementary_infolist))

        for new_info in supplementary_infolist:
            self._append_new_info(new_info, infolist_map)
        return infolist_map.values()

    def _append_new_info(self, info, infolist_map):
        key = self._calc_hash_key(info)
        if key in infolist_map.keys():
            old = infolist_map[key]
            if not old.equal_except_for_amount(info):
                print(
                    '[ERROR] Old info should have the same slots as new info except for amount.')
                print('== old info ==')
                old.print()
                print('== new info ==')
                info.print()
            infolist_map[key] = info
        else:
            infolist_map[key] = info

    def _calc_hash_key(self, info):
        s = str(info.section)
        s += info.organization
        s += info.account_group_code
        s += info.account_code
        s += info.account_group_name
        s += info.account_name
        return calc_n_digit_hash(s)

    def _parse_splitted_line(self, data):
        info = SupplementaryAccountInfo()
        info.section = data[0]
        info.organization = data[1]
        info.account_group_code = data[2]
        # (95,011,2,20,4,15) -> '95011220415'
        info.account_code = ''.join(data[3:9])
        info.account_group_name = data[9]
        info.account_name = data[10]
        # 11: 当初予算額
        # 12: 補正要求・追加額
        # 13: 補正要求・減少額
        # 14: 補正要求・差引額
        info.correction_amount = parse_number(data[14])
        # 15: 補正予算額
        info.amount = parse_number(data[15])
        return info
