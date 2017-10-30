num_arr = [1,2,3,4,5,6,7,8,9]
for i in num_arr:
    temp =''
    for j in num_arr:
        if j <= i:
            temp += "%s*%s=%s "%(i,j,i*j)
    print temp
