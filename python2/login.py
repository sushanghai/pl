#-*- coding: UTF-8 -*-
###用户名密码用分割，判断用户输入用户名和密码，判断能否登录
arr = ['user:pwd','user1:pwd1','user2:123']
input_user = raw_input('please enter your user:')
input_passwd = raw_input('please enter your passwd:')
user_pwd = input_user+':'+input_passwd
if user_pwd in arr:
    print 'login sucess'
else:
    print 'fail'
