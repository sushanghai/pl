#coding:utf-8
#!/usr/bin/python
#引入模块
from flask import Flask,request,render_template,redirect,session
from flask_script import Manager
from flask_bootstrap import Bootstrap
import MySQLdb as mysql
import sys
#系统汉字
reload(sys)
sys.setdefaultencoding('utf-8') 
#
app = Flask(__name__)
#bootstrap
manager = Manager(app)
bootstrap = Bootstrap(app)

#sql连接语句
user='mypython'
passwd='mypython'
host='127.0.0.1'
db='python'
conn = mysql.connect(host,user,passwd,db,charset='utf8')
conn.ping(True)
conn.autocommit(True)
cur=conn.cursor()

#cur.execute('select * from jifeng_aw')
#print cur.fetchall()
#total_sql = cur.execute('select total_aw from jifeng_total')
#print cur.fetchall()

#fileutil.read_file()
#登录加密
app.secret_key = 'A0Zr98j/3yXdR~XHH!jmN]LWX/,?RT'

#主页面目录
@app.route('/',methods=['GET', 'POST'])
def index():
    if 'username' in session:
        return redirect('/list')
    select_aw_sql = cur.execute('select datetime,name,integral from jifeng_aw')
    list1 = cur.fetchall()
    select_yy_sql = cur.execute('select datetime,name,integral from jifeng_yy')
    list2 = cur.fetchall()
    total_sql = cur.execute('select total_aw,total_yy from jifeng_total')
    list3 = cur.fetchall()
    return render_template('index.html',userlist=list1,yylist=list2,totallist=list3)

#list页面
@app.route('/list')
def add_list():
    return redirect('/add')

#添加页面
@app.route('/add')
def add():
    select_aw_sql = cur.execute('select datetime,name,integral from jifeng_aw')
    list1 = cur.fetchall()
    select_yy_sql = cur.execute('select datetime,name,integral from jifeng_yy')
    list2 = cur.fetchall()
    total_sql = cur.execute('select total_aw,total_yy from jifeng_total')
    list3 = cur.fetchall()
    lable_sql = cur.execute('select jifeng_lable,jifeng_value from jifeng_lable_value')
    list4 = cur.fetchall()
    return render_template('aw_list.html',userlist=list1,yylist=list2,totallist=list3,lablelist=list4)

#删除页面
@app.route('/del')
def del_aw_yy():
    aw = request.args.get('aw')
    action = request.args.get('action')
    yy = request.args.get('yy')
    aw_del_sql = 'delete from jifeng_aw where datetime="%s"'%(aw)
    yy_del_sql = 'delete from jifeng_yy where datetime="%s"'%(yy)
    action_del_sql = 'delete from jifeng_lable_value where jifeng_value="%s"'%(action)
    sum_sql_aw ='update jifeng_total set total_aw = (select sum(integral) from jifeng_aw) where id = 1' 
    sum_sql_yy ='update jifeng_total set total_yy = (select sum(integral) from jifeng_yy) where id = 1' 
    cur.execute(yy_del_sql)
    cur.execute(aw_del_sql)
    cur.execute(action_del_sql)
    cur.execute(sum_sql_aw)
    cur.execute(sum_sql_yy)
    return redirect('/add')

#阿伍积分加分按扭
@app.route('/add_aw')
def add_aw():
    name = request.args.get('name')
    integral = request.args.get('integral')
    erro_msg = ''
    if name and integral:
        insert_sql = 'insert into jifeng_aw (datetime,name,integral) values (now(),"%s","%s")'%(name,integral)
        sum_sql ='update jifeng_total set total_aw = (select sum(integral) from jifeng_aw) where id = 1' 
        cur.execute(insert_sql)
        cur.execute(sum_sql)
        return redirect('/add')
    else:    
        erro_msg="项目和积分不能为空" 
        select_aw_sql = cur.execute('select datetime,name,integral from jifeng_aw')
        list1 = cur.fetchall()
        select_yy_sql = cur.execute('select datetime,name,integral from jifeng_yy')
        list2 = cur.fetchall()
        total_sql = cur.execute('select total_aw,total_yy from jifeng_total')
        list3 = cur.fetchall()
        lable_sql = cur.execute('select jifeng_lable,jifeng_value from jifeng_lable_value')
        list4 = cur.fetchall()
        return render_template('aw_list.html',erro_msg=erro_msg,userlist=list1,yylist=list2,totallist=list3,lablelist=list4)

#依依积分加分按扭
@app.route('/add_yy')
def add_yy():
    name = request.args.get('name')
    integral = request.args.get('integral')
    erro_msg = ''
    if name and integral:
        insert_sql = 'insert into jifeng_yy (datetime,name,integral) values (now(),"%s","%s")'%(name,integral)
        sum_sql ='update jifeng_total set total_yy = (select sum(integral) from jifeng_yy) where id = 1' 
        cur.execute(insert_sql)
        cur.execute(sum_sql)
        return redirect('/add')
    else:    
        erro_msg="项目和积分不能为空" 
        select_aw_sql = cur.execute('select datetime,name,integral from jifeng_aw')
        list1 = cur.fetchall()
        select_yy_sql = cur.execute('select datetime,name,integral from jifeng_yy')
        list2 = cur.fetchall()
        total_sql = cur.execute('select total_aw,total_yy from jifeng_total')
        list3 = cur.fetchall()
        lable_sql = cur.execute('select jifeng_lable,jifeng_value from jifeng_lable_value')
        list4 = cur.fetchall()
        return render_template('aw_list.html',erro_msg=erro_msg,userlist=list1,yylist=list2,totallist=list3,lablelist=list4)

#项目列表添加选项
@app.route('/add_project')
def add_project():
    lable = request.args.get('lable')
    action = request.args.get('action')
    erro_msg = ''
    if lable and action:
        insert_sql = 'insert into jifeng_lable_value (jifeng_lable,jifeng_value) values ("%s","%s")'%(lable,action)
        cur.execute(insert_sql)
        return redirect('/add')
    else:    
        erro_msg="两个表格都不能为空" 
        select_aw_sql = cur.execute('select datetime,name,integral from jifeng_aw')
        list1 = cur.fetchall()
        select_yy_sql = cur.execute('select datetime,name,integral from jifeng_yy')
        list2 = cur.fetchall()
        total_sql = cur.execute('select total_aw,total_yy from jifeng_total')
        list3 = cur.fetchall()
        lable_sql = cur.execute('select jifeng_lable,jifeng_value from jifeng_lable_value')
        list4 = cur.fetchall()
        return render_template('aw_list.html',erro_msg=erro_msg,userlist=list1,yylist=list2,totallist=list3,lablelist=list4)

#退出编辑按钮
@app.route('/logout')
def logout():
    session.pop('username')
    return redirect('/')

#登录编辑按钮
@app.route('/loginaction')
def login():
    user = request.args.get('user')
    pwd = request.args.get('pwd')
    erro_msg = ''
    if user and pwd:
        if user == 'admin' and  pwd == 'pwd':
             session['username'] = 'admin'
	     return redirect('/list')
	else:
	     erro_msg='用户或者密码错误!'
             select_aw_sql = cur.execute('select datetime,name,integral from jifeng_aw')
             list1 = cur.fetchall()
             select_yy_sql = cur.execute('select datetime,name,integral from jifeng_yy')
             list2 = cur.fetchall()
             total_sql = cur.execute('select total_aw,total_yy from jifeng_total')
             list3 = cur.fetchall()
             return render_template('index.html',erro_msg=erro_msg,userlist=list1,yylist=list2,totallist=list3)

    else:
        erro_msg='需要输入用户和密码方可编辑！'
        select_aw_sql = cur.execute('select datetime,name,integral from jifeng_aw')
        list1 = cur.fetchall()
        select_yy_sql = cur.execute('select datetime,name,integral from jifeng_yy')
        list2 = cur.fetchall()
        total_sql = cur.execute('select total_aw,total_yy from jifeng_total')
        list3 = cur.fetchall()
        return render_template('index.html',erro_msg=erro_msg,userlist=list1,yylist=list2,totallist=list3)

#路由起用端口
if __name__ == '__main__':
    app.run(host='0.0.0.0',port=9091)
  #  app.run(host='0.0.0.0',port=9091,debug=True)
