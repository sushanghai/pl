# coding:utf-8
f = open('tms.hnscar.com.error.log','r')
u = f.readlines()
ip_list=[]
status_list=[]
ip_dict={}
ip_status_dict={}
ip_status=[]
count = 0
for i in u:
    # print i
    ip=i.split(',')[1].split(' ')[2]
    # print ip
    ip_list.append(ip)
    # print ip_list

    status=i.split(',')[0].split(' ')[6]
    # print status
    # status_list.append(status)
    # print status_list
    
    # ip_status=[(count,ip,status)]
    ip_status=[(ip,status)]
    # print ip_status
    # count +=1
    #统计找出IP及状态出现的次数
    for j in ip_status:
        ip_status_dict[j] = ip_status_dict.get(j,0)+1
# print ip_status_dict
#以数字为排序，IP是否相同
f.close()
reverse_ip_status_dict={}
for k in ip_status_dict:
    # print ip_status_dict[k]
    if ip_status_dict[k] in reverse_ip_status_dict:
        reverse_ip_status_dict[ip_status_dict[k]].append(k)
    else:
        reverse_ip_status_dict[ip_status_dict[k]] = [k]

# print reverse_ip_status_dict
# for r in reverse_ip_status_dict:
#     print r,reverse_ip_status_dict[r]
key_list =[]
for a in reverse_ip_status_dict:
    key_list.append(a)

key_list.sort()
# print key_list
html_str = '<table border="1">'
# html_str = '<tr><td>IP</td><td>status</td><td>count</td></tr>'
tr_tmpl = '<tr><td>%s</td><td>%s</td><td>%s</td></tr>'
html_str += tr_tmpl%('IP','staus','count')
count = 0

while count < 10:
    val = key_list.pop()
    # print val
    # print reverse_ip_status_dict[val]
    
    for k in reverse_ip_status_dict[val]:
        # print k,val
        html_str+=tr_tmpl%(k[0],k[1],val)
        
        # print html_str
   		

        # print k[0],k[1],val
        count += 1

# print count1
html_str+='</table>'
  
html_f = open('/usr/share/nginx/html/test.html','w')
html_f.write(html_str)
html_f.close()
