#-*- coding: utf-8 -*-
#用户名和手机号码可以登录
f = open('user.txt')
arr = f.read().split('\n')
f.close()
user_list=[]
telephone_list=[]
pwd_list=[]
input_u_n = raw_input('please enter your name or telepone number:')
for i in arr:
    user_arr = i.split(':')
    user_list.append(user_arr[0])
    telephone_list.append(user_arr[1])
    pwd_list.append(user_arr[2])
if input_u_n  in user_list:
    input_pwd = raw_input('please enter passwd:')
    if input_pwd == pwd_list[user_list.index(input_u_n)]:
        print 'login sucess'
    else:
        print 'wrong passwd'
elif input_u_n in telephone_list:
    input_pwd = raw_input('please enter passwd:')
    if input_pwd == pwd_list[telephone_list.index(input_u_n)]:
        print 'login sucess'
    else:
        print 'wrong passwd'
else:
    print 'user no exist'
