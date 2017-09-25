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
