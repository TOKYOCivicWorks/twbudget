from account_info import AccountInfo


class SupplementaryAccountInfo(AccountInfo):
    def __init__(self):
        super(SupplementaryAccountInfo, self).__init__()
        self.correction_amount = None

    def equal(self, other):
        return super(SupplementaryAccountInfo, self).equal(other) \
            and self.correction_amount == other.correction_amount

    def print(self):
        super(SupplementaryAccountInfo, self).print()
        print('correction_amount: %s' % self.correction_amount)

    def valid_info(self):
        return super(SupplementaryAccountInfo, self).valid_info() \
            and self.correction_amount != None and type(self.correction_amount) is int

    def valid_nonzero_info(self):
        return self.valid_info() and abs(self.correction_amount) > 0
