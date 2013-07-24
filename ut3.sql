
select
restore_id,
site,
processed_by,
Coalesce(restore_types.name, 'yanni') as restore_type,
machine_id,
num_files,
missed, "rate %",
finish_time from(
SELECT
id as restore_id,
processed_by,
restore_type_id as type,
machine_id, site,
num_files,
(num_files- coalesce(coalesce(num_files_complete,0),0)) as missed,
round(1.0*(num_files- coalesce(coalesce(num_files_complete,0),0))*100/num_files,2) as "rate %",
finish_time from restores
where
(restore_type_id is null or
restore_type_id = 3 or restore_type_id = 4) and
num_files > 0 and
finish_time > now() - interval '1 days'
and (1.0 *(num_files-coalesce(num_files_complete,0))/ num_files > 0.05)
and is_ready = true order by finish_time desc) as t2
left join restore_types on t2.type =  restore_types.id
order by site, processed_by
;



select
sum( case when ddd.num_files =  ddd.completed_files then 1 else 0 end ) as "Number",
cast
(round(
100*1.0* sum( case when ddd.num_files =  ddd.completed_files then 1 else 0 end )/count(*)
, 3)
as char (6)) ||'%' as  "Percentage"
,
sum( case when  (ddd.num_files > ddd.completed_files)and (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files <0.05  then 1 else 0 end ) as "Number",
cast
( round(
100*1.0* sum( case when (ddd.num_files >  ddd.completed_files)and (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files <0.05 then 1 else 0 end )/count(*)
 , 3)
as char (6)) ||'%' as  "Percentage"
 ,
sum( case when (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files >=0.05  then 1 else 0 end ) as "Number",
 cast
(100  -  round(
100*1.0* sum( case when ddd.num_files =  ddd.completed_files then 1 else 0 end )/count(*)
 , 3)  -   round(
100*1.0* sum( case when (ddd.num_files >  ddd.completed_files)and (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files <0.05 then 1 else 0 end )/count(*)
 , 3)
 as char (6)) ||'%' as  "Percentage" ,
count(*) as "Total restore request"
from
(select site,   (case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files from
restores where finish_time > now() - interval '1 days'
and
num_files > 0
and (restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4) 
and restores.is_ready = true ) as ddd;

select
sum( case when ddd.num_files =  ddd.completed_files then 1 else 0 end ) as "Number",
cast
( round(
100*1.0* sum( case when ddd.num_files =  ddd.completed_files then 1 else 0 end )/count(*)
 , 3) as char (6)) ||'%' as  "Percentage" ,
sum( case when  (ddd.num_files >  ddd.completed_files) and (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files <0.05  then 1 else 0 end ) as "Number",
cast
( round(
100*1.0* sum( case when (ddd.num_files >  ddd.completed_files)and (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files <0.05 then 1 else 0 end )/count(*)
 , 3) as char (6)) ||'%' as  "Percentage"
 ,
sum( case when (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files >=0.05  then 1 else 0 end ) as "Number",
 cast
(100  -  round(
100*1.0* sum( case when ddd.num_files =  ddd.completed_files then 1 else 0 end )/count(*)
 , 3)  - round(
100*1.0* sum( case when (ddd.num_files >  ddd.completed_files)and (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files <0.05 then 1 else 0 end )/count(*)
 , 3)
 as char (6)) ||'%' as  "Percentage" ,
count(*) as "Total restore request"
from
(select 
site,   
(case when  coalesce(num_files,0) >  coalesce(num_files_complete,0)  then coalesce(num_files_complete,0) else coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files from
restores where finish_time > now() - interval '7 days'
and
num_files > 0
and (restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4  )  and restores.is_ready = true ) as ddd;



select
sum( case when ddd.num_files =  ddd.completed_files then 1 else 0 end ) as "Number",
cast
( round(
100*1.0* sum( case when ddd.num_files =  ddd.completed_files then 1 else 0 end )/count(*)
 , 3)
as char (6)) ||'%' as  "Percentage"
 ,
sum( case when  (ddd.num_files >  ddd.completed_files)and (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files <0.05  then 1 else 0 end ) as "Number",
cast
( round(
100*1.0* sum( case when (ddd.num_files >  ddd.completed_files)and (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files <0.05 then 1 else 0 end )/count(*)
 , 3)
as char (6)) ||'%' as  "Percentage"
 ,
sum( case when (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files >=0.05  then 1 else 0 end ) as "Number",
 cast
(100  -  round(
100*1.0* sum( case when ddd.num_files =  ddd.completed_files then 1 else 0 end )/count(*)
 , 3)  -   round(
100*1.0* sum( case when (ddd.num_files >  ddd.completed_files)and (ddd.num_files -  ddd.completed_files)*1.0/ddd.num_files <0.05 then 1 else 0 end )/count(*)
 , 3)
 as char (6)) ||'%' as  "Percentage" ,
count(*) as "Total restore request"
from
(select site,   (case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files from
restores where finish_time > now() - interval '30 days'
and
num_files > 0
and (restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4  )  and restores.is_ready = true ) as ddd;


select
sum(ddd.completed_files) as "Number",
cast
( round(
100*1.0* sum(ddd.completed_files  )/ sum(ddd.num_files)
 , 3)
as char (6)) ||'%' as  "Percentage"
 ,
sum(num_files) - sum(ddd.completed_files)    as "Number",
cast
( round(
100 - 100*1.0* sum(ddd.completed_files  )/ sum(ddd.num_files)
 , 3)
as char (6)) ||'%' as  "Percentage"
,
sum(ddd.num_files) as "Number"
from
(select 
site,   
(case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,
coalesce(num_files,0) as num_files from
restores where
num_files > 0 and
finish_time > now() - interval '1 days' 
and (restore_type_id  is null 
or (restore_type_id = 3)  or restore_type_id = 4  )  and restores.is_ready = true ) as ddd;


select
sum(ddd.completed_files) as "Number",
cast
( round(
100*1.0* sum(ddd.completed_files  )/ sum(ddd.num_files)
 , 3)
as char (6)) ||'%' as  "Percentage"
 ,
sum(num_files) - sum(ddd.completed_files)    as "Number",
cast
( round(
100 - 100*1.0* sum(ddd.completed_files  )/ sum(ddd.num_files)
 , 3)
as char (6)) ||'%' as  "Percentage"
,
sum(ddd.num_files) as "Number"
from
(select site,   (case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files from
restores where
num_files > 0 and
finish_time > now() - interval '7 days'        and (restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4  )  and restores.is_ready = true ) as ddd;




select
sum(ddd.completed_files) as "Number",
cast
( round(
100*1.0* sum(ddd.completed_files  )/ sum(ddd.num_files)
 , 3)
as char (6)) ||'%' as  "Percentage"
 ,

 sum(num_files) - sum(ddd.completed_files)    as "Number",
cast
( round(
100 - 100*1.0* sum(ddd.completed_files  )/ sum(ddd.num_files)
 , 3)
as char (6)) ||'%' as  "Percentage"
,
sum(ddd.num_files) as "Number"
from
(select site,   (case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files from
restores where

num_files > 0 and
finish_time > now() - interval '30 days'        and (restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4  )  and restores.is_ready = true ) as ddd;





select
restore_id,
Coalesce(restore_types.name, 'yanni') as restore_type,
machine_id,
num_files as "request file number",
missed as "failed file number", "rate %" as "failed file rate",
finish_time as "timestamp" from(
SELECT
id as restore_id,
processed_by,
restore_type_id as type,
machine_id, site,
num_files ,
(num_files- coalesce(coalesce(num_files_complete,0),0)) as missed,
cast(round(1.0*(num_files- coalesce(coalesce(num_files_complete,0),0))*100/num_files,3) as char(6))||'%' as "rate %",
finish_time from restores
where
(restore_type_id is null or
restore_type_id = 3 or restore_type_id = 4) and
finish_time > now() - interval '1 days'
and
num_files > 0
and (1.0 *(num_files-coalesce(num_files_complete,0))/ num_files > 0.05)
and is_ready = true order by id desc) as t2
left join restore_types on t2.type =  restore_types.id order by restore_id desc ;








select
coalesce(restore_types.name, 'yanni') as restore_type,


count(*) as "restores",
sum( case when ddd.completed_files = ddd.num_files then 1 else 0 end ) as "Perfect Restores",



cast
(round(

100*1.0*sum( case when ddd.completed_files < ddd.num_files then 1 else 0 end ) / count(*)
,3)
 as char (6)) || '%'

as "% of Restores with missing files",







sum(ddd.num_files)  as "Sum Request files",
 sum(ddd.completed_files)  as "sum_completefiles",
sum(ddd.num_files)  - sum(ddd.completed_files)    as "sum_failedfiles",
cast
(round(

100 *1.0* (sum(ddd.num_files)  - sum(ddd.completed_files) ) / sum(ddd.num_files)
,3)
 as char (6)) || '%'     as  "Failed file Rate"

from
(select restore_type_id, site,   (case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files from
restores where

num_files > 0 and
finish_time > now() - interval '1 days'        and (restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4  )  and restores.is_ready = true ) as ddd
left join
restore_types
on ddd.restore_type_id =  restore_types.id
group by restore_types.name;






select
site,
count(*) as "restores",
sum( case when ddd.completed_files = ddd.num_files then 1 else 0 end ) as "Perfect Restores",

cast
(round(

100*1.0*sum( case when ddd.completed_files < ddd.num_files then 1 else 0 end ) / count(*)
,3)
 as char (6)) || '%'

as "% of Restores with missing files",

sum(ddd.num_files)  as "Sum Request files",
 sum(ddd.completed_files)  as "sum_completefiles",
sum(ddd.num_files)  - sum(ddd.completed_files)    as "sum_failedfiles",
cast
(round(

100 *1.0* (sum(ddd.num_files)  - sum(ddd.completed_files) ) / sum(ddd.num_files)
,3)
 as char (6)) || '%'     as  "Failed file Rate"

from
(select restore_type_id, site,   (case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files from
restores where


num_files > 0 and
finish_time > now() - interval '1 days'        and (restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4  )  and restores.is_ready = true ) as ddd
group by site;






select
coalesce(restore_types.name, 'yanni') as restore_type,


count(*) as "restores",
sum( case when ddd.completed_files = ddd.num_files then 1 else 0 end ) as "Perfect Restores",



cast
(round(

100*1.0*sum( case when ddd.completed_files < ddd.num_files then 1 else 0 end ) / count(*)
,3)
 as char (6)) || '%'

as "% of Restores with missing files",







sum(ddd.num_files)  as "Sum Request files",
 sum(ddd.completed_files)  as "sum_completefiles",
sum(ddd.num_files)  - sum(ddd.completed_files)    as "sum_failedfiles",
cast
(round(

100 *1.0* (sum(ddd.num_files)  - sum(ddd.completed_files) ) / sum(ddd.num_files)
,3)
 as char (6)) || '%'     as  "Failed file Rate"

from
(select restore_type_id, site,   (case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files from
restores where

num_files > 0 and

finish_time > now() - interval '7 days'        and (restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4  )  and restores.is_ready = true ) as ddd
left join
restore_types
on ddd.restore_type_id =  restore_types.id
group by restore_types.name;






select
site,
count(*) as "restores",
sum( case when ddd.completed_files = ddd.num_files then 1 else 0 end ) as "Perfect Restores",

cast
(round(

100*1.0*sum( case when ddd.completed_files < ddd.num_files then 1 else 0 end ) / count(*)
,3)
 as char (6)) || '%'

as "% of Restores with missing files",

sum(ddd.num_files)  as "Sum Request files",
 sum(ddd.completed_files)  as "sum_completefiles",
sum(ddd.num_files)  - sum(ddd.completed_files)    as "sum_failedfiles",
cast
(round(

100 *1.0* (sum(ddd.num_files)  - sum(ddd.completed_files) ) / sum(ddd.num_files)
,3)
 as char (6)) || '%' as "Failed file Rate"

from
(select restore_type_id, site,   (case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files from
restores where

num_files > 0 and
finish_time > now() - interval '7 days' and 
(restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4)  
and restores.is_ready = true ) as ddd
group by site;





