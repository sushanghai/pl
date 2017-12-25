#coding:utf-8

import getMem2
import fileutil 
from flask import Flask,request,render_template,redirect,session
app = Flask(__name__)


fileutil.read_file()
app.secret_key = 'A0Zr98j/3yX R~XHH!jmN]LWX/,?RT'


@app.route('/')
def index():
    if 'username' in session:
         return redirect('/list')
    return render_template('login.html')

@app.route('/loginaction')
def login():
    user = request.args.get('user')
    pwd = request.args.get('pwd')
    erro_msg = ''
    if user and pwd:
        if user == 'admin' and  pwd == 'pwd':
	     session ['username'] = 'admin'
	     return redirect('/list')
	else:
	     erro_msg='wrong user or password!'
    else:
        erro_msg = 'need user and pwd'
    return render_template('login.html',erro_msg=erro_msg)
@app.route('/logout')
def logout():
    session.pop('username')
    return redirect('/')
@app.route('/del')
def del_user():
     user = request.args.get('user')
     fileutil.file_dict.pop(user)
     fileutil.write_file()
     return redirect('/list')

@app.route('/adduser')
def adduser():
     user = request.args.get('user')
     pwd = request.args.get('pwd')
     if user in fileutil.file_dict:
         return redirect('/list')
     else:
         fileutil.file_dict[user]=pwd
         fileutil.write_file()
         return redirect('/list')

@app.route('/update')
def updae_user():
    user = request.args.get('user')
    pwd = fileutil.file_dict.get(user)
    return render_template('update.html',user=user,pwd=pwd)

@app.route('/updateaction')
def updateaciton():
    user = request.args.get('user')
    new_pwd = request.args.get('new_pwd')
    fileutil.file_dict[user] = new_pwd
    fileutil.write_file()
    return redirect('/list')

@app.route('/list')
def userlist():
     if 'username' in session:
         return render_template('admin.html',userlist=fileutil.file_dict.items())
     else:
         return redirect('/')
if __name__ == '__main__':
    app.run(host='0.0.0.0',port=9092,debug=True)
