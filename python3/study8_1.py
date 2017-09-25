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
