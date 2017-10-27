l1=['js','C','js','python','js','css','js','html','node']
count = 0
for i in l1:
    print i
    if i == 'js':
        count += 1
    else:
        exit
print "js is number:%s" % count
