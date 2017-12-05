with open('user.txt') as f:
    #user_list = f.read().split('\n')
    #user_list = f.readline().split('\n')
    user_list=f.readlines()
    user_pwd_list = []
    user_dict ={}
    for i in user_list:
        line=i.strip()
	user_pwd_list.append(line)
 #   print user_pwd_list
    for i in user_pwd_list:
        temp=i.split(':')
#	print temp[0],temp[1]
        user_dict[temp[0]]=temp[1]
    ulist=user_dict.items()
    for user in ulist:
        print user[0],user[1]
