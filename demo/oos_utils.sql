-- TODO mdsouza: review what is/isnt' commented before running
-- *** OOS_UTIL_APEX **

-- * oos_util_apex.is_developer *

-- APEX demo
/*
Condition:
oos_util_apex.is_developer
*/


-- * oos_util_apex.create_session *
declare
    l_body clob;
begin
  l_body := 'this is a demo';

  apex_mail.send(
    p_to  => 'mdsouza@insum.ca',
    p_from  => 'mdsouza@insum.ca',
    p_body  => l_body,
    p_subj  => 'demo mail from plsql');

  apex_mail.push_queue;
end;
/


/* Results in:
Error report -
ORA-20001: This procedure must be invoked from within an application session.
ORA-06512: at "APEX_050000.WWV_FLOW_MAIL", line 562
ORA-06512: at "APEX_050000.WWV_FLOW_MAIL", line 688
ORA-06512: at "APEX_050000.WWV_FLOW_MAIL", line 720
ORA-06512: at "APEX_050000.WWV_FLOW_MAIL_API", line 69
ORA-06512: at line 6
*/

declare
  l_body clob;
begin
  oos_util_apex.create_session(
    p_app_id => 136,
    p_user_name => 'giffy'
  );

  l_body := 'this is a demo';

  apex_mail.send(
    p_to  => 'mdsouza@insum.ca',
    p_from  => 'martin@clarifit.com',
    p_body  => l_body,
    p_subj  => 'demo mail from plsql');

  apex_mail.push_queue;
end;
/


-- Disconnect / reconnect

-- * oos_util_apex.join_session *
select *
from apex_collections;

-- Only real way is to look at the debug tab
-- What about views built ontop of collections?

begin
  oos_util_apex.join_session('CHANGEME');
end;
/

select *
from apex_collections;

-- Notes:
-- snapshot of APEX items at point in time (working on it)


-- *** OOS_UTIL_STING ***

-- * to_char *

declare
  l_bool boolean := true;
begin
  dbms_output.put_line(l_bool);
end;
/


-- Old
declare
  l_bool boolean := true;
begin
  dbms_output.put_line(case when l_bool then 'TRUE' else 'FALSE' end);
end;
/

-- New
declare
  l_bool boolean := true;
begin
  dbms_output.put_line(oos_util_string.to_char(l_bool));
end;
/




-- * oos_util_string.sprintf *

select
 'hello' || e.ename || 'you make ' || e.sal || 'a year'
--   oos_util_string.sprintf('hello %s1 you make %s1 a year', e.ename, e.sal)
from emp e;


select oos_util_string.sprintf('hello %s you make %s a year', e.ename, e.sal)
from emp e;


select oos_util_string.sprintf('hello %s2 you make %s1 a year', e.ename, e.sal)
from emp e;




-- * oos_util_string.listunagg *
select ename from emp;

select listagg(e.deptno, ':') within group (order by e.ename)
from emp e;

select d.dname
from dept d,
(
  select rownum, to_number(column_value) deptno
  from table(oos_util_string.listunagg('20:30:30:10:20:30:20:10:30:10:20:20:30:30', ':'))
) x
where 1=1
  and d.deptno = x.deptno
;
-- Handles clobs as well!!!


-- * oos_util_string.truncate *
select
 ad.apex_view_name,
 ad.comments
--   ,case
--     when length(ad.comments) > 35-3 then
--       substr(ad.comments, 1, 35-3) || '...'
--     else
--       ad.comments
--   end comments_trunc
-- ,
--    oos_util_string.truncate(
--      p_str => ad.comments,
--      p_length => 35
----      , p_by_word => 'N'
--    )
from apex_dictionary ad
where 1=1
  and ad.column_id = 0
order by ad.apex_view_name
;





-- *** oos_util_validation ***

declare
  l_apex_item varchar2(255) := '123.45';
  l_num number;
begin

  l_num := to_number(l_apex_item);
  dbms_output.put_line('Valid Number');
exception
  when others then
    dbms_output.put_line('Invalid Number');
end;
/


declare
begin
  dbms_output.put_line(oos_util_string.to_char(oos_util_validation.is_number('123.45')));
end;
/



-- *** OOS_UTIL_WEB ***

-- oos_util_web.get_mime_type
select oos_util_web.get_mime_type('oos_utils.xls')
from dual;


-- Download File (APEX)
declare
  l_row apex_application_static_files%rowtype;
begin
  select *
  into l_row
  from apex_application_static_files
  where 1=1
    and application_id = 160
    and file_name = 'image.png';

  oos_util_web.download_file(
   p_filename => l_row.file_name,
   p_blob => l_row.file_content);
  --   and file_name = 'readme.txt';
  --
  -- oos_util_apex.download_file(
  --   p_filename => l_row.file_name,
  --   p_clob => oos_util_lob.blob2clob(l_row.file_content));
end;
