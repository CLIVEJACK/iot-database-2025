-- 데이터베이스 관리
show DATABASES;

-- information_schema, performance_schema, mysql 등은 시스템 DB라서 개발자,DBA 사용하는 게 아님
use madang;

-- 하나의 DB내 존재하는 테이블들 확인
show tables;

-- 테이블의 구조 (보기) 
desc madang.NewBook;

select * from v_orders;

-- 사용자 추가 
-- madang 데이터베이스만 접근할 수 있는 사용자 madang 생성
-- 내부접속용
CREATE USER madang@localhost IDENTIFIED BY 'madang';
-- 외부접속용
CREATE USER madang@'%' IDENTIFIED BY 'madang';

-- DCL : grant, revoke 
-- 데이터 삽입, 조회, 수정만 권한을 부여
grant SELECT, INSERT, UPDATE ON madang.* to madang@localhost with GRANT OPTION;
grant SELECT, INSERT, UPDATE ON madang.* to madang@'%' with GRANT OPTION;
FLUSH PRIVILEGES; -- 위에 있는 명령어를 적용 

-- 사용자 madang에게 madangDB를 사용할 수 있는 모든 권한 부여
grant all PRIVILEGES ON madang.* to madang@localhost with GRANT OPTION;
grant all PRIVILEGES ON madang.* to madang@'%' with GRANT OPTION;
FLUSH PRIVILEGES;

-- 권한해제
-- madang사용자의 권한중 SELECT 권한만 제거 
REVOKE SELECT ON madang.* from madang@localhost;
REVOKE all PRIVILEGES ON madang.* from madang@localhost;
REVOKE all PRIVILEGES ON madang.* from madang@'%';
FLUSH PRIVILEGES;


