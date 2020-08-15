from hash_utils import calc_n_digit_hash


NUM_DIGITS_SECTION = 3
NUM_DIGITS_ORGANIZATION = 3
NUM_DIGITS_ACCOUNT_GROUP_NAME = 6


def calc_combined_account_code(info):
    # Calculate new account code where should be 1to1 correspondence between
    # each new combined account info and this code:
    # section,organization,account_group_name,category_code
    #   -> 'abc.def.lmnopq.95'
    return calc_n_digit_hash(info.section, NUM_DIGITS_SECTION) + '.' + \
        calc_n_digit_hash(info.organization, NUM_DIGITS_ORGANIZATION) + '.' + \
        calc_n_digit_hash(info.account_group_name, NUM_DIGITS_ACCOUNT_GROUP_NAME) + '.' + \
        info.get_category_code()


class CombinedAccountInfo(object):
    def __init__(self, initial_element=None):
        self.section = None
        self.organization = None
        self.account_group_code = None
        self.combined_account_code = None
        self.account_group_name = None
        self.category_code = None
        self.total_amount = None
        self.account_infolist = []
        if initial_element != None:
            self._register_initial_element(initial_element)

    def add(self, info):
        if not self._check_new_one(info):
            print('[ERROR] new one is not appropriate')
            print('== CombinedAccountInfo ==')
            self.print()
            print('== new AccountInfo ==')
            info.print()
            return False
        self.account_infolist.append(info)
        self.total_amount += info.amount
        return True

    def print(self):
        print('section: %s' % self.section)
        print('organization: %s' % self.organization)
        print('account-group-code: %s' % self.account_group_code)
        print('combined-account-code: %s' % self.combined_account_code)
        print('account-group-name: %s' % self.account_group_name)
        print('category-code: %s' % self.category_code)
        print('total-amount: %s' % self.total_amount)

    def _check_new_one(self, info):
        return info.section == self.section \
            and info.organization == self.organization \
            and info.account_group_code == self.account_group_code \
            and info.account_group_name == self.account_group_name \
            and info.get_category_code() == self.category_code \
            and calc_combined_account_code(info) == self.combined_account_code

    def _register_initial_element(self, info):
        self.section = info.section
        self.organization = info.organization
        self.account_group_code = info.account_group_code
        self.combined_account_code = calc_combined_account_code(info)
        self.account_group_name = info.account_group_name
        self.category_code = info.get_category_code()
        self.total_amount = info.amount
        self.account_infolist = [info]
