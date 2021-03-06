synonym : 동의어 
1.객체 별칭을 부여
2.이름
  ==> 이름을 간단하게 표현
  
sem사용자가 자신의 테이블 emp테이블을 사용해서 만든 v_emp view
hr 사용자가 사용할 수 있게 끔 권한을 부여

v_emp : 민감한 정보 sal, comm를 제외한 view


hr 사용자 v_emp를 사용하기 위해 다음과 같이 작성
SELECT *
FROM deok.v_emp;

hr 계정에서
synonym deok.v_emp ==> v_emp
v_emp == deok.v_emp

SELECT *
FROM deok.v_emp;

CREATE v_emp;

1. deok 계정에서 v_emp를 hr 계정에서 조회할 수 있도록 조회권한을 부여

GRANT SELECT ON v_emp TO hr;

2. hr 계정 v_emp 조회하는게 가능 (권한 1번에서 받았기 때문에)
사용시 해당 객체의 소유자를 명시 :  sem v_emp
간단하게 sem.v_emp ==> v_emp 사용하고 싶은 상황
synonym 생성


--CREATE SYNONYM 시노님 이름 FOR 원래 객체명

CREATE SYNONYM v_emp FOR deok.v_emp;

SYNONYM 삭제
DROP SYNONYM 시노님 이름;

GRANT CONNECT TO deok; --시스템 권한  
GRANT SELECT ON 객체명 TO HR; -- 객체 권한


권한 종류
1. 시스템 권한 : TABLE을 생성, VIEW 생성 권한....
2. 객체 권한 : 특정 객체에 대해 SELECT, UPDATE, INSERT, DELETE...

ROLE : 권한을 모아놓은 집합
사용자별로 개별 권한을 부여하게 되면 관리의 부담.
특정 ROLE에 권한을 부여하고 해당 ROLE 사용자에게 부여 
해당 ROLE을 수정하게 되면 ROLE을 갖고 있는 모든 사용자에게 영향 

권한 부여/회수
시스템 권한 : GRANT 권한이름 TO 사용자 | ROLE;
            REVOKE 권한이름 FROM 사용자 | ROLE;
객체 권한 : GRANT 권한이름 ON 객체명 TO 사용자 | ROLE;
           REVOKE 권한 ON 객체명 FROM 사용자 | ROLE;
           

data dictionary : 사용자가 관리하지 않고, dbms가 자체적으로 관리하는    
                  시스템 정보를 담은 view;
                  
data dictionary 접두어
1.USER : 해당 사용자가 소유한 객체
2.ALL : 해당 사용자가 소유한 객체 + 다른 사용자로 부터 권한을 부여받은 객체
3.DBA : 모든 사용자의 객체

*V$ 특수 VIEW;

SELECT * 
FROM USER_TABLES;


SELECT * 
FROM ALL_TABLES;

SELECT * 
FROM DBA_TABLES;



SELECT * 
FROM DICTIONARY;

SELECT *
FROM USER_OBJECTS;

DICTIONARY 종류 확인 : SYS.DICTIONARY;
대표적인 dictionary
OBJECTS : 객체 정보 조회(테이블, 인덱스, VIEW, SYNONYM...)
TABLES : 테이블 정도만 조회;
TAB_COLUMNS : 테이블의 컬럼 정보 조회
INDEX : 인덱스 정보 조회
IND_COLUMNS : 인덱스 구성 컬럼 조회;
CONSTRAINTS : 제약 조건 조회;
CONS_COLUMNS : 제약조건 구성 컬럼 정보 조회
TAB_COMMENTS : 테이블 주석
COL_COMMENTS : 테이블의 컬럼 주석;


SELECT * 
FROM USER_OBJECTS;

emp,dept 테이블의 인덱스와 인덱스 컬럼 정보 조회
user_indexes, user_ind_columns join
테이블명,  인덱스 명,   컬럼명
emp     ind_n_emp_04  ename
emp     ind_n_emp_04   job

SELECT *
FROM user_indexes;

SELECT * 
FROM user_ind_columns;

SELECT table_name, index_name, column_name, column_position 
FROM user_ind_columns
ORDER BY table_name, index_name, column_position;

multiple insert : 하나의 insert 구문으로 여러 테이블에 입력하는 DML 

SELECT * 
FROM dept_test2;

 

동일한 값을 여러 테이블에 동시 입력하는 multiple insert;
INSERT ALL
    INTO dept_test 
    INTO dept_test2
SELECT 98, '대덕', '중앙로' FROM dual UNION ALL 
SELECT 97, 'IT', '영민' FROM dual;

테이블에 입력할 컬럼을 지정 multiple insert;
ROLLBACK;
INSERT ALL
    INTO dept_test (deptno,loc) VALUES (deptno, loc)
    INTO dept_test2
SELECT 98 deptno, '대덕' dname, '중앙로'loc FROM dual UNION ALL -- 위에 컬럼명을 입력 
SELECT 97, 'IT', '영민' FROM dual;

테이블에 입력할 데이트를 조건에 따라 multiple insert;
CASE
    WHEN 조건 기술 THEN
END;

조건을 만족하는 첫번째 insert만 실행하는 multiple insert

ROLLBACK;
INSERT FIRST
    WHEN deptno >= 98 THEN
    INTO dept_test (deptno,loc) VALUES (deptno, loc)
  WHEN deptno >= 97 then
    INTO dept_test2
  ELSE
    INTO dept_test2
SELECT 98 deptno, '대덕' dname, '중앙로'loc FROM dual UNION ALL -- 위에 컬럼명을 입력 
SELECT 97, 'IT', '영민' FROM dual;

SELECT * 
FROM dept_test;

SELECT * 
FROM dept_test2;


오라클 객체 : 테이블에 여러개의 구역을 파티션으로 구분
테이블 이름동일하니 값의 종류에 따라 오라클 내부적으로 별도의
분리된 영역에 데이터를 저장;

dept_test ==> dept_test_20200201


INSERT FIRST
    WHEN deptno >= 98 THEN
    INTO dept_test 20200201
  WHEN deptno >= 97 then
    INTO dept_test2 20200202
  ELSE
    INTO dept_test2
SELECT 98 deptno, '대덕' dname, '중앙로'loc FROM dual UNION ALL -- 위에 컬럼명을 입력 
SELECT 97, 'IT', '영민' FROM dual;

SELECT*
FROM dept_test;

MERGE : 통합 
테이블에 데이터를 입력/갱신 하려고 함
1. 내가 입력하려고 하는 데이터가 존재하면
 ==> 업데이트 
2. 내가 입력하려고 하는 데이터가 존재하지 않으면
 ==> INSERT


1.SELECT 실행
2-1.SELECT 실행 결과가 0 ROW이면 INSERT 
2-2.SELECT 실행 결과가 1 ROW이면 UPDATE

WHERE 구문을 사용하게 되면 SELECT 를 하지 않아도 자동으로 데이터 유무에 따라
INSERT 혹은 UPDATE 실행한다
2명의 쿼리를 한번으로 준다. 

MERGE INTO 테이블명 [alias]
USING (TABLE | VIEW | IN-LINE-VIEW)
ON (조인조건)
WHEN MATCHED THEN 
    UPDATE SET col = 컬럼값, col2 = 컬럼값....
WHEN NOT MATCHED THEN 
    INSERT (컬럼1, 컬럼2....)VALUES (컬럼값1, 컬럼값2.....);
    
SELECT *
FROM emp_test;

DELETE emp_test;

로그를 안남긴다 ==> 복구가 안된다 ==> 테스트용으로 ... 
TRUNCATE TABLE emp_test;
rollback;
emp테이블에서 emp_test테이블로 데이터를 복사(7369-SMITH);

INSERT INTO emp_test
SELECT empno, ename, deptno, '010'
FROM emp
WHERE empno = 7369;

UPDATE emp_test SET ename = 'brown'
WHERE empno = 7369;
COMMIT; 

emp테이블의 모든 직원을 emp_test 테이블로 통합
emp테이블에는 존재하지만 emp_test에는 존재하지 않으면 insert
emp테이블에는 존재하고 emp_test에도 존재하면 ename, deptno를 update;

emp테이블에 존재하는 14건의 데이터중 emp_test에도 존재하는 7369를 제외한 13건의 데이터가
emp_test 테이블에 신규로 입력이 되고
emp_test에 존재하는 7369번의 데이터는 ename(brown)이 emp테이블에 존재하는 이름 SMITH로 갱신.

MERGE INTO emp_test a
USING emp b
ON (a.empno = b.empno)
WHEN MATCHED THEN
    UPDATE SET a.ename = b.ename, 
               a.deptno = b.deptno

WHEN NOT MATCHED THEN
    INSERT (empno, ename, deptno) VALUES (b.empno, b.ename, b.deptno);

SELECT * 
FROM emp_test;


해당 테이블에 데이터가 있으면 insert, 없으면 update
emp_test테이블에 사번이 9999번인 사람이 없으면 새롭게 insert
있으면 update
(9999, 'brown', 10, '010');

INSERT INTO dept_test VALUES (9999, 'brown', 10, '010')
UPDATE dept_tset SET ename = 'brown'
                deptno = 10
                hp = '010'
WHERE empno = 9999;

MERGE INTO emp_test 
USING dual
ON(empno = 9999)
WHEN MATCHED THEN
        UPDATE SET ename = ename ||'_u',
                deptno = 10,
                hp = '010'
    WHEN NOT MATCHED THEN
       INSERT VALUES (9999,'brown',10,'010');
       
SELECT * 
FROM emp_test;

union all

select deptno, sum(sal)
from emp
group by deptno;


ALTER TABLE emp_test DROP CONSTRAINT PK_EMP_TEST;

I/O
CPU CACHE > RAM > SSD > HDD > NETWORK;

ROLLUP
사용방법 : GROUP BY ROLLUP (컬럼1, 컬럼2 .....);
SUBGROUP을 자동적으로 생성
SUBGROUP을 생성하는 규칙 : ROLLUP에 기술한 컬럼을 오른쪽에서부터 하나씩 제거하하면서
                         SUB GROUP을 생성;
                         
EX : GROUP BY ROLLUP (deptno) 
==>
 첫번째 sub group : GROUP BY deptno
 두번째 sub group : GROUP BY NULL ==> 전체 행을 대상
 
GROUP_AD1을 GROUP BY ROLLUP 절을 사용하여 작성;
SELECT deptno, SUM(sal)
FROM emp 
GROUP BY ROLLUP (deptno);


SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

GROUP BY job, deptno : 담당업무, 부서별 급여합
GROUP BY job  : 담당업무별 급여합
GROUP BY  : 전체 급여합

SELECT job, deptno,
    GROUPING (job), GROUPING(deptno),
    SUM(sal + NVL(comm, 0))sal
    FROM emp
   GROUP BY ROLLUP (job,deptno);
 
 
--gb2 실습  
SELECT CASE WHEN GROUPING (job) = 1  AND GROUPING(deptno) =1 THEN '총계'
    else job
    END job,
    deptno,
    SUM(sal + NVL(comm,0))sal
    FROM emp
    GROUP BY ROLLUP (job,deptno);
    
--과제 2-2
SELECT DECODE ( GROUPING (job) + GROUPING (deptno), 2, '총',
                                                   1, job,
                                                   0, job)job,
       DECODE  ( GROUPING (job) + GROUPING (deptno), 2, '계',
                                                  2, '소계',
                                                  0, deptno)deptno,
 SUM(sal + NVL(comm,0))sal
    FROM emp
    GROUP BY ROLLUP (job,deptno);
    


   
   
 

