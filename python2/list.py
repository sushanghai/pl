l1=[99999,1,2,3,2,12,3,21,2,2,3,4111,22,3333,444,111,4,5,777,65555,45,33,45]
max = 0
for i in l1:
    if max < i:
        max = i
    else:
        exit
print "max is %s"% max
