#coding:utf-8
#列表
my_dict = {
    1:'test0',
    20:'test0',
    1:'test',
    "name":'shanghai',
    'age':32,
    'hobby':['linux','python'],
    'des':{
        'job':'ops',
	'he':'xxx'
	}
}
#print my_dict
#print my_dict[1]
#print my_dict['name']
#print my_dict['age']
#print my_dict['hobby']
#print my_dict['des']
for k in my_dict:
    print k,my_dict[k]
