from account_parser_for_initial_budget import AccountParserForInitialBudget
from account_parser_for_supplementary_budget import AccountParserForSupplementaryBudget


class AccountParser(object):
    def __init__(self):
        self.parser0 = AccountParserForInitialBudget()
        self.parser1 = AccountParserForSupplementaryBudget()

    def parse_files(self, budget_files):
        initial_budget_file = budget_files[0]
        supplementary_budget_files = budget_files[1:]

        infolist = self.parser0.parse_file(initial_budget_file)
        for fname in supplementary_budget_files:
            infolist = self.parser1.parse_file(fname, infolist)
        return infolist
