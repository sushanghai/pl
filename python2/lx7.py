#rulian
while True:
    num=raw_input("Please enter year:")
    if not num:
        print "The num is not null."
        continue
    elif int(num)%100==0:
        if int(num)%400==0:
            print "%s year is runlian."% num
	    break
        else:
            print "Your enter number is not runlian"
	    continue
    elif int(num)%4==0:
        print "%s year is runlian."% num
	break
    else:
        print "Your enter number is not runlian"
        continue

