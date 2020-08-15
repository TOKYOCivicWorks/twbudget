def is_number_string(string):
    try:
        int(string)
    except:
        return False
    return True


def parse_number(string):
    # '△ 75,684' -> '-75684'
    string_replaced_minus = string.replace('△', '-')
    string_wo_comma = string_replaced_minus.replace(',', '')
    string_wo_space = string_wo_comma.replace(' ', '')
    if len(string_wo_space) > 0 and is_number_string(string_wo_space):
        return int(string_wo_space)
    else:
        return None
