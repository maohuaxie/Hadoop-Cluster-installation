#!/usr/bin/python

import sys
import json

for line in sys.stdin.readlines():
    try:
        r = json.loads(line.strip())
        print r['city']+"/"+r['state'] 
    except:
        None  ### we don't produce an output row
        
#!/usr/bin/python

import sys
import json

for line in sys.stdin.readlines():
    try:
        r = json.loads(line.strip())
        print r['city']+"/"+r['state'] 
    except:
        None  ### we don't produce an output row
#!/usr/bin/python
### checkin_by_city_reducer.py

import sys
import json
import numpy as np

current_city_state = None
city_state = None
reco = None

# the vector to aggregate checkins per hour per day
check_vec = np.zeros(7*24)
check_n = 0


# input comes from STDIN
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()

    # parse the input we got from mapper.py
    city_state, rjson = line.split('\t', 1)

    # convert count (currently a string) to int
    try:
        reco = json.loads(rjson)
    except ValueError:
        # count was not a number, so silently
        # ignore/discard this line
        continue

    # this IF-switch only works because Hadoop sorts map output
    # by key (here: word) before it is passed to the reducer
    if current_city_state == city_state:
        for k in reco['checkin_info'].keys():
            k2 = k.split('-')
            h = int(k2[0])
            d = int(k2[1])
            c = int(reco['checkin_info'][k])
            check_vec[h*7+d] += c
        check_n += 1
    else:
        if current_city_state and (check_n > 0):
            print '%s|%s' % (current_city_state, '|'.join([str(x) for x in check_vec/check_n]))
        current_city_state = city_state
        check_vec = np.zeros(7*24)
        for k in reco['checkin_info'].keys():
            k2 = k.split('-')
            h = int(k2[0])
            d = int(k2[1])
            c = int(reco['checkin_info'][k])
            check_vec[h*7+d] += c
        check_n = 1


# do not forget to output the last word if needed!
if current_city_state and (check_n > 0):
            print '%s|%s' % (current_city_state, '|'.join([str(x) for x in check_vec/check_n]))
#!/usr/bin/python
### checkin_join_reducer.py

## This reducer joins two data sets (business.json and checkin.json) on their business_id
import sys
import json
import numpy as np

current_bid = None
bid = None
reco = None

business_list = []
checkin_list = []

# input comes from STDIN
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()

    # parse the input we got from mapper.py
    bid, rjson = line.split('\t', 1)

    if current_bid == bid:
        if '"type": "checkin"' in rjson:
            checkin_list.append(rjson)
        else:
            business_list.append(rjson)
        
    else:
        if current_bid:
            for b in business_list:
                for c in checkin_list:
                    print '%s\t%s\t%s' % (current_bid, b.strip(), c.strip())
        current_bid = bid
        business_list = []
        checkin_list = []
        if '"type": "checkin"' in rjson:
            checkin_list.append(rjson)
        else:
            business_list.append(rjson)

# do not forget to output the last word if needed!
if current_bid == bid:
    for b in business_list:
        for c in checkin_list:
            print '%s\t%s\t%s' % (current_bid, b.strip(), c.strip())
            
#!/usr/bin/python
### checkin_by_city_mpr.py produces recrods with leading business_id
import sys
import json

for line in sys.stdin:
    try:
        r = json.loads(line.strip())
        print r['business_id']+"\t"+line.strip() 
    except:
        None  ### we don't produce an output row
 #!/usr/bin/env python

import sys
import json
# input comes from STDIN (standard input)
for line in sys.stdin:
    r = json.loads(line)
    for f in r['friends']:
        ## printing tab seperated lines from a list of values
        print '\t'.join([r['name'], r['user_id'], f])
