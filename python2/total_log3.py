# coding:utf-8
#取出IP和状态
def ip_status(file_name):
    res_dict = {}
    with open (file_name) as f:
        for line in f:
            # print line
	    if line == '\n':
	         continue
            temp_ip = line.split(',')[1].split(' ')[2]
	    temp_status = line.split(',')[0].split(' ')[6]
	    # print temp_ip
	    # print temp[15],temp[6]
	    tup = (temp_ip,temp_status)
	    # print tup
	    res_dict[tup] = res_dict.get(tup,0)+1
	return res_dict
# ip_status('tms.hnscar.com.error.log')

def get_html(res_list):
    html_str='<table border="1">'
    tr_tmpl='<tr><td>%s</td><td>%s</td><td>%s</td></tr>'
    html_str+=tr_tmpl%('IP','status','count')
    for (ip,status),count in res_list[-10:]:
    	html_str+=tr_tmpl%(ip,status,count)
    	# print (ip,status),count
    html_str+='</table>'
    # print html_str
    with open('/usr/share/nginx/html/res.html','w') as html_f:
    	html_f.write(html_str)


res_dict = ip_status('tms.hnscar.com.error.log')
res_list = sorted(res_dict.items(),key=lambda x:x[1])
get_html(res_list)
