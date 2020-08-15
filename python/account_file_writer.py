import csv
import hashlib
import io

from account_info import AccountInfo
from category_code import get_category_name, get_super_category_name
from combined_account_info import CombinedAccountInfo, calc_combined_account_code, calc_n_digit_hash


class AccountFileWriter(object):
    def __init__(self):
        pass

    def write_file(self, infolist, filename, year):
        combined_infolist = self._combine_infolist(infolist)

        with open(filename, 'w', newline='') as f:
            writer = csv.writer(f, delimiter=',')
            writer.writerow(['year', 'code', 'amount', 'name',
                             'topname', 'depname', 'depcat', 'cat', 'ref'])
            for cinfo in combined_infolist.values():
                # year,code,amount,name,topname,depname,depcat,cat,ref
                name = self._calc_name_to_write(cinfo, combined_infolist)
                code = cinfo.combined_account_code
                amount = self._modify_currency_unit(cinfo.total_amount)
                topname = cinfo.section
                depname = cinfo.organization
                try:
                    depcat = get_category_name(cinfo.category_code)
                    cat = get_super_category_name(cinfo.category_code)
                except:
                    print('[ERROR] An error caused. cinfo is as below.')
                    print('== cinfo ==')
                    cinfo.print()
                    raise Exception(
                        '[ERROR] get_category_name() or get_super_category_name() failed.')
                ref = self._calc_breakdown_ratio_description(cinfo)
                row = [year, code, amount, name,
                       topname, depname, depcat, cat, ref]
                writer.writerow(row)
        print('[INFO] wrote to %s' % filename)

    def _calc_breakdown_ratio_description(self, cinfo):
        # return 'AAAX% BBBY% CCCZ%'
        ret = ''
        ratio_list = {}

        for info in cinfo.account_infolist:
            ratio = info.amount / cinfo.total_amount * \
                100 if cinfo.total_amount > 0.0 else 0.0
            ratio_list[info.account_name] = ratio
        sorted_ratio_list = sorted(
            ratio_list.items(), key=lambda x: x[1], reverse=True)

        for name, ratio in sorted_ratio_list:
            if len(ret) > 0:
                ret += ' '
            ret += name + '{:.1f}'.format(ratio) + '%'
        return ret

    def _calc_name_to_write(self, cinfo, cinfolist):
        if self._check_if_duplicated_account_group_info_exists(
                cinfo, cinfolist):
            return cinfo.account_group_name + \
                '(' + get_category_name(cinfo.category_code) + ')'
        else:
            return cinfo.account_group_name

    def _check_if_duplicated_account_group_info_exists(self, cinfo, cinfolist):
        # Check if another account info, whose account_group_name, organization,
        # section is same but account_name is different, exists.
        for other in cinfolist.values():
            if other.account_group_name == cinfo.account_group_name \
               and other.organization == cinfo.organization \
               and other.section == cinfo.section \
               and other != cinfo:
                return True
        return False

    def _combine_infolist(self, infolist):
        result = {}
        for info in infolist:
            new_code = calc_combined_account_code(info)

            if new_code not in result:
                result[new_code] = CombinedAccountInfo(info)
            else:
                result[new_code].add(info)
        return result

    def _modify_currency_unit(self, amount):
        return amount * 1000
