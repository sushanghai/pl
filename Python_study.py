
#1.用户输入信息
temp = input("大家好")
#例子:
###这是一个猜字游戏
temp = input("猜猜我心里想的是哪个数,1-20：")
guess = int(temp)
if guess == 8:
   print("我靠，你是我肚子里的蛔虫吗?")
   pritn("哼，猜对也没有奖励")
else:
	if guess > 8 :
		print("大了大了")
	else:
		print("嘿，小了小了")
print("不玩了，游戏结束了！")


"""1.原始字符串使用:在声明变量之前加上小写字母r，在字符串结尾不能加上符号
str = r'c:\now\'
"""
"""2.三重引号
例子
要打印以下的一行的句子
两个黄鹂鸣翠柳，
一行白鹭上青天。
窗含西岭千秋雪，
门泊东吴万里船。
"""
>>> str = """两个黄鹂鸣翠柳，
一行白鹭上青天。
窗含西岭千秋雪，
门泊东吴万里船。"""
>>> print(str)
两个黄鹂鸣翠柳，
一行白鹭上青天。
窗含西岭千秋雪，
门泊东吴万里船。

"""
4.while循环
while 条件:
	条件为true执行

例子:"""

print(" ###这是一个猜数字游戏### ")
temp = input("猜猜我心里想的是哪个数,1-20：")
guess = int(temp)
while guess != 8:
   temp = input("猜错了，继续猜：")
   guess = int(temp)
   if guess == 8:
      print("我靠，你是我肚子里的蛔虫吗?")
      print("哼，猜对也没有奖励")
   else:
     if guess > 8 :
        print("大了大了")
     else:
        print("嘿，小了小了")
print("不玩了，游戏结束了！")
"""
5.随机数random.ranint(1,10)生成一个1，10的随机数
example:
"""
import random
sercrt = random.randint(1,20)

print(" ###这是一个猜数字游戏### ")
temp = input("猜猜我心里想的是哪个数,1-20：")
guess = int(temp)
while guess != sercrt:
   temp = input("猜错了，继续猜：")
   guess = int(temp)
   if guess == sercrt:
      print("我靠，你是我肚子里的蛔虫吗?")
      print("哼，猜对也没有奖励")
   else:
     if guess > sercrt:
        print("大了大了")
     else:
        print("嘿，小了小了")
print("不玩了，游戏结束了！")
"""
6.算术写法
"""
>>> a = b = c = d = 10
>>> a +=3
>>> b -=3
>>> c *= 10
>>> d /= 8
>>> a
13
>>> c
100
>>> b
7
>>> d
1.25
"""
取余数
"""
>>> 11 % 2  11除以2余1
1
"""
7.打飞机框架
加载背景音乐
播放背景音乐(设置单曲循环)
我方飞机诞生
interval = 0 

while True:
	if 用户是否关闭了关闭按钮:
		退出程序
		break
	interval += 1
	if interval = 50;
		interval = 0
		小飞机诞生
		
	小飞机移动一个位置
	屏幕刷新	

	if 用户鼠标产生移动:
		我方飞机中心位置 = 用户鼠标位置
		屏幕刷新

	if 我方飞机与小飞机发生肢体冲突:
		我方挂，播放撞机音乐
		修改我方飞机图案
		打印"Game over"
		停止背景音乐，最好淡出
"""

"""
8.分数打印100-90分打A,90-80打B ,80-70打C,70-60打D.
方法一: 8-1
"""
score = int(input("请输入一个分数:"))
if 90 <= score <= 100:
	print("A")
if 80 <= score <= 90:
	print("B")
if 70 <= score <= 80:
	print("C")
if 0 <= score <= 70:
	print("D")
if 100 < score or score < 0:
	print("输入分数段错误!")

"""
方法二: 8-2
"""
score = int(input("请输入一个分数:"))
if 90 <= score <= 100:
	print("A")
else:
    if 80 <= score <= 90:
        print("B")
    else:
        if 70 <= score <= 80:
            print("C")
        else:
            if 0 <= score <= 70:
                print("D")
            else:
                if 100 < score or score < 0:
                    print("输入分数段错误!")
"""
方法三:8-3
"""
score = int(input("请输入一个分数:"))
if 90 <= score <= 100:
	print("A")
elif 80 <= score <= 90:
        print("B")
elif 70 <= score <= 80:
        print("C")
elif 0 <= score <= 70:
        print("D")
else:
        print("输入分数段错误!")

"""
9.三元操作符
"""
x, y = 4, 5
if x < y:
	small = x
else:
	small = y
python可以改进为
small = x if x < y else y
"""
10.断言 assert

11.数组列表(list)
11-1.获取列表中元素的数量
len(数组名称)


11-2.向列表中添加组名
append()
例子
原来有member = ['苏','蔡','林'] 向member列表中添加一个元素“徐”
数组名称.append('徐')

11-3.extend可同时加两个元素
用法
数组名称.extend(['元素1','元素2'])


11-4.insert可插入到任何位置
用法，位置是从0开始算起
数组名称.insert(位置,'元素')

11-5获取数组中的值
数组名称[位置]

11-6从数组中删除元素值
数组名称.remove[位置或者元素名称]
del 数组名称[位置或者元素名称]
数组名称.pop(位置或者元素名称)
	默认删除最后一个

11-7 列表分片
数组名[索引位置:索引位置]
	注：位置如果是空表示一段距离
例子:member[1:3]获取位置1和3位置两个值
member[:3]获取位置0到3位置三个值
member[0:]获取位置0到结尾位置n个值

12.dir(list)用法 

13.元组(tunple)，是不可改变
空元组创建
名称 = ()
而空元素列表创建
名称 = []

注:元组创建数字需要加逗好否则会默认为是数字类型
"""
>>> temp = ()
>>> type(temp)
<class 'tuple'>
>>> temp = []
>>> type(temp)
<class 'list'>
>>> temp =(1)
>>> type(temp)
<class 'int'>
>>> temp = (1,)
>>> type(temp)
<class 'tuple'>
>>> 
"""
14.字符串 format 格式化
"""
>>> "{0} love {1}.{2}".format("I","Fishc","com")
'I love Fishc.com'
"""15.字符串 格式化符号含义
参考网址:http://www.cnblogs.com/jydeng/p/4126755.html

符   号	   说     明
     %c	   格式化字符及其ASCII码
     %s	   格式化字符串
     %d	   格式化整数
     %o	   格式化无符号八进制数
     %x	   格式化无符号十六进制数
     %X	   格式化无符号十六进制数（大写）
     %f	   格式化定点数，可指定小数点后的精度
     %e	   用科学计数法格式化定点数
     %E	   作用同%e，用科学计数法格式化定点数
     %g	   根据值的大小决定使用%f活%e
     %G	   作用同%g，根据值的大小决定使用%f或者%E
使用方法：

　　　　仅有一个空时： print ('xxxx%c'%97)

　　　　多个空时：print ('%c %c %c'%(97, 98, 99)) 需要使用元组

  
格式化操作符辅助指令

                                                

   符   号	    说     明
     m.n	    m是显示的最小总宽度，n是小数点后的位数
       -	    用于左对齐
      +	    在正数前面显示加号（+）
       #	    在八进制数前面显示 '0o'，在十六进制数前面显示 '0x' 或 '0X'
       0	    显示的数字前面填充 '0' 取代空格
使用方法：

　　　　m.n: print('%5.5f' % 27.55),此时要求，小数点后要有5位数，若不足会自动补全，得到 ：'27.55000'
    　　 - ： print( '%-010d' %27.55),此时若无 '-' 号时，将得到：'0000000027'，若有'-'号，则得到：'27

　　　　 '# ：print('%#o' %12),简单易懂，转为8 or 16进制输出      

    
字符串转义字符含义
  

   符   号	    说     明
       \'	    单引号
       \"	    双引号
       \a	    发出系统响铃声
       \b	    退格符
       \n	    换行符
       \t	    横向制表符（TAB）
       \v	    纵向制表符
       \r	    回车符
       \f	    换页符
       \o	    八进制数代表的字符
       \x	    十六进制数代表的字符
       \0	    表示一个空字符
       \\	    反斜杠
"""


>>> '%c %c %c' % (97,98,99)
'a b c'