#coding:utf-8
#!/usr/bin/python27

import getMem2
from flask import Flask,request,render_template
app = Flask(__name__)



@app.route('/')
def index():
    user_list=[['rebo2t','123'],['admin','admin']]
    return render_template('login.html',erro_msg='xxx',ulist=user_list)
    #return render_template('index.html')
    #return render_template(getMem2.getMem())
    # print getMem2.getMem()
    # return getMem2.getMem()
#    return 'hello world'
def check_login(user,pwd):
    with open('user.txt') as f:
         user_list = f.read().split('\n')
	 user_pwd = '%s:%s'%(user,pwd)
	 if user_pwd in user_list:
	     return 'success'
	 else:
	     return 'erro'
@app.route('/login')
def web_html():
    user = request.args.get('user')
    pwd = request.args.get('pwd')

    return check_login(user,pwd)



if __name__ == '__main__':
    app.run(host='0.0.0.0',port=9092,debug=True)
