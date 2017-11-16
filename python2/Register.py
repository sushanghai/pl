# coding:utf-8

uw = raw_input('enter your name:')
passwd = raw_input('enter your passwd:')
# uw = 'ddfdfa'
# passwd = '2324'


f = open('user.txt','r+')
user_dict={}
u = f.readlines()
# print u
#生成一个用户列表
for i in u:
    temp = i.split(':')
    # print temp[0]
    user_dict=temp[0]
# print user_dict
f.close()
# 判断用户是否存在,存在则显示存在；否则添加进文件
if uw in user_dict:
    print 'user_exist'
    # break
else:
    w = open('user.txt','a')
    w.write(uw+':'+passwd+'\n')
    w.close()
    print '用户注册成功'
