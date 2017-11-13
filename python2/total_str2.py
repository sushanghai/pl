#coding: utf-8
#统计所出现字符的次数
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
#统计出现前十名的字符
ks=res.keys()
res2=[]
for j not in res2:
    if j == ' ' and j == ',':
        continue
    else:
        res2.append(j)
print res2 
