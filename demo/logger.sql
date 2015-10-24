select *
from logger_prefs
where pref_name = 'LEVEL'
;

begin
  logger.log('run in debug mode');
end;
/

select *
from logger_logs_5_min
where 1=1
order by 1 desc;

-- Run in a different session to show it's session independant
begin
  -- Log only errors
  logger.set_level(p_level => logger.g_error);
end;
/



begin
  logger.log('Log: Will not be saved');
  logger.log_error('Error: Will be saved');
end;
/


select *
from logger_logs_5_min
where 1=1
order by 1 desc;







-- Reset
begin
  logger.set_level(p_level => logger.g_debug);
end;
/






begin
  logger.log('Saves even when a rollback occurs');

  rollback;
end;
/

select *
from logger_logs_5_min
where 1=1
order by 1 desc;


-- APEX
begin
  logger.log_apex_items('Log APEX items');
end;


/


select *
from logger_logs_5_min
where 1=1
order by 1 desc;


select *
from logger_logs_apex_items
where log_id = 37;






-- Enable for an specific APEX Session Only


-- Set level to Error for everyone
begin
  logger.set_level(p_level => logger.g_error);
  
  delete from logger_logs;
  commit;
end;
/



begin
  logger.log('should not log');
end;
/


select *
from logger_logs_5_min
where 1=1
order by 1 desc;


-- Turn on for APEX session
-- Notice I can enable in an entirely different Oracle session
begin
  logger.set_level(logger.g_debug, 'GIFFY:9333669080112');
end;
/


select *
from logger_logs_5_min
where 1=1
order by 1 desc;

