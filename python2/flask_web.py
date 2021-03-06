#coding:utf-8

from flask import Flask,request,render_template,redirect,session
app = Flask(__name__)
import MySQLdb as mysql

conn = mysql.connect(user='shanghai',passwd='shanghai',host='192.168.70.221',db='user_pwd')
conn.autocommit(True)
cur = conn.cursor()
#cur.execute('select user from userpwd')
#print cur.fetchall()

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
     sql = 'delete from userpwd where user="%s"'%(user)
     cur.execute(sql)
     #fileutil.file_dict.pop(user)
     #fileutil.write_file()
     return redirect('/list')

@app.route('/adduser')
def adduser():
     user = request.args.get('user')
     pwd = request.args.get('pwd')
     sql1 = 'select user from userpwd where user="%s"'%(user)
     cur.execute(sql1)
     print cur.fetchall()
     print user
     if user in cur.fetchall():
         print "exist"
         return redirect('/list')
     else:
         sql='insert into userpwd values("%s","%s")'%(user,pwd)
         cur.execute(sql)
         return redirect('/list')

@app.route('/update')
def updae_user():
    user = request.args.get('user')
    select_pwd = 'select pwd from userpwd where user="%s"'%(user)
    pwd = cur.execute(select_pwd)
    #pwd = fileutil.file_dict.get(user)
    return render_template('update.html',user=user,pwd=pwd)

@app.route('/updateaction')
def updateaciton():
    user = request.args.get('user')
    new_pwd = request.args.get('new_pwd')
    update_sql = 'update userpwd set pwd="%s" where user="%s"'%(new_pwd,user)
    cur.execute(update_sql)
    #fileutil.file_dict[user] = new_pwd
    #fileutil.write_file()
    return redirect('/list')

@app.route('/list')
def userlist():
     cur.execute('select * from userpwd')
     if 'username' in session:
         return render_template('admin.html',userlist=cur.fetchall())
     else:
         return redirect('/')
if __name__ == '__main__':
    app.run(host='0.0.0.0',port=9092,debug=True)
