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
