import hashlib


def calc_n_digit_hash(string, n=32):
    return hashlib.md5(string.encode('utf-8')).hexdigest()[0:n]
