#! /usr/bin/env python
import screed, sys, itertools

s1_file = sys.argv[1]

n = 1

for read in itertools.izip(screed.open(s1_file)):
    name = read.name 
if n%2!=0:
	name += '/1'
else:
	name += '/2'
n += 1
print '@%s\n%s\n+\n%s\n@%s\n%s\n+\n%s' % (name,
                                         read.sequence,
                                         read.accuracy,
                                         )
