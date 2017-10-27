M = 10000
l1 = 0.0325
Y = 0
while M <= 20000:
    M = M*(1+l1)
    Y += 1
    print "%s year is %.2f"% (Y,M) 
print "year is:%s"% Y
