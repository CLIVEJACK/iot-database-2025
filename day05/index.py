# 파이썬 웹앱(Flask)
## pip install Flask
from flask import Flask, render_template, request
import pymysql

# 변수 초기화
host = 'localhost' # or 127.0.0.1
port = 3306
database = 'madang'
username ='root'
password = '12345'

conflag = True # 접속상태

app = Flask(__name__)## 플라스크 웹 앱 실행

conn = pymysql.connect(host=host, user=username,passwd=password, port=port ,db=database)
cursor = conn.cursor()

@app.route('/') #routiong decorator 웹사이트 경로를 실행할때 http://localhost:50000/
def index():
    query = '''SELECT bookid
                    , bookname
                    , publisher
                    , price 
                 FROM Book''' 
    res = cursor.execute(query) # SQL실행(1회 호출)
    data = cursor.fetchall()  # MySQL 데이터를 한번에 다 가져옴data = cursor.fetchall()  # MySQL 데이터를 한번에 다 가져옴
    # template 폴더 안에있는 html을 데이터와 연결해서 렌더
    return render_template('booklist.html', book_list=data)

@app.route('/view') # http://localhost/5000/view?id=2
def getDetail():
    bookid = request.args.get('id')
    query = f'''SELECT bookid
                    , bookname
                    , publisher
                    , price 
                 FROM Book
                WHERE bookid  = '{bookid}'
            ''' 
    cursor.execute(query)

    data = cursor.fetchall()
    return render_template('bookview.html', book=data)

if __name__=='__main__':
    app.run('localhost')