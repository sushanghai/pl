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
#print res
#反转dict 让值:字符,然后取出.sort排序把前10取出来，然后遍历，去反转后的dict里获取字符值:[字符1，字符2]
reverse_res ={}
for k in res:
#    print res[k]
    if res[k] in reverse_res:
        reverse_res[res[k]].append(k)
    else:
        reverse_res[res[k]] = [k]
#print reverse_res
#for r in reverse_res:
#    print r,reverse_res[r]
key_list=[]
for k in reverse_res:
    key_list.append(k)
#正常排序
key_list.sort()
#倒排序
#key_list.reverse()
count = 0
while count<3:
    val = key_list.pop()
    print val
    for k in reverse_res[val]:
        print 'chart %s,count is %s' %(k,val)
	count +=1

