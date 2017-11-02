#-*- coding: UTF-8 -*-
###用户名密码用分割，判断用户输入用户名和密码，判断能否登录
arr = ['user:pwd','user1:pwd1','user2:123']
input_user = raw_input('please enter your user:')
input_passwd = raw_input('please enter your passwd:')
user_list =[]
pwd_list =[]
for i in range(len(arr)):
    user_arr = arr[i].split(':')
    user_list.append(user_arr[0])
    pwd_list.append(user_arr[1]) 
if input_user in user_list:
    if input_passwd == pwd_list[user_list.index(input_user)]:
        print 'login sucess'
    else:
        print 'wrong passwd'
else:
        print "user not exist"
