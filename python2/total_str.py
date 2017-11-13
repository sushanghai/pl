cont_str='''first of all ,i want make it clear'''
res={}
for i in cont_str:
    if i == '' and i == ',':
        continue
    elif i in res:
        res[i] +=1
    else:
        res[i]=1

print res
