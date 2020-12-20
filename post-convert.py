#!/usr/bin/python

import argparse
import re

parser = argparse.ArgumentParser(description="Clean up asciidoc which has been exported using the Google doc asciidoc exporter")
parser.add_argument('files', metavar='N', type=str, nargs='+',
                    help='files to clean up')
args = parser.parse_args()


replacements = {r"\+(\Z|$)": '', "^== ":"= "}
for filename in args.files:
    with open(filename) as infile, open(filename + "_", 'w') as outfile:
        for line in infile:
            for src, target in replacements.items():
                line = re.sub(src, target, line)
            outfile.write(line)
