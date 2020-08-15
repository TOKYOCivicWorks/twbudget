class AccountInfo(object):
    _LABELS = ('section',
               'organization',
               'account-group-code',
               'account-code',
               'account-group-name',
               'account-name',
               'amount')

    def __init__(self):
        self.section = None
        self.organization = None
        self.account_group_code = None
        self.account_code = None
        self.account_group_name = None
        self.account_name = None
        self.amount = None

    def equal(self, other):
        return self.equal_except_for_amount(other) \
            and self.account_amount == other.account_amount

    def equal_except_for_amount(self, other):
        return self.section == other.section \
            and self.organization == other.organization \
            and self.account_group_code == other.account_group_code \
            and self.account_code == other.account_code \
            and self.account_group_name == other.account_group_name \
            and self.account_name == other.account_name

    def get_category_code(self):
        # '95011212999' -> '95'
        if self.account_code is None:
            return None
        return self.account_code[0:2]

    def overwrite_by_valid_slots(self, child):
        if self._valid_slot(child.section):
            self.section = child.section
        if self._valid_slot(child.organization):
            self.organization = child.organization
        if self._valid_slot(child.account_group_code):
            self.account_group_code = child.account_group_code
        if self._valid_slot(child.account_code):
            self.account_code = child.account_code
        if self._valid_slot(child.account_group_name):
            self.account_group_name = child.account_group_name
        if self._valid_slot(child.account_name):
            self.account_name = child.account_name
        if self._valid_slot(child.amount):
            self.amount = child.amount

    def print(self):
        print('section: %s' % self.section)
        print('organization: %s' % self.organization)
        print('account-group-code: %s' % self.account_group_code)
        print('account-code: %s' % self.account_code)
        print('account-group-name: %s' % self.account_group_name)
        print('account-name: %s' % self.account_name)
        print('amount: %s' % self.amount)
        print('valid: %s' % self.valid_info())

    def refill_to_empty_slots(self, label):
        if self._empty_slot(self.section) and self._valid_slot(label.section):
            self.section = label.section
        if self._empty_slot(self.organization) and self._valid_slot(label.organization):
            self.organization = label.organization
        if self._empty_slot(self.account_group_code) and self._valid_slot(label.account_group_code):
            self.account_group_code = label.account_group_code
        if self._empty_slot(self.account_code) and self._valid_slot(label.account_code):
            self.account_code = label.account_code
        if self._empty_slot(self.account_group_name) and self._valid_slot(label.account_group_name):
            self.account_group_name = label.account_group_name
        if self._empty_slot(self.account_name) and self._valid_slot(label.account_name):
            self.account_name = label.account_name
        if self._empty_slot(self.amount) and self._valid_slot(label.amount):
            self.amount = label.amount

    def valid_info(self):
        return self.account_code != None and len(self.account_code) > 0 \
            and self.amount != None and type(self.amount) is int \
            and self.account_name != None and len(self.account_name) > 0

    def _empty_slot(self, slot):
        return slot == None or slot == ''

    def _valid_slot(self, slot):
        return slot != None and slot != ''
