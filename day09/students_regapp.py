# 학생정보 등록 GUI앱
# pip install pymysql

# 1. 관련모듈 임포트
import tkinter as tk
from tkinter import *    # tkinter는 이걸로 모든 모듈을 부를 수 없음
from tkinter import ttk, messagebox 
from tkinter.font import *  # 기본외 폰트를 사용하려면

import pymysql   # mysql-connector 등 다른 모듈도 사용추천

# 2. DB관련 설정
host = 'localhost'  # 127.0.0.1 해도 무방
port = 3306
database = 'madang'
username = 'madang'
password = 'madang'

# 5. DB처리 함수들 정의
## 5-1. showDatas() - DB 학생정보 테이블에 데이터를 가져와 TreeView에 표시
def showDatas():
    '''
    데이터베이스 내 모든 학생정보를 가져와 표시하는 사용자함수\n
    매개변수 필요없음
    '''
    global dataView   # 외부에 있는 변수를 전역변수로 사용 선언
    ### DB연결. 커넥션 객체생성 -> 커서 -> 쿼리실행 -> 커서로 데이터 패치 -> 커서종료 -> 커넥션 종료
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, db=database)
    cursor = conn.cursor()  # DB 쿼리 실행시 커서 생성
    
    ### 쿼리문 작성
    query = 'select std_id, std_name, std_mobile, std_regyear from students'
    cursor.execute(query=query)  # 쿼리 실행
    data = cursor.fetchall()    # 쿼리실행 데이터 전부 가져옴

    ### 가져온 데이터 트리뷰에 추가
    print(data)
    dataView.delete(*dataView.get_children())       # 최초, 중간에 showDatas() 호출시마다 트리뷰 클리어
    for i, (std_id, std_name, std_mobile, std_regyear) in enumerate(data, start=1): # enumerate - 인덱스와 아이템 동시접근
        dataView.insert('', 'end', values=(std_id, std_name, std_mobile, std_regyear)) # 트리뷰 마지막 'end' 추가

    cursor.close()  # 커서 종료
    conn.close()    # 커넥션 종료

# 6. getData(event) - 트리뷰 한줄 더블클릭한 값 엔트리에 표시
def getData(event):
    '''
    트리뷰 더블클릭으로 선택된 학생정보를 엔트리 위젯에 채우는 사용자함수
    
    Args:
        event: 트리뷰에 발생하는 이벤트 객체
    '''
    global ent1, ent2, ent3, ent4, dataView  # 전역변수로 사용 선언

    ## 엔트리 위젯 기존 내용 삭제
    ent1.config(state='normal')
    ent1.delete(0, END)  # 학생번호 기존 데이터 삭제
    ent1.config(state='readonly')
    ent2.delete(0, END)  # 학생명 기존 데이터 삭제
    ent3.delete(0, END)  # 핸드폰 기존 데이터 삭제
    ent4.delete(0, END)  # 입학년도 기존 데이터 삭제

    ## 트리뷰 선택항목 ID 가져오기('I001')
    sel_item = dataView.selection()

    if sel_item:
        item_values = dataView.item(sel_item, 'values')  # 선택항목 'values'(실데이터) 가져오기

    ## 엔트리 위젯에 각각 채워넣기
    ent1.config(state='normal')     # 데이터 들어갈 수 있게 해주고
    ent1.insert(0, item_values[0])  # 학생번호
    ent1.config(state='readonly')   # 다시 리드온리로
    ent2.insert(0, item_values[1])  # 학생명
    ent3.insert(0, item_values[2])  # 핸드폰
    ent4.insert(0, item_values[3])  # 입학년도

# 7. 새 학생정보 추가 함수
def addData():
    '''
    새 학생정보 DB 테이블 추가 사용자함수
    '''
    global ent1, ent2, ent3, ent4, dataView  # 전역변수로 사용 선언

    ## 엔트리 위젯 학생정보데이터 변수할당
    std_name = ent2.get()  # 학생명
    std_mobile = ent3.get()  # 핸드폰
    std_regyear = ent4.get()    # 입학년도

    ## DB연결
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, db=database)
    cursor = conn.cursor()  # DB 쿼리 실행시 커서 생성

    try:
        conn.begin()    # begin transaction. 트랜잭션 시작
        # 쿼리 작성
        query = 'insert into students (std_name, std_mobile, std_regyear) values (%s, %s, %s)'
        val = (std_name, std_mobile, std_regyear)
        cursor.execute(query=query, args=val)  # 쿼리 실행

        conn.commit()   # 트랙잰션 확정
        lastid = cursor.lastrowid  # 마지막에 insert된 레코드 id를 가져옴(auto_increment)
        print(lastid) 

        messagebox.showinfo('INSERT', '학생등록 성공!')

        ## 엔트리 위젯 기존 내용 삭제
        ent1.config(state='normal')
        ent1.delete(0, END)  # 학생번호 기존 데이터 삭제
        ent1.config(state='readonly')
        ent2.delete(0, END)  # 학생명 기존 데이터 삭제
        ent3.delete(0, END)  # 핸드폰 기존 데이터 삭제
        ent4.delete(0, END)  # 입학년도 기존 데이터 삭제
        ent2.focus_set()    # 학생명 포커스 

    except Exception as e:
        print(e)
        conn.rollback() # 트랙잭션 롤백
        messagebox.showerror('INSERT', '학생등록 실패!!')
    finally:
        cursor.close()      # 커서
        conn.close()        # 커넥션 종료

    showDatas()     # DB 테이블의 모든 데이터 조회해서 트리뷰에 표시

# 8. 기존학생정보 수정
def modData():
    '''
    기존 학생정보 수정 사용자함수
    '''
    global ent1, ent2, ent3, ent4, dataView  # 전역변수로 사용 선언

    ## 엔트리 위젯 학생정보데이터 변수할당
    std_id = ent1.get()     # 학생번호
    std_name = ent2.get()  # 학생명
    std_mobile = ent3.get()  # 핸드폰
    std_regyear = ent4.get()    # 입학년도

    if std_id == '':
        messagebox.showwarning('UPDATE', '수정할 데이터 선택요망!')
        return

    ## DB연결
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, db=database)
    cursor = conn.cursor()  # DB 쿼리 실행시 커서 생성

    try:
        conn.begin()    # begin transaction. 트랜잭션 시작
        # 쿼리 작성
        query = 'update students set std_name=%s, std_mobile=%s, std_regyear=%s where std_id=%s'
        val = (std_name, std_mobile, std_regyear, std_id)
        cursor.execute(query=query, args=val)  # 쿼리 실행

        conn.commit()   # 트랙잰션 확정
        lastid = cursor.lastrowid  # 마지막에 insert된 레코드 id를 가져옴(auto_increment)
        print(lastid) 

        messagebox.showinfo('UPDATE', '학생수정 성공!')

        ## 엔트리 위젯 기존 내용 삭제
        ent1.config(state='normal')
        ent1.delete(0, END)  # 학생번호 기존 데이터 삭제
        ent1.config(state='readonly')
        ent2.delete(0, END)  # 학생명 기존 데이터 삭제
        ent3.delete(0, END)  # 핸드폰 기존 데이터 삭제
        ent4.delete(0, END)  # 입학년도 기존 데이터 삭제
        ent2.focus_set()    # 학생명 포커스 

    except Exception as e:
        print(e)
        conn.rollback() # 트랙잭션 롤백
        messagebox.showerror('UPDATE', '학생수정 실패!!')
    finally:
        cursor.close()      # 커서
        conn.close()        # 커넥션 종료

    showDatas()     # DB 테이블의 모든 데이터 조회해서 트리뷰에 표시

# 9. delData() 삭제 함수
def delData():
    '''
    기존 학생정보 삭제 사용자함수
    '''
    global ent1, ent2, ent3, ent4, dataView  # 전역변수로 사용 선언

    ## 엔트리 위젯 학생번호만 변수할당
    std_id = ent1.get()     # 학생번호

    if std_id == '':
        messagebox.showwarning('DELETE', '삭제 데이터 선택요망!')
        return

    ## DB연결
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, db=database)
    cursor = conn.cursor()  # DB 쿼리 실행시 커서 생성

    try:
        conn.begin()    # begin transaction. 트랜잭션 시작
        # 쿼리 작성
        query = 'delete from students where std_id=%s'
        val = (std_id, ) # 삭제할 학생번호 튜플
        cursor.execute(query=query, args=val)  # 쿼리 실행

        conn.commit()   # 트랙잰션 확정
        lastid = cursor.lastrowid  # 마지막에 insert된 레코드 id를 가져옴(auto_increment)
        print(lastid) 

        messagebox.showinfo('DELETE', '학생삭제 성공!')

        ## 엔트리 위젯 기존 내용 삭제
        ent1.config(state='normal')
        ent1.delete(0, END)  # 학생번호 기존 데이터 삭제
        ent1.config(state='readonly')
        ent2.delete(0, END)  # 학생명 기존 데이터 삭제
        ent3.delete(0, END)  # 핸드폰 기존 데이터 삭제
        ent4.delete(0, END)  # 입학년도 기존 데이터 삭제
        ent2.focus_set()    # 학생명 포커스 

    except Exception as e:
        print(e)
        conn.rollback() # 트랙잭션 롤백
        messagebox.showerror('DELETE', '학생삭제 실패!!')
    finally:
        cursor.close()      # 커서
        conn.close()        # 커넥션 종료

    showDatas()     # DB 테이블의 모든 데이터 조회해서 트리뷰에 표시

# 3. tkinter 윈도우 설정
root = Tk()                     # tkinter 윈도우인스턴스 생성
root.geometry('820x500')        # 윈도우 크기 지정
root.title('학생정보 등록앱')   # 윈도우타이틀 지정
root.resizable(False, False)    # 윈도우 사이즈 변경 불가
root.iconbitmap('./day09/students.ico')

myFont = Font(family='NanumGothic', size=10)    # 이후에 화면 위젯에 지정할 동일폰트 생성

# 4. UI 구성
## 4-1. 레이블
tk.Label(root, text='학생번호', font=myFont).place(x=10, y=10) 
tk.Label(root, text='학생명', font=myFont).place(x=10, y=40) 
tk.Label(root, text='핸드폰', font=myFont).place(x=10, y=70) 
tk.Label(root, text='입학년도', font=myFont).place(x=10, y=100)

## 4-2. 엔트리(텍스트박스)
ent1 = tk.Entry(root, font=myFont)
ent1.config(state='readonly', foreground='blue', disabledforeground='blue')  # 값을 입력못하게 방지
ent1.place(x=140, y=10)  # 학생번호 Entry
ent2 = tk.Entry(root, font=myFont)
ent2.place(x=140, y=40)  # 학생명 Entry
ent3 = tk.Entry(root, font=myFont)
ent3.place(x=140, y=70)  # 핸드폰 Entry
ent4 = tk.Entry(root, font=myFont)
ent4.place(x=140, y=100)  # 입학년도 Entry

## 4-3. 버튼
## 7-1. 추가버튼에 addData() 함수 연결
tk.Button(root, text='추가', font=myFont, height=2, width=12, command=addData).place(x=30, y=130) # 추가버튼
## 8-1. 수정버튼에 modData() 함수 연결
tk.Button(root, text='수정', font=myFont, height=2, width=12, command=modData).place(x=140, y=130) # 수정버튼
## 9-1. 삭제버튼에 delData 함수 연결
tk.Button(root, text='삭제', font=myFont, height=2, width=12, command=delData).place(x=250, y=130) # 삭제버튼

## 4-4. 트리뷰(행과 열로 만들어진 데이터 표현할때 좋은 위젯중 하나)
cols = ('학생번호', '학생명', '핸드폰', '입학년도')
dataView = ttk.Treeview(root, columns=cols, show='headings', height=14)

## 4-5. 트리뷰 설정
for col in cols:
    dataView.heading(col, text=col)                 # 각열 제목을 cols 변수하나씩 지정
    dataView.grid(row=1, column=0, columnspan=2)    # 트리뷰 위젯을 그리드 레이아웃에 배치
    dataView.place(x=10, y=180)                     # 트리뷰 위젯 배치


# 5. showDatas() 호출
showDatas()

# 6. 트리뷰항목 더블클릭하면 이벤트발생(getData()함수 호출)
dataView.bind('<Double-Button-1>', func=getData)

# 10. 최초 실행시 ent2에 포커스
ent2.focus_set()

# 3. 앱 실행
root.mainloop()