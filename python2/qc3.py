arr2 = [1,2,3,4,2,12,3,14,12,3,12,3,14,3,21]
arr1 = [2,1,3,2,45,234,254,14,21,14]
arr3 = []
arr4 = []
arr5 = []
count = 0
for i in arr1:
    count +=1
    if i not in arr3:
        arr3.append(i)
print 'arr3:%s'% arr3
for j in arr2:
    if j not in arr4:
	arr4.append(j)
print 'arr4:%s'% arr4
for i_arr3 in arr3:
     for j_arr4 in arr4:
         if i_arr3 == j_arr4:
	     arr5.append(i_arr3)
	 else:
	     continue
print 'arr5:%s'% arr5
print count 
