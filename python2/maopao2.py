arr = [5,7,1,311,2333,24,2,5,6]
count = 0
index_max=len(arr)-1
for j in range(index_max):
    for i in range(index_max):
        count += 1
        if arr[i]>arr[i+1]:
            arr[i],arr[i+1]=arr[i+1],arr[i]
    print arr
print count
