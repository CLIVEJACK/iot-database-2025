-- 내장함수
-- 4-1 -78과 78의 절대값을 구하시오

SELECT ABS(-78), ABS(78);

-- 4-2 4.875를 소수점 첫번쨰 자리까지 반올림 하시오.
SELECT ROUND(4.875, 1) AS 결과;


-- 4-3 고객별 평균 주문 금액을 100원단위로 반올림한 값을 구하시오.
select custid, ROUND(SUM(saleprice) / COUNT(*), -2) AS '평균금액'
  FROM Orders
  GROUP BY custid;
  
-- 문자열 내장함수 
-- 4-4 도서 제목에서 야구가 포함된 도서명을 농구로 변경한후 출력하시오.
select bookid 
	,  replace(bookname,'야구','농구') as bookname
    ,  publisher
    ,  price
  FROM Book;
  
-- 추가 
select 'Hello' 'MySQL';

select concat('Hello' ,'MySQL', 'wOW');
  
  
-- 4-5 굿스포츠에서 출판한 도서의 제목과 제목의 문자수, 바이트수를 구하시오.
SELECT bookname AS '제목'
		, CHAR_LENGTH(bookname) AS '제목 문자수'  -- 글자 길이를 구할때
        , LENGTH(bookname) AS '제목 바이트수' -- UTF8에서 한글 한글자의 바이트수는 3bytes
  FROM Book
 WHERE publisher = '굿스포츠';
  
  
-- 4-6 고객 중 서잉 같은 사람이 몇 명이나 되는지 성별 인원수를 구하시오.
-- SUBSTR(자를 원본 문자열, 시작인덱스, 길이)
-- DB는 인덱스를 1부터 시작!!! (프로그래밍 언어와 차이점 )
select SUBSTR('Hello MySQL', 2,3);  -- 연습이 필요 

SELECT substr(name, 1, 1) AS '성씨 구분'
	  ,COUNT(*) AS '인원수'
  FROM Customer
  GROUP BY substr(name, 1, 1);
  
-- 추가 trim, python의 strip()과 동일 
SELECT CONCAT('--', TRIM('     Hello!     '), '--');
SELECT CONCAT('--', LTRIM('     Hello!     '), '--');
SELECT CONCAT('--', RTRIM('     Hello!     '), '--');

-- 새롭게 추가된 trim() 함수 
SELECT TRIM('=' FROM '=== -Hello- ===');
  
  
-- 날짜시간 함수 
SELECT SYSDATE(); -- Docker 서버시간을 따라서 GMT(그리니치 표준시)를 따름 +9hour 

SELECT ADDDATE(SYSDATE(), INTERVAL 9 HOUR) AS '한국시간' ;

-- 4-7 마당서점은 주문일부터 10일 후에 매출을 확정합니다. 각 주문의 확정일자를 구하시오.
SELECT Orderid AS '주문번호'
	  ,Orderdate AS '주문일자'
      ,ADDDATE(Orderdate, INTERVAL 10 DAY) AS '확정일자'
  FROM Orders;
  
-- 추가, 나라별 날짜 시간을 표현하는 포맷이 다름
SELECT SYSDATE() AS '기본날짜 /시간'
	  ,date_format(sysdate(), '%M/%d/%Y %H:%m:%s');
      
-- 4-8 2014년  7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 나타내시오.
-- 단, 주문일은 %Y-%m-%d 형태로 표시한다.
-- %Y = 년도전체, %y = 년도 뒤2자리, %M = July(월이름), %b = Jul(월약어) %m = 07(월숫자)
-- %d = 일 ,%H = 16, %h = 04(오후도), %W = Monday, %w = 1(요일은 일요일 0)
-- %p == AM/PM
SELECT orderid AS '주문번호'
	  ,DATE_FORMAT(Orders, '%Y%m%d') AS '주문일'
	  , custid AS '고객번호'
	  , bookid AS '도서번호'
FROM Orders;

-- DATEDIFF : D-day
SELECT DATEDIFF(SYSDATE(), '2025-02-03');

-- Formatting,1000단위마다 넣기 

-- NULL = Python 도일 . 모든 다른 프로그래밍 언어에서는 전부 NULL,NUL
-- 추가. 금액이 NULL일때 발생되는 현상
SELECT price - 5000
  FROM MyBook
  WHERE bookid = 3;

-- 핵심. 집계함수가 다 꼬임
SELECT SUM(price) AS '합산은 문제없음'
	  ,AVG(price) AS '평균은 NULL값이 빠져서 꼬임'
      ,COUNT(*) AS '모든 행의 갯수는 일치'
      ,COUNT(price) AS 'NULL값은 갯수에서 빠짐'
  FROM MyBook;
  
-- NULL 값 확인 . NULL은 비교연산자(=, >,<, <>, ...)사용불가
-- IS키워드 사용
SELECT *
  FROM MyBook
  WHERE price IS NULL; -- 반대는 IS NOT NULL

SELECT *
  FROM MyBook
  WHERE bookname = '';

-- IFNULL함수
SELECT bookid
	  ,bookname
      ,IFNULL(price, 0) AS price
  FROM MyBook






  
  