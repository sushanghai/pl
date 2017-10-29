#coding=utf-8
#求列表中最大的两值
unsort_list=[1,7777,2,3,4,3,22,45,6555,6555,4111]
max_num = 0
sec_num = 0
for i in unsort_list:
    if i > max_num:
        sec_num = max_num
	max_num = i
    elif i > sec_num:
        sec_num = i
print "最大的两个值为:%s,%s" %(max_num,sec_num)
