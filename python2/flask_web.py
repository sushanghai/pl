from flask import Flask
app = Flask(__name__)



@app.route('/')
def index():
    return 'hello world'

@app.route('/web.html')
def web_html():
    return 'web xxx'



if __name__ == '__main__':
    app.run(host='0.0.0.0',port=9092,debug=True)
