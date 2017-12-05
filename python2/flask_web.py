#coding:utf-8
#!/usr/bin/python27

import getMem2
import fileutil 
from flask import Flask,request,render_template,redirect
app = Flask(__name__)

fileutil.read_file()


@app.route('/')
def index():
    return render_template('login.html')

@app.route('/loginaction')
def login():
    user = request.args.get('user')
    pwd = request.args.get('pwd')
    erro_msg = ''
    if user and pwd:
        if user == 'admin' and  pwd == 'pwd':
	     return redirect('/list')
	else:
	     return 'wrong user or password!'
    return render_template('login.html',erro_msg=erro_msg)

@app.route('/list')
def userlist():
     return render_template('admin.html',userlist=fileutil.file_dict.items())



if __name__ == '__main__':
    app.run(host='0.0.0.0',port=9092,debug=True)
