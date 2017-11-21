# coding: utf8
f = open('tms.hnscar.com.error.log')
res_dict={}
for line in f:
    if line == '\n':
        continue
    temp = line.split()
    tup = (temp[0],temp[8])
    res_dict[tup] = res_dict.get(tup,0)+1
for (ip,status),count in res_dict.items():
    print 'ip is %s ,status is %s,count is %s'%(ip,status,count)
