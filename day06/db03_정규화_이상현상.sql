-- 7-1 계절학기 테이블
DROP TABLE IF EXISTS Summer; -- 기존테이블이 존재하면 삭제 

CREATE TABLE Summer(
	sid 	INTEGER,
    class	VARCHAR(20),
    price	INTEGER
);

SELECT * FROM Summer;

-- 기본데이터 추가(MySQL에서 한번에 다중데티어 INSERT)
INSERT INTO Summer VALUES(100, 'JAVA',20000),(150, 'PTHON',15000),(200, 'C',10000),(250, 'JAVA',20000);
-- INSERT INTO Summer VALUES(150, 'PTHON',15000);
-- INSERT INTO Summer VALUES(200, 'C',10000);
-- INSERT INTO Summer VALUES(250, 'JAVA',20000);

-- 데이터 확인
SELECT * FROM Summer;

-- 계절학기 듣는 학생의 학번과 수강과목
SELECT sid
	 , class
  FROM Simmer;
  
-- C강좌 수강료는 ?
SELECT price 
  FROM Summer
 WHERE class LIKE '%C%';
 
-- 수강료가 가장 비싼과목은
SELECT DISTINCT(class)  -- DISTINCT는 중복 제거
  FROM Summer
  WHERE price = (SELECT MAX(price)
				FROM Summer);
                
-- 계절학기 학생수와 수강료 총액
SELECT COUNT(*) AS '학생수'
	 , SUM(price) AS '수강료총액'
  FROM Summer;
  
/*이상현상(abnormaly)*/
-- 삭제이상 
DELETE FROM Summer WHERE sid = 200;

-- C강좌 수강료를 찾을 수 없다
SELECT price 
  FROM Summer
 WHERE class LIKE '%C%';
 
-- 삽입이상
INSERT INTO Summer VALUES (NULL, 'C++', 25000);

SELECT COUNT(*)
  FROM Summer;

SELECT COUNT(sid)
  FROM Summer;
  
-- 수정이상
UPDATE Summer SET 
	price = 15000
  WHERE sid = 100;
  
-- 데이터 전부 다 날리기  (DELETE는 WHERE절 없이 쓰면 문제임 )
DELETE FROM Summer;
 