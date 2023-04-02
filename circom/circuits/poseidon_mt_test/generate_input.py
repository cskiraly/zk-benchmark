import json
import random
import sys

logsize = int(sys.argv[1])
size = 2 ** logsize

dictionary = {'in':[random.randrange(2**64)  for i in range(size)]}
jsonString = json.dumps(dictionary, indent=4)
jsonFile = open("input_%d.json" % (logsize), "w")
jsonFile.write(jsonString)
jsonFile.close()