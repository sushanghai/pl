#coding:utf-8
import time

#获取内存
def getMem():
    with open('/proc/meminfo') as f:
        #print f.readline()
        total = int(f.readline().split()[1])
        free = int(f.readline().split()[1])
        Buffer = int(f.readline().split()[1])
        cache = int(f.readline().split()[1])
	use_mem = total-free-Buffer-cache
	print use_mem/1024
#每一秒执行一次
while True:
    time.sleep(1)
    getMem()
