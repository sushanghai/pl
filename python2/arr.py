arr_list=range(10000)
print arr_list
start=0
end=len(arr_list)-1
find_num=2000
while True:
    mid = (start+end)/2
    print mid
    mid_num = arr_list[mid]
    print mid_num
    if find_num < mid_num:
        end = mid
    elif find_num > mid_num:
        start = mid
    else:
        print 'find',mid
	break
