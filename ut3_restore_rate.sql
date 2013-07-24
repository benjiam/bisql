select
sum(ddd.completed_files) as "Number",
round(
100*1.0* sum(ddd.completed_files  )/ sum(ddd.num_files)
 , 3)
 as  "Percentage",
sum(num_files) - sum(ddd.completed_files)    as "Number",
round(
100 - 100*1.0* sum(ddd.completed_files  )/ sum(ddd.num_files)
 , 3) as  "Percentage",
sum(ddd.num_files) as "Number" ,dates
from
(select site,   (case when  coalesce(num_files,0) >  coalesce(num_files_complete,0) then   coalesce(num_files_complete,0) else  coalesce(num_files,0)  end   ) as completed_files,  coalesce(num_files,0) as num_files, date(finish_time) as dates from
restores where finish_time > now() - interval '40 days'        and (restore_type_id  is null or (restore_type_id = 3)  or restore_type_id = 4  )  and restores.is_ready = true ) as ddd
group by dates
order by dates asc;


