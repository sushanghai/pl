#coding:utf-8
#!/usr/bin/python27

import getMem2
from flask import Flask,request,render_template
app = Flask(__name__)



@app.route('/')
def index():
    return render_template('login.html')
    #return render_template('index.html')
    #return render_template(getMem2.getMem())
    # print getMem2.getMem()
    # return getMem2.getMem()
#    return 'hello world'
def check_login(user,pwd):
    with open('user.txt') as f:
         user_line = f.read().split('\n')
         user_list = f.readlines()
	 user_pwd_list = []
	 user_dict = {}
	 for i in user_list:
	     temp = i.strip()
	     user_pwd_list.append(temp)
	 for j in user_pwd_list:
	     line = j.split(':')
	     user_dict[line[0]]=line[1]
	 #print user_dict.items()
	 temp_list=user_dict.items()
         #print temp_list
	     
	 user_pwd = '%s:%s'%(user,pwd)
	 #print user_pwd
	 #print user_line
	 if user_pwd in user_line:
	     if user_pwd == '%s:%s'%('admin','pwd'):
	         return 'heloo' 
	     else:
	         return 'erro'
	 else:
	     return 'erro'
@app.route('/login')
def login_html():
    user = request.args.get('user')
    pwd = request.args.get('pwd')

    return check_login(user,pwd)



if __name__ == '__main__':
    app.run(host='0.0.0.0',port=9092,debug=True)
