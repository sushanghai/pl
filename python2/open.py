# coding:utf-8

f = open('user.txt')
#print f.read()
#read方法可以读取固定长度的字符，不传的话读到文件结束
#所有操作文件的方法，都有一个文件指针的概念，每次read都会修改文件指针位置
#下次read从指针位置开始

#print f.read(5)
#print f.read(5)
#print f.read()

# print f.readline(),
#print f.readline()
#readlines 一次全部读完，返回一个list，每行是一个元素
#print f.readlines()

#open默认是读的打开方式，如果想写文件，要指明打开的模式，rwa

#f = open('user.txt','w')
#f = open('user.txt','a')
#f.write('test write sth\n')
#w模式是覆盖的，打开时就清空文件了，a是追加模式
#f.writelines(['test\n','write sth\n'])
#print '123'

f.close()
