Python 3.5.3 (v3.5.3:1880cb95a742, Jan 16 2017, 16:02:32) [MSC v.1900 64 bit (AMD64)] on win32
Type "copyright", "credits" or "license()" for more information.
>>> member = ['苏','林','蔡']
>>> member
['苏', '林', '蔡']
>>> 

>>> member.append('徐')

>>> member
['苏', '林', '蔡', '徐']
>>> member.extend(['吴','许'])
>>> member
['苏', '林', '蔡', '徐', '吴', '许']
>>> member.insert(0,'杜')

>>> member
['杜', '苏', '林', '蔡', '徐', '吴', '许']
>>> 
