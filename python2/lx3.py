sum = 0
while True:
    num = raw_input('please input a not 0 number :')
    #if num == '':
    if num == '':
        continue
    elif num != '0':
        sum += int(num)
    else:
        break
print "sum is:%s" % sum  
