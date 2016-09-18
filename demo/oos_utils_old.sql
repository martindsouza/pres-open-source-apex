-- OOS Utils Demo
-- SQL dev Trip

-- https://github.com/OraOpenSource/oos-utils

declare
begin
  dbms_lock.sleep(5);
end;
/


-- sleep
declare
begin
  oos_util.sleep(10);
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
select oos_util_web.get_mime_type('oos_utils.xls')
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
   dbms_output.put_line(oos_util_string.tochar(l_ans));
end;
/



declare
  l_ans boolean;
begin
  l_ans := oos_util_validation.is_number('123.45');

  dbms_output.put_line(oos_util_string.tochar(l_ans));
end;
/



-- Strings
declare
  l_ans boolean;
begin
  l_ans := oos_util_validation.is_date('21-Jan-2016', 'DD-MON-YYYY');

  dbms_output.put_line(oos_util_string.tochar(l_ans));
end;
/


select
--  'hello' || e.ename || 'you make ' || e.sal || 'a year'
  oos_util_string.sprintf('hello %s1 you make %s1 a year', e.ename, e.sal)
from emp e;


select oos_util_string.sprintf('hello %s you make %s a year', e.ename, e.sal)
from emp e;


select oos_util_string.sprintf('hello %s2 you make %s1 a year', e.ename, e.sal)
from emp e;



select
--  ad.apex_view_name,
--  ad.comments,
  case
    when length(ad.comments) > 35-3 then
      substr(ad.comments, 1, 35-3) || '...'
    else
      ad.comments
  end comments_trunc,
--
   oos_util_string.truncate_string(
     p_str => ad.comments,
     p_length => 35
     , p_by_word => 'Y'
   )
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

select listagg(e.deptno, ',') within group (order by e.ename)
from emp e;

select d.dname
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
  sf.file_name,
  trunc(dbms_lob.getlength(sf.file_content) / 1024)  || 'kb' len,
--  oos_util_lob.get_lob_size(sf.file_content) len_n
  oos_util_lob.get_lob_size(sf.file_content, 'KB') len_b
from apex_application_static_files sf;


-- blob2clob
select
  sf.file_content,
  oos_util_lob.blob2clob(sf.file_content) cl_data
from apex_application_static_files sf
where 1=1
  and file_name = 'readme.txt'
;





-- DATE
select
  sysdate,
  oos_util_date.date2epoch(sysdate)
  ,oos_util_date.epoch2date(1452948933)
from dual;



-- APEX

-- Show trim

-- Show Download


select v('P1_X')
from dual;


declare
begin
  oos_util_apex.join_session(p_session_id => 10777192173425);
end;
/

select v('P1_X'), v('APP_USER'), v('APP_SESSION')
from dual;


-- Test the APEX collections
-- Buil apex collections
select *
from apex_collections;




-- EXTRA:
-- Contribute to project, testers requred!
-- PLsql md doc
