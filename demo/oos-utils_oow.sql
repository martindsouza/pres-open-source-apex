-- OOS Utils Demo
-- SQL dev Trip

-- https://github.com/OraOpenSource/oos-utils
-- https://apex.fuzziebrain.com/ords/f?p=102
-- http://vcentos:10080/ords/f?p=176

set serveroutput on

declare
begin
  dbms_lock.sleep(5);
end;
/


-- sleep
declare
begin
  oos_util.sleep(5);
end;
/


-- assert
declare
  l_x pls_integer := 1;
begin
  if l_x < 10 then
    raise_application_error(-20001, 'l_x must be >= 10');
  end if;
end;
/


declare
  l_x pls_integer := 1;
begin
  oos_util.assert(l_x >= 10, 'l_x must be >= 10');
end;
/




-- Mime Types
select oos_util_web.get_mime_type('oos_utils.jpg')
from dual;


-- Validations
declare
  l_ans boolean;
begin
  l_ans := oos_util_validation.is_date('32-Jan-2016', 'DD-MON-YYYY');

--  dbms_output.put_line(l_ans);

--   if l_ans = true then
--     dbms_output.put_line('TRUE');
--   else
--     dbms_output.put_line('FALSE');
--   end if;


--   dbms_output.put_line(oos_util_string.to_char(l_ans));
end;
/



-- *** Don't show
--declare
--  l_ans boolean;
--begin
--  l_ans := oos_util_validation.is_number('123.45');
--
--  dbms_output.put_line(oos_util_string.to_char(l_ans));
--end;
--/



-- Strings


-- *** Don't show
--declare
--  l_ans boolean;
--begin
--  l_ans := oos_util_validation.is_date('21-Jan-2016', 'DD-MON-YYYY');
--
--  dbms_output.put_line(oos_util_string.to_char(l_ans));
--end;
--/


select
  'hello ' || e.ename || ' you make ' || e.sal || ' a year'
--  oos_util_string.sprintf('hello %s1 you make %s2 a year', e.ename, e.sal)
from emp e;


select oos_util_string.sprintf('hello %s you make %s a year', e.ename, e.sal)
from emp e;


select oos_util_string.sprintf('hello %s2 you make %s1 a year', e.ename, e.sal)
from emp e;


-- sprint f
select
  ad.apex_view_name
  , ad.comments

--  , case
--    when length(ad.comments) > 20-3 then
--      substr(ad.comments, 1, 20-3) || '...'
--    else
--      ad.comments
--  end comments_trunc

--   , oos_util_string.truncate(
--     p_str => ad.comments,
--     p_length => 20
--     , p_by_word => 'Y'
--   ) trunc_word
from apex_dictionary ad
where 1=1
  and ad.column_id = 0
order by ad.apex_view_name
;


-- String to Table
declare
  l_arr oos_util_string.tab_vc2_arr;
begin

  l_arr := oos_util_string.string_to_table('abc,def,ghi', ',');

  for i in 1..l_arr.count loop
    dbms_output.put_line(l_arr(i));
  end loop;
end;
/

-- Major diff is that it accepts clobs!



-- Unagg
select ename from emp;

select listagg(e.ename, ',') within group (order by e.ename)
from emp e;


select rownum, column_value
  from table(oos_util_string.listunagg('ADAMS,ALLEN,BLAKE,CLARK,FORD,JAMES,JONES,KING,MARTIN,MILLER,SCOTT,SMITH,TURNER,WARD'))
;

-- *** don't show (show below)
--select d.deptno, d.dname, x.ename
--from dept d,
--(
--  select rownum, e.ename, e.deptno
--  from table(oos_util_string.listunagg('ADAMS,ALLEN,BLAKE,CLARK,FORD,JAMES,JONES,KING,MARTIN,MILLER,SCOTT,SMITH,TURNER,WARD')) x,
--    emp e
--  where x.column_value = e.ename
--) x
--where 1=1
--  and d.deptno = x.deptno
--;



select d.deptno, d.dname
from dept d,
(
  select rownum, to_number(column_value) deptno
  from table(oos_util_string.listunagg('20,30,30,10,20,30,20,10,30,10,20,20,30,30'))
) x
where 1=1
  and d.deptno = x.deptno
;
-- Handles clobs as well!!!


-- LOBS
select
  sf.file_name,
  sf.file_content,
  dbms_lob.getlength(sf.file_content)
from apex_application_static_files sf;


select
  sf.file_name
  ,trunc(dbms_lob.getlength(sf.file_content) / 1024)  || ' kb' len
--  ,oos_util_lob.get_lob_size(sf.file_content) len_n
  ,oos_util_lob.get_lob_size(sf.file_content, 'KB') len_kb
from apex_application_static_files sf
order by lower(sf.file_name)
;


-- blob2clob
select
  sf.file_name,
  sf.file_content
  ,oos_util_lob.blob2clob(sf.file_content) cl_data
from apex_application_static_files sf
where 1=1
  and file_name = 'readme.txt'
;





-- DATE
-- *** Don't show
--select
--  sysdate
----  ,oos_util_date.date2epoch(sysdate)
----  ,oos_util_date.epoch2date(1472218426)
--from dual;



-- APEX
-- Under Giffy
-- http://vcentos:10080/ords/f?p=136


-- Is Developer
oos_util_apex.is_developer
/
-- Show trim

-- Show Download


-- SAVE value in P1 (abc)

select v('P1_X')
from dual;


select *
from apex_collections;

-- APEX
-- Sample App: Orders > Enter New Order
-- Go through a few screens

-- CHANGE CONNECTION TO GIFFY
declare
begin
  oos_util_apex.join_session(p_session_id => '2614251154662');
end;
/

select v('P1_X'), v('APP_USER'), v('APP_SESSION')
from dual;


-- Test the APEX collections
-- Buil apex collections
select *
from apex_collections;





-- FOR CONCLUSION (below)


-- TOTP

date
sudo service ntp stop
sudo ntpdate -s time.nist.gov
sudo service ntp start
date


-- Open airserver
-- Mirror iPhone

-- Go to basic login screen
http://vcentos:10080/ords/f?p=136

-- TOTP one
http://vcentos:10080/ords/f?p=176

-- EXTRA:
-- Contribute to project, testers requred!
-- PLsql md doc
