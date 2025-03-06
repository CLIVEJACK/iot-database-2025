-- WorkBook : SQL Practice
/* 샘플- Employee에서 사원번호, 이름, 급여, 업무, 입사일, 상사의 사원번호를 출력하시오.
		 이때 이름과 성을 연결하여 Full Name이 라는 별칭으로 출력하시오.(107행)
*/
SELECT employee_id
	 , concat(first_name, '', last_name) AS 'Full Name'
     , salary
     , job_id
     , hire_date
     ,manager_id
  FROM employees;
  
/* 문제1 - employee 에서 사원의 성과 이름을 Name, 업무는 Jop, 급여는 Salary, 연봉에 $100 보너스를 추가해서 계산한 Increased Ann_Salary
			금여에 $100 보너스를 추가해서 Increased Salary 별칭으로 출력하시오 (107행)
*/
SELECT concat(first_name, '', last_name) AS 'Name'
	 , job_id AS 'Jop'
     , salary AS 'Salary'
	 , (salary * 12) + 100 AS 'Increased Ann_salary'
     , (salary + 100) * 12 As 'Incerased Salary'
  FROM employees;
  
/* 문제2 - employees 에서 모든 사원의 last_name과 연봉을 '이름:1 Year Salary = $연봉' 형식으로 출력하고, 1 Year Salary라는 별칭르로 붙이세요 (107행)
*/  
SELECT concat(last_name, ': 1 Year Salary = $',(salary * 12)) AS '1 Year Salary'
  FROM employees;
  
/* 문제3 - 부서에 담당하는 업무를 한번씩만 출력하시오. (20행)
*/
SELECT distinct department_id, job_id
  FROM employees;
  
-- where, order by
/* 샘플 - hr부서 예산 편성 문제로 급여 정보 보고서를 작성한다. employees에서 salary가 7000 ~ 10000달러 범위 이외의 사람의 
	성과 이름을 Name 해서 급여를 급여가 작은 순서로 출력하시오.(75행)
*/
SELECT concat(first_name,'',last_name) AS 'Name'
	 , salary
  FROM employees
 WHERE salary not between 7000 and 10000
 order by salary; 

/* 문제1 - 사원의 last_name중 e나 o글자를 포함한 사원의 출력하시오. 이떄 컬럼명은 e And o Name라고 출력하시오.(10행)
*/
SELECT last_name AS 'Name'
  FROM employees
 WHERE last_name LIKE '%e%'AND last_name LIKE '%o%'; 
  
/* 문제2 -현재 날짜 타입을 날짜 함수를 통해 확인하고 1995년 5월20일부터 1996년5월 20일사이에 고용된 사원들의 이름(Name으로 별칭),사원번호,고용일자를 출력하시오.
			단, 입사일이 빠른 순으로 정렬하시오.(8행).
*/
SELECT date_add(sysdate(), interval 9 hour) AS 'sysdate()';

desc employees; 

SELECT last_name AS 'Name'
	 , employee_id
     , hire_date
  FROM employees
 WHERE hire_date BETWEEN '1995-05-20' and '1996-05-20' -- data타입은 문자열 처럼 조건연산을 해도 됨 
 order by hire_date ASC;

-- 단일행 함수 및 변환 함수
/* 문제1 - 이름이 's'로 시작하는 각 사원의 이름과 업무를 아래의 예와같이 출력하고자 한다. 
			출력시 성과 이름은 첫 글자를 대문자로, 업무는 모두 대문자로 출력하고 머리글은 employee JOBs.로 표시
*/
SELECT concat(first_name, '',last_name, 'is a',upper(job_id)) AS 'Employee JOBs'
  FROM employees
 WHERE last_name LIKE '%s';


/*문제3 - 사원의 성과 이름을 Name으로 별칭, 입사일, 입사한 요일을 출력하시오, 이때 (week)시작인 일요일부터 출력되도록 정렬(107행)
*/
  SELECT concat(first_name, '',last_name) AS 'Name'
		 , hire_date
         , date_format(hire_date, '%W') AS 'Day of the week'
  FROM employees
  order by date_format(hire_date, '%w') ASC, hire_date;
  
-- 집계함수
/* 문제1 - 사원이 소속된 부서별 급여 합계, 급여 평균, 급여 최대값, 급여 최소값을 집계.
			출력값은 여섯자리와 세자리 구분기호, $표시 포함, 부서번호를 오름차순 
            단, 부서에 소속되지 않는 사원은 정보에서 제외, 출력시 머리글은 아래처럼 별칠으로 처리(11행)
*/
select department_id
	 , concat('$', format(round(sum(salary), 0 ),0)) AS 'Sum Salary'
     , concat('$', format(round(avg(salary), 1 ),1)) AS 'Avg Salary'  -- round(컬럼,1), 소수점1자리에서 바올림, format(값,1)소수점표현 및 1000단위, 표시
     , concat('$', format(round(max(salary), 0 ),0)) AS 'Max Salary'
     , concat('$', format(round(min(salary), 0 ),0)) AS 'Min Salary'
  FROM employees
 WHERE department_id is not null
group by department_id; -- 그룹바이 속한 컬럼만 select절에 사용할 수 있음!

-- 조인
/* 문제2 - job_grades 테이블을 사용, 각 사원의 급여에 따른 급여등급을 보고 한다. 성과 이름과 성을 name으로, 업무, 부서명, 입사일, 급여, 급여등급을 출력(106행)
*/
DESC job_grades;
DESC employees;

select *
  FROM departments AS d join employees AS e
		on d.department_id = e.department_id; -- ANSI Standard SQL쿼리 
 
 select concat(e.first_name, '', e.last_name) AS 'Name'
	  , e.job_id
      , d.department_name
      , e.hire_date
      , e.salary
      , (SELECT grade_level from job_grades
		 WHERE e.salary BETWEEN lowest_sal AND highest_sal) AS 'grade_level' -- 서브쿼리 추가!!
  FROM departments AS d, employees AS e
 where d.department_id = e.department_id
 order by e.salary desc;
 
-- 서브쿼리 테스트
SELECT *
 from job_grades
 WHERE 6000 BETWEEN lowest_sal and highest_sal;

  
/* 문제3 - 각 사원의 상사와의 관계를 이용, 보고서 작성을 하려고함
		예를 보고 출력하시오 (107행)
*/
select concat(e2.first_name, '' , e2.last_name) AS 'Employee'
	 , 'report to'
	 , upper(concat(e1.first_name, '' , e1.last_name)) AS 'Manager'
  FROM employees AS e1 right JOIN employees AS e2
    ON e1.employee_id = e2.manager_id;

-- 서브쿼리 
/* 문제3 - 사원들의 지역별 근무현황을 조회. 도시 이름이 영문'O'로 시작하는 지역에 살고 
			사번, 이름, 업무, 입사일 출력하시오.(34행)
*/
SELECT e.employee_id
	 , concat(e.first_name,'', e.last_name) AS 'Name'
     , e.job_id
     , e.hire_date
  FROM employees AS e, departments AS d
  WHERE e.department_id = d.department_id
	AND d.location_id = (SELECT location_id
						   FROM locations
						  where city like 'o%');
                          
-- 서브쿼리 테스트 AND 안에 넣는거 먼저 하고 
SELECT location_id
  FROM locations
where city like 'o%';
  

  
  
