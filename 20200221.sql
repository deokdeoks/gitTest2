--PL/SQL PRO_2
CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept_test.dname %TYPE, 
                                             p_dname IN dept_test.deptno %TYPE, 
                                             p_loc IN dept_test.deptno%TYPE) IS

BEGIN

INSERT INTO dept_test VALUES(p_deptno, p_dname, p_loc, 0);
END;
/
INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon',0);
 SELECT* 
FROM dept_test;
exec registdept_test(99, 'ddit', 'daejeon');



--PL/SQL PRO_3
CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept_test.dname %TYPE, 
                                             p_dname IN dept_test.deptno %TYPE, 
                                             p_loc IN dept_test.deptno%TYPE) IS

BEGIN

INSERT INTO dept_test VALUES(p_deptno, p_dname, p_loc, 0);
END;
/

UPDATE dept_test SET dname = 'ddit_m' , loc = 'daejeon'
WHERE deptno = 99;

CREATE OR REPLACE PROCEDURE updatedept_test(
                               p_deptno IN dept_test.deptno%TYPE,
                               p_dname IN dept_test.dname%TYPE,
                               p_loc IN dept_test.loc%TYPE) IS
BEGIN 
    UPDATE dept_test SET dname = p_dname , loc = p_loc
    WHERE deptno = p_deptno;
    
    COMMIT;
    
    END;
    /
    
    EXEC updatedept_test(96, 'ddit_m', 'daejon');
    
    
복합변수 %rowtype : 특정 테이블의 행을 저장할 수 있는 변수
사용 방법 : 변수명 테이블명%ROWTYPE
;

DECLARE 
    v_dept_row dept%ROWTYPE;
BEGIN 
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' '  || v_dept_row.dname || ' ' || v_dept_row.loc);
END;
/

SET SERVEROUTPUT ON;

복합변수 RECORD
개발자가 직접 여러개의 컬럼을 관리할 수 있는 타입을 생성하는 명령
JAVA를 비유하면 클래스를선언하는 과정
인스턴스를 만드는 과정은 변수선언

문법
TYPE 타입이름(개발자가 지정) IS RECORD(
변수명1 변수타입,
변수명2 변수타입,
);

변수명 타입이름;

DECLARE
    TYPE dept_row IS RECORD(
        deptno NUMBER(2), 
        dname VARCHAR2(14)
    );
    
    v_dept_row dept_row;
BEGIN
    SELECT deptno, dname INTO v_dept_row
    FROM dept
    WHERE deptno= 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ' ' || v_dept_row.dname);

END;
/
SET SERVEROUTPUT ON;

table type 테이블 타입
점 : 스칼라 변수
선 : %ROWTYPE, record type
면 : table type
    어떤 선 (%ROWTYPE, RECORD TYPE)을 저장할 수 있는지
    인덱스 타입은 무엇인지;
    
DEPT 테이블의 정보를 담을 수 있는 table type을 선언
기존에 배운 스칼라 타입, rowtype에서는 한 행의 정보를 담을 수 있었지만
table 타입 변수를 이용하면 여러 행의 정보를 담을 수 있다.

PL/SQL 에서는 자바와 다르게 배열에 대한 인덱스가 정수로 고정되어 있지 않고
문자열도 가능하다.

그래서 TABLE 타입을 선언할 때는 인덱스에 대한 타입도 같이 명시;
BINARY_INTEGER 타입은 PL/SQL에서만 사용 가능한 타입으로
NUMBER 타입을 이용하여 정수만 사용 가능하게 끔한 NUMBER 타입의 서브 타입이다;

DECLARE 
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept_tab dept_tab;
    BEGIN 
        SELECT * BULK COLLECT INTO v_dept_tab
        FROM dept;
        --기존 스칼라 변수, record 타입을 실습시에는
    --한행만 조회 되도록 where절을 통해 제한하였다
    --자바에서는 배열[인덱스 번호]
    --table 변수(인덱스 번호)로 접근
    DBMS_OUTPUT.PUT_LINE(v_dept_tab(1).deptno || ' ' || v_dept_tab(1).dname);
    DBMS_OUTPUT.PUT_LINE(v_dept_tab(2).deptno || ' ' || v_dept_tab(2).dname);
    DBMS_OUTPUT.PUT_LINE(v_dept_tab(3).deptno || ' ' || v_dept_tab(3).dname);
    DBMS_OUTPUT.PUT_LINE(v_dept_tab(4).deptno || ' ' || v_dept_tab(4).dname);
    END;
    /


DECLARE 
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    
조건제어 IF
문법

IF 조건문 THEN
 실행문;
 ELSIF 조건문 THEN
 실행문;
 ELSE
 ;
 
 DECLARE
    p NUMBER(1) := 2; --변수 선언과 동시에 값을 대입
BEGIN
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('1입니다');
    ELSIF p = 2 THEN
        DBMS_OUTPUT.PUT_LINE('2입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('알려지지 않았습니다');
    END IF;
END;
/

CASE 구문 
1. 일반 케이스(java의 switch와 유사)
2. 검색 케이스(if, else if , else)

CASE expression 
    WHEN value THEN 
        실행문;
    WHEN value THEN 
        실행문;
    ELSE
        실행문;
END CASE;

DECLARE
    p NUMBER(1) := 2;
BEGIN
    CASE p 
        WHEN 1 THEN
            DBMS_OUTPUT.PUT_LINE('1입니다.');
        WHEN 2 THEN
            DBMS_OUTPUT.PUT_LINE('2입니다.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('모르는 값입니다');
    END CASE;
END;
/

FOR Loop 문법
FOR 루프변수/인덱스변수 in[REVERSE] 시작값.. 종료값 LOOP
    반복할 로직;
END LOOP;

1부터 5까지 FOR LOOP 반복문을 이용하여 숫자 출력 ;

DECLARE 
BEGIN 
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

실습 : 2~9단 까지의 구구단을 출력;

DECLARE
BEGIN
    FOR i IN 2..9 LOOP
    FOR j IN 1..9 LOOP 
DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' ||i*j);
    END LOOP;
    END LOOP;
END;
/

While loop 문법
WHILE 조건 Loop
    반복문실행할 로직;
END Loop;

DECLARE
    i NUMBER := 0;
BEGIN 
    WHILE i <= 5 Loop
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
    END LOOP;
END;
/


LOOP문 문법 ==> while(true)
LOOP    
    반복실행할 문자;
END LOOP;
    반복실행할 문자;
    EXIT 조건;
END LOOP;


DECLARE
    i NUMBER  := 0;
BEGIN 
    LOOP
      
        EXIT WHEN i > 5;
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
        END LOOP;
END;
/