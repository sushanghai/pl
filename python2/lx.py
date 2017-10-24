sum = 0
count = 0
while True:
    num = raw_input('please input a not 0 number :')
    if num == '':
        continue
    elif num != '0':
        sum += int(num)
        count += 1
    else:
        break
average = sum/count
print "sum is:%s" % sum  
print "average is:%s" % average
