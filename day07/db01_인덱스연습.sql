-- 기존테이블 삭제
DROP table if EXISTS NewBook;

-- 테이블 생성
CREATE table NewBook(
	bookid INTEGER AUTO_INCREMENT PRIMARY KEY, -- AUTO_INCREMENT는 자동으로 숫자가 증가함
    bookname VARCHAR(100),
    publisher varchar(100),
    price INTEGER
);

-- 500만건 더미데이터 생성 설정
set SESSION cte_max_recursion_depth = 5000000;

-- 더미데이터 생성
INSERT INTO NewBook(bookname, publisher, price)
with RECURSIVE cte (n) AS 
(
	select 1
    UNION all
    select n+1 from cte where n < 5000000
)
select concat('Book', lpad(n, 7, '0')) -- Book5000000 n부터 7까지 빈곳에 0을 삽입
	 , concat('Comp', lpad(n, 7, '0')) -- Comp5000000
     , floor(3000 + rand() * 30000) AS price -- 책가격 3000~33000
from cte;

-- 데이터 확인 
SELECT count(*)  FROM NewBook;

select * from NewBook
 WHERE price BETWEEN 20000 and 25000;
 
-- 가격을 7개 정도 검색할수 있는 쿼리 작성
select * from NewBook
 WHERE price in (8377, 14567, 24500, 33000, 5600,6700, 15000);
 
-- 인덱스 생성 (인덱스를 생성하면 검색 속도가 빨라진다 하지만 인덱스를 생성하는데 시간이 조금 걸림)
CREATE INDEX idx_book on NewBook(price); 
 
 