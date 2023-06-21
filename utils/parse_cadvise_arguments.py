import argparse


parser = argparse.ArgumentParser(
                    prog='gaia-cadvise',
                    description='Runs streaming experiments and measures the behaviour of AWS server and clients',
                    epilog='Text at the bottom of help')

parser.add_argument('--players')