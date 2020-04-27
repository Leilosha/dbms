-- 180113006 Kuanysheva Adema
SET SERVEROUTPUT ON;

/*select * from course_sections;
  select * from course_schedule;
  select * from course_selections;
  describe course_sections;
  describe course_selections;*/
  
UPDATE course_sections
 SET hour_num = 3; 
 
UPDATE course_sections
 SET week_num = 15;

UPDATE course_sections
 SET credits = 3; 
 
--1
CREATE OR REPLACE PROCEDURE popular_courses
 (p_term IN course_selections.term%TYPE,
  p_year IN course_selections.year%TYPE) IS
 v_courses NUMBER(5); 
 CURSOR pop_cur IS
  SELECT COUNT(ders_kod), ders_kod
   FROM course_selections
    WHERE term = p_term AND year = p_year
    GROUP BY ders_kod
    ORDER BY ders_kod DESC;
  pop_rec pop_cur%ROWTYPE;  
BEGIN
 DBMS_OUTPUT.PUT_LINE('List of popular courses in descending order: '); 
 OPEN pop_cur;
 LOOP
  FETCH pop_cur INTO pop_rec;
  EXIT WHEN pop_cur%NOTFOUND;
   DBMS_OUTPUT.PUT_LINE(pop_rec.ders_kod);
  END LOOP;
 CLOSE pop_cur; 
END popular_courses;

BEGIN
 popular_courses(1,2019);
END;
/

--3
 CREATE OR REPLACE FUNCTION gpa
  (p_id course_selections.stud_id%TYPE)
  RETURN NUMBER IS
   v_total_sub NUMBER(5);
   v_total_qp NUMBER(5);
   v_total_h NUMBER(5);
   v_gpa NUMBER(2);
   v_alp VARCHAR2(5);
 BEGIN
   SELECT SUM(qiymet_yuz) INTO v_total_qp
    FROM course_selections 
    WHERE stud_id = p_id  AND qiymet_yuz IS NOT NULL;
   SELECT COUNT(ders_kod) INTO v_total_sub
    FROM course_selections
    WHERE stud_id = p_id  AND qiymet_yuz IS NOT NULL;
   v_total_h :=  v_total_qp / v_total_sub;
   CASE 
    WHEN v_total_h < 50
     THEN v_gpa := 0;
    WHEN v_total_h >= 50 AND v_total_h < 55
     THEN v_gpa := 1;
    WHEN v_total_h >= 55 AND v_total_h < 60
     THEN v_gpa := 1.33; 
    WHEN v_total_h >= 60 AND v_total_h < 65
     THEN v_gpa := 1.67; 
    WHEN v_total_h >= 65 AND v_total_h < 70
     THEN v_gpa := 2; 
    WHEN v_total_h >= 70 AND v_total_h < 75
     THEN v_gpa := 2.33; 
    WHEN v_total_h >= 75 AND v_total_h < 80
     THEN v_gpa := 2.67; 
    WHEN v_total_h >= 80 AND v_total_h < 85
     THEN v_gpa := 3;
    WHEN v_total_h >= 85 AND v_total_h < 90
     THEN v_gpa := 3.33;
    WHEN v_total_h >= 90 AND v_total_h < 95
     THEN v_gpa := 3.67; 
    WHEN v_total_h >= 95 AND v_total_h <= 100 
     THEN v_gpa := 4; 
   END CASE;   
  RETURN v_gpa;
 END gpa; 
 
 CREATE OR REPLACE FUNCTION gpa_semester
  (p_id course_selections.stud_id%TYPE,
   p_year course_selections.year%TYPE,
   p_term course_selections.term%TYPE)
  RETURN NUMBER IS
   v_total_sub NUMBER(5);
   v_total_qp NUMBER(5);
   v_total_h NUMBER(5);
   v_gpa NUMBER(2);
   v_alp VARCHAR2(5);
 BEGIN
   SELECT SUM(qiymet_yuz) INTO v_total_qp
    FROM course_selections 
    WHERE stud_id = p_id  AND qiymet_yuz IS NOT NULL AND term = p_term AND year = p_year;
   SELECT COUNT(ders_kod) INTO v_total_sub
    FROM course_selections
    WHERE stud_id = p_id  AND qiymet_yuz IS NOT NULL AND term = p_term AND year = p_year;
   v_total_h :=  v_total_qp / v_total_sub;
   CASE 
    WHEN v_total_h < 50
     THEN v_gpa := 0;
    WHEN v_total_h >= 50 AND v_total_h < 55
     THEN v_gpa := 1;
    WHEN v_total_h >= 55 AND v_total_h < 60
     THEN v_gpa := 1.33; 
    WHEN v_total_h >= 60 AND v_total_h < 65
     THEN v_gpa := 1.67; 
    WHEN v_total_h >= 65 AND v_total_h < 70
     THEN v_gpa := 2; 
    WHEN v_total_h >= 70 AND v_total_h < 75
     THEN v_gpa := 2.33; 
    WHEN v_total_h >= 75 AND v_total_h < 80
     THEN v_gpa := 2.67; 
    WHEN v_total_h >= 80 AND v_total_h < 85
     THEN v_gpa := 3;
    WHEN v_total_h >= 85 AND v_total_h < 90
     THEN v_gpa := 3.33;
    WHEN v_total_h >= 90 AND v_total_h < 95
     THEN v_gpa := 3.67; 
    WHEN v_total_h >= 95 AND v_total_h <= 100 
     THEN v_gpa := 4; 
   END CASE;   
  RETURN v_gpa;
 END gpa_semester; 
 
--Test gpa total 
BEGIN
 DBMS_OUTPUT.PUT_LINE('Student gpa for all time: ' || gpa('4106B13FEC90C2FDCF0BAEB882D77A27235CEFDD'));
END;

--Test gpa for semester
BEGIN
 DBMS_OUTPUT.PUT_LINE('Student gpa for the following semester: ' || gpa_semester('4106B13FEC90C2FDCF0BAEB882D77A27235CEFDD', 2019, 1));
END;


--4
CREATE OR REPLACE PROCEDURE student_without_courses
 (p_term IN course_selections.term%TYPE,
  p_year IN course_selections.year%TYPE)
IS 
 CURSOR swc_cur
 IS 
  SELECT stud_id
  FROM course_selections
  WHERE term = p_term AND qiymet_yuz = NULL ;
 stud_rec swc_cur%ROWTYPE; 
BEGIN
  OPEN swc_cur;
   LOOP 
    FETCH swc_cur INTO stud_rec;
    EXIT WHEN swc_cur%NOTFOUND;
    DBMS_OUTPUT.enable(100000);
    DBMS_OUTPUT.PUT_LINE('Student without course for the following term is: ' || stud_rec.stud_id);
   END LOOP; 
END student_without_courses; 
 
BEGIN
 student_without_courses(1,2018);
END;
/

--5
CREATE OR REPLACE FUNCTION stu_retake_sum
 (p_id course_selections.stud_id%TYPE,
  p_term course_selections.term%TYPE,
  p_year course_selections.year%TYPE) 
  RETURN NUMBER IS
   v_total_fee NUMBER(10);
   v_fx NUMBER(5);
BEGIN  
 SELECT COUNT(qiymet_herf) INTO v_fx
  FROM course_selections
  WHERE qiymet_yuz < 50 AND qiymet_yuz IS NOT NULL AND term = p_term AND year = p_year AND stud_id = p_id;
  v_total_fee := v_fx * 75000;
 RETURN v_total_fee; 
END stu_retake_sum;

--Total retake sum of a student 
CREATE OR REPLACE FUNCTION stu_total_retake_sum
 (p_id course_selections.stud_id%TYPE) 
  RETURN NUMBER IS
   v_total_fee NUMBER(10);
   v_fx NUMBER(5);
BEGIN  
 SELECT COUNT(qiymet_herf) INTO v_fx
  FROM course_selections
  WHERE qiymet_yuz < 50 AND qiymet_yuz IS NOT NULL AND stud_id = p_id;
  v_total_fee := v_fx * 75000;
 RETURN v_total_fee; 
END stu_total_retake_sum;

BEGIN
 DBMS_OUTPUT.PUT_LINE('Retake sum: ' || stu_total_retake_sum('0C92906FFDFE7945E64F9AAD997D6246AA5A7427') || ' tenge.');
END;

--6
CREATE OR REPLACE FUNCTION teacher_load
 (p_teacher_id course_sections.emp_id%TYPE,
  p_term course_sections.term%TYPE,
  p_year course_sections.year%TYPE)
 RETURN NUMBER IS
 v_ders NUMBER(5);
 v_total NUMBER(5);
BEGIN
 SELECT COUNT(ders_kod) INTO v_ders
  FROM course_sections
  WHERE emp_id = p_teacher_id AND emp_id IS NOT NULL AND term = p_term AND year = p_year;
  v_total := v_ders * 15 * 3; 
 RETURN v_total; 
END teacher_load;

BEGIN
 DBMS_OUTPUT.PUT_LINE('Overall working hours for this professor: ' || teacher_load('10246', 1, 2015) || ' for this semester');
END;
/
 
--9
CREATE OR REPLACE FUNCTION courses_taken 
 (p_id   IN course_selections.stud_id%TYPE,
  p_year IN course_selections.year%TYPE,
  p_term IN course_selections.term%TYPE)
  RETURN NUMBER IS
  v_total NUMBER(5);
BEGIN 
 SELECT COUNT(ders_kod) INTO v_total
  FROM course_selections
  WHERE stud_id = p_id AND year = p_year AND term = p_term;
  RETURN v_total;
END courses_taken;

BEGIN
 DBMS_OUTPUT.PUT_LINE(courses_taken('A507E19FD7B670FFCA14EC011E39ADB2D4EBFAF9', 2019, 1));
END;
  
--13
CREATE OR REPLACE PROCEDURE retake_sum IS
 v_fx NUMBER(5);
 v_total NUMBER(20);
BEGIN
 SELECT COUNT(qiymet_herf) INTO v_fx
  FROM course_selections
  WHERE qiymet_yuz < 50 AND qiymet_yuz IS NOT NULL;
 v_total := v_fx * 75000;
 DBMS_OUTPUT.PUT_LINE('Profit from the retakes: ' || v_total || ' tenge.');
END retake_sum;
   
BEGIN
 retake_sum;
END;
/

--12
CREATE SEQUENCE sub_rate_seq START WITH 1;

CREATE OR REPLACE PROCEDURE subject_rating
 (p_term IN course_selections.term%TYPE,
  p_year IN course_selections.year%TYPE) IS
 v_courses NUMBER(5); 
 v_id NUMBER(5);
 CURSOR pop_cur IS
  SELECT COUNT(ders_kod), ders_kod
   FROM course_selections
    WHERE term = p_term AND year = p_year
    GROUP BY ders_kod
    ORDER BY ders_kod DESC;
  pop_rec pop_cur%ROWTYPE;  
BEGIN
 DBMS_OUTPUT.PUT_LINE('Subject raiting, from most to the least popular: '); 
 OPEN pop_cur;
 LOOP 
  FETCH pop_cur INTO pop_rec;
  EXIT WHEN pop_cur%NOTFOUND;
  SELECT sub_rate_seq.nextval
  INTO v_id
  FROM dual;
   DBMS_OUTPUT.PUT_LINE(v_id || ' ' || pop_rec.ders_kod);
  END LOOP;
 CLOSE pop_cur; 
END subject_rating;

BEGIN
 subject_rating(1,2019);
END;
/


--2
 CREATE OR REPLACE PROCEDURE popular_teacher
  (p_semester   IN  course_sections.term%TYPE, 
   p_year       IN  course_sections.year%TYPE, 
   p_code       IN  course_sections.ders_kod%TYPE,
   p_lecturer   OUT course_sections.emp_id_ent%TYPE,
   p_instructor OUT course_sections.emp_id%TYPE) IS
 BEGIN  
 END popular_teacher;
 
CREATE OR REPLACE PACKAGE project_pkg
 IS
 PROCEDURE  popular_courses
 (p_term IN course_selections.term%TYPE,
  p_year IN course_selections.year%TYPE);
 PROCEDURE student_without_courses
 (p_term IN course_selections.term%TYPE,
  p_year IN course_selections.year%TYPE); 
 FUNCTION  gpa
  (p_id course_selections.stud_id%TYPE)
  RETURN NUMBER;
 FUNCTION courses_taken 
 (p_id   IN course_selections.stud_id%TYPE,
  p_year IN course_selections.year%TYPE,
  p_term IN course_selections.term%TYPE)
  RETURN NUMBER; 
 FUNCTION teacher_load
 (p_teacher_id course_sections.emp_id%TYPE,
  p_term course_sections.term%TYPE,
  p_year course_sections.year%TYPE)
  RETURN NUMBER; 
  FUNCTION stu_total_retake_sum
 (p_id course_selections.stud_id%TYPE) 
  RETURN NUMBER; 
 FUNCTION stu_retake_sum
 (p_id course_selections.stud_id%TYPE,
  p_term course_selections.term%TYPE,
  p_year course_selections.year%TYPE) 
  RETURN NUMBER; 
END project_pkg;
/
