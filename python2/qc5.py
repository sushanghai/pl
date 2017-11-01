arr1 = [1,2,3,4,2,12,3,14,12,3,12,3,14,3,21]
arr2 = [2,1,3,2,45,234,254,14,21,14]
arr3 = []
count = 0
for i in arr2:
    count +=1
    if i not in arr3 and i in arr1:
        arr3.append(i)
print 'arr3:%s'% arr3
print count 
