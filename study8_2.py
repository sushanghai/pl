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
