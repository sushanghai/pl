M = 10000
Y = 0
l1 = 0.0325
while M <= 20000:
    M = M+(M*0.0325)
    Y += 1
    print "%s year is %s"% (Y,M) 
print "year is:%s"% Y
