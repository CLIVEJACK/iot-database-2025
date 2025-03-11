 -- 1번 
SELECT Email AS emaail
	 , Mobile AS mobile
     , Names AS names
     , addr 
  FROM membertbl;
-- 2번
SELECT Names AS '도서명'
	 , Author AS '저자'
	 , ISBN 
     , Price AS '정가'
  FROM bookstbl
 ORDER BY ISBN;

 -- 3번 
 SELECT Names
	 , Levels
     , Addr
     , returnDate
  FROM membertbl, rentaltbl
 WHERE membertbl.Idx = rentaltbl.memberIdx;

 -- 4번 
 SELECT d.Names  AS '장르'
	 , b.Price AS '총합계금액'
 FROM bookstbl AS b, divtbl AS d, rentaltbl AS r
 WHERE b.Division = d.Division AND r.bookIdx = b.Idx
 