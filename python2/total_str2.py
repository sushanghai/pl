#coding: utf-8
#统计所出现字符的次数
cont_str='firstdfdf fdfdfderererrr funk i of all,iwant makeitclear itso'
res={}
for i in cont_str:
    if i == ' ' and i == ',':
        continue
    elif i in res:
        res[i] +=1
    else:
        res[i]=1
#dict转换成list
res_list=[]
for k in res:
        res_list.append([k,res[k]])

#统计出现前十名的字符
for i in range(10):
    for j in range(len(res_list)-1):
        if res_list[j][1]>res_list[j+1][1]:
	    res_list[j],res_list[j+1]=res_list[j+1],res_list[j]
print res_list
print res_list[-10:]
for r in res_list[-10:]:
    print 'char %s count is %s ' % (r[0],r[1])
   # print 'char %s count is %s ' % tuple(r)
