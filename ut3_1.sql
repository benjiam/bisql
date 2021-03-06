

# 遍历所有错误的restore

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
restore_type_id = 3 ) and
finish_time > now() - interval '1 days'
and (1.0 *(num_files-coalesce(num_files_complete,0))/ num_files > 0.05)
and is_ready = true order by finish_time desc) as t2
left join restore_types on t2.type =  restore_types.id;






#past 24

# request 分类情况检索

select
sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end) as "A",
cast (round(100 *1.0*(sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end))/ count(*), 2)
as char(5) ) || '%' as  "prefect rate %",
sum(case when num_files- coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete, 0))/num_files <=0.05  then 1 else 0 end) as "B",
cast (round(100 *1.0*(sum(case when num_files- coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete,0))/num_files <=0.05  then 1 else 0 end))/ count(*), 2) as char(5)) || '%' as  "imperfect rate %",

sum(case when num_files - coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete,0))/num_files >0.05  then 1 else 0 end) as  "C",
cast( round(100 *1.0*(sum(case when num_files - coalesce(num_files_complete,0) > 0 and (1.0*(num_files - coalesce(num_files_complete,0))/num_files >0.05)  then 1 else 0 end))/ count(*), 2) as char (5)) ||'%' as  "failed restore rate %",
count(*) as restores
from restores
where
is_ready = true and
restores.finish_time > now() - interval '1 days'
and (restore_type_id is null or restore_type_id = 3 )
group by coalesce(restore_type_id,0)*0;



# 按下载文件分类

select


sum(coalesce(num_files_complete,0)) as "B",
cast(round(100 *1.0*(sum(coalesce(num_files_complete,0)))/sum(num_files),2) as char(5)) || '%' as "file success rate %",
sum(num_files) - sum(coalesce(num_files_complete,0)) as "C",
cast (round(100 *1.0*(  sum(num_files) -  sum(coalesce(num_files_complete,0)))/sum(num_files),2) as char (5) ) || '%' as "failed rate %",
sum(num_files)  as "A"
from restores
where
is_ready = true and
restores.finish_time > now() - interval '1 days'
and (restore_type_id is null or restore_type_id = 3 )
group by coalesce(restore_type_id,0)*0;


#past 7 days




# request 分类情况检索

select
sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end) as "A",
cast (round(100 *1.0*(sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end))/ count(*), 2)
as char(5) ) || '%' as  "prefect rate %",
sum(case when num_files- coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete, 0))/num_files <=0.05  then 1 else 0 end) as "B",
cast (round(100 *1.0*(sum(case when num_files- coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete,0))/num_files <=0.05  then 1 else 0 end))/ count(*), 2) as char(5)) || '%' as  "imperfect rate %",

sum(case when num_files - coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete,0))/num_files >0.05  then 1 else 0 end) as  "C",
cast( round(100 *1.0*(sum(case when num_files - coalesce(num_files_complete,0) > 0 and (1.0*(num_files - coalesce(num_files_complete,0))/num_files >0.05)  then 1 else 0 end))/ count(*), 2) as char (5)) ||'%' as  "failed restore rate %",
count(*) as restores
from restores
where
is_ready = true and
restores.finish_time > now() - interval '7 days'
and (restore_type_id is null or restore_type_id = 3 )
group by coalesce(restore_type_id,0)*0;



# 按下载文件分类

select

sum(coalesce(num_files_complete,0)) as "B",
cast(round(100 *1.0*(sum(coalesce(num_files_complete,0)))/sum(num_files),2) as char(5)) || '%' as "file success rate %",
sum(num_files) - sum(coalesce(num_files_complete,0)) as "C",
cast (round(100 *1.0*(  sum(num_files) -  sum(coalesce(num_files_complete,0)))/sum(num_files),2) as char (5) ) || '%' as "failed rate %",
sum(num_files)  as "A"
from restores
where
is_ready = true and
restores.finish_time > now() - interval '7 days'
and (restore_type_id is null or restore_type_id = 3 )
group by coalesce(restore_type_id,0)*0;



#past 30 days




# request 分类情况检索

select
sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end) as "A",
cast (round(100 *1.0*(sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end))/ count(*), 2)
as char(5) ) || '%' as  "prefect rate %",
sum(case when num_files- coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete, 0))/num_files <=0.05  then 1 else 0 end) as "B",
cast (round(100 *1.0*(sum(case when num_files- coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete,0))/num_files <=0.05  then 1 else 0 end))/ count(*), 2) as char(5)) || '%' as  "imperfect rate %",

sum(case when num_files - coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete,0))/num_files >0.05  then 1 else 0 end) as  "C",
cast( round(100 *1.0*(sum(case when num_files - coalesce(num_files_complete,0) > 0 and (1.0*(num_files - coalesce(num_files_complete,0))/num_files >0.05)  then 1 else 0 end))/ count(*), 2) as char (5)) ||'%' as  "failed restore rate %",
count(*) as restores
from restores
where
is_ready = true and
restores.finish_time > now() - interval '30 days'
and (restore_type_id is null or restore_type_id = 3 )
group by coalesce(restore_type_id,0)*0;



# 按下载文件分类

select

sum(coalesce(num_files_complete,0)) as "B",
cast(round(100 *1.0*(sum(coalesce(num_files_complete,0)))/sum(num_files),2) as char(5)) || '%' as "file success rate %",
sum(num_files) - sum(coalesce(num_files_complete,0)) as "C",
cast (round(100 *1.0*(  sum(num_files) -  sum(coalesce(num_files_complete,0)))/sum(num_files),2) as char (5) ) || '%' as "failed rate %",
sum(num_files)  as "A"
from restores
where
is_ready = true and
restores.finish_time > now() - interval '30 days'
and (restore_type_id is null or restore_type_id = 3 )
group by coalesce(restore_type_id,0)*0;




# 测试保留

select
restores,
"prefect rate %",
"imperfect rate %" as "imprefect restore (file success rate < 5%) %",
"failed restore rate %",
"file success rate %" from (
select
count(*) as restores,
sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end) as perfect_restores,
sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end) as  "A",
sum(case when num_files- coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete,0))/num_files <=0.05  then 1 else 0 end)as  "B",
sum(case when num_files - coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete,0))/num_files >0.05  then 1 else 0 end) as  "C",
round(100 *1.0*(sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end))/ count(*), 2) as  "prefect rate %",
round(100 *1.0*(sum(case when num_files- coalesce(num_files_complete,0) > 0 and 1.0*(num_files - coalesce(num_files_complete,0))/num_files <=0.05  then 1 else 0 end))/ count(*), 2) as  "imperfect rate %",
round(100 *1.0*(sum(case when num_files - coalesce(num_files_complete,0) > 0 and (1.0*(num_files - coalesce(num_files_complete,0))/num_files >0.05)  then 1 else 0 end))/ count(*), 2) as  "failed restore rate %",
sum(num_files) as sum_requestfiles,
sum(coalesce(num_files_complete,0)) as sum_completefiles,
sum(num_files) - sum(coalesce(num_files_complete,0)) as sum_failedfiles,
round(100 *1.0*(sum(coalesce(num_files_complete,0)))/sum(num_files),2) as "file success rate %"  from restores
where
is_ready = true and
restores.finish_time > now() - interval '1 days'
and (restore_type_id is null or restore_type_id = 3 )
group by coalesce(restore_type_id,0)*0
)



#select id,is_ready, num_files, num_files_complete from restores where  1.0*(num_files - coalesce(num_files_complete,0))/num_files >0.05 and
#restores.finish_time > now() - interval '1 days' and
#(restore_type_id is null or restore_type_id = 3

Restore status





Failed Restore Report:

select
restore_id,
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
restore_type_id = 3 ) and
finish_time > now() - interval '1 days'
and (1.0 *(num_files-coalesce(num_files_complete,0))/ num_files > 0.05)
and is_ready = true order by finish_time desc) as t2
left join restore_types on t2.type =  restore_types.id;


Restore Failure Analysis

Restore  1773600
Root cause:
Trogdor can’t get the manifest, related to ticket #99267 about TMS failover.
https://redmine.mozycorp.com/issues/98426




Restore Report from past 24 hours:

select
coalesce(restore_types.name, 'yanni') as restore_type,
restores,
perfect_restores,
"restores_with_at_missing_files %" as "% of restores with missing files",
sum_requestfiles,
sum_failedfiles,
"failedrate %"
from (

select
restore_type_id,
count(*) as restores,
sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end) as perfect_restores,
round(100 *1.0*(count(*) - sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end))/ count(*), 2) as  "restores_with_at_missing_files %",
sum(num_files) as sum_requestfiles,
sum(coalesce(num_files_complete,0)) as sum_completefiles,
sum(num_files) - sum(coalesce(num_files_complete,0)) as sum_failedfiles,
round(100 *1.0*(sum(num_files)- sum(coalesce(num_files_complete,0)))/sum(num_files),2) as "failedrate %"
from restores
where
is_ready = true and
restores.finish_time > now() - interval '1 days'
and (
restore_type_id  is null or
(restore_type_id != 1 and restore_type_id != 2))
group by restore_type_id
order by  restore_type_id)
as t2
left  join
restore_types
on t2.restore_type_id =  restore_types.id;





past 24 hours by site:

select
site as Site,
count(*) as Restores,
sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end) as Perfect_Restores,
round(100 * 1.0*(count(*) - sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end))/ count(*),2) as "% of Restores with missing files",
sum(num_files) as Sum_Requestfiles,
sum(coalesce(num_files_complete,0)) as Sum_CompleteFiles, sum(num_files) - sum(coalesce(num_files_complete,0)) as Sum_FailedFiles,
round(100 * 1.0*(sum(num_files)- sum(coalesce(num_files_complete,0)))/sum(num_files), 2) as "FailedRate %"
from restores, restore_types
where
restores.is_ready = true and
restores.restore_type_id = restore_types.id and
restores.finish_time > now() - interval '1 days' and
restore_types.id = 3
group by Site
order by  Site ;





Last 7 days restore report:

select
Coalesce(restore_types.name, 'yanni') as restore_type,
Restores,
Perfect_Restores,
"Restores_with_at_missing_files %" as "% of Restores with missing files",
Sum_Requestfiles,
Sum_FailedFiles,
"FailedRate %"
from (
select
restore_type_id,
count(*) as Restores,
sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end) as Perfect_Restores,
round( 100 * 1.0*(count(*) - sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end))/ count(*),2) as "Restores_with_at_missing_files %",
sum(num_files) as Sum_Requestfiles,
sum(coalesce(num_files_complete,0)) as Sum_CompleteFiles,
sum(num_files) - sum(coalesce(num_files_complete,0)) as Sum_FailedFiles,
round( 100 * 1.0*(sum(num_files)- sum(coalesce(num_files_complete,0)))/sum(num_files), 2)  as "FailedRate %"
from restores
where
restores.is_ready = true and
restores.finish_time > now() - interval '7 days' and
(restore_type_id  is null or
 (restore_type_id != 1 and restore_type_id != 2))
group by
restore_type_id
order by
restore_type_id ) as t2 left join restore_types
on t2.restore_type_id =  restore_types.id;




Last 7 days Neptune report:


select
site as Site,
count(*) as Restores,
sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end) as Perfect_Restores,
round(100 * 1.0*(count(*) - sum(case when num_files = coalesce(num_files_complete,0) then 1 else 0 end))/ count(*),2) as "% of Restores with missing files",
sum(num_files) as Sum_Requestfiles,
sum(coalesce(num_files_complete,0)) as Sum_CompleteFiles,
sum(num_files) - sum(coalesce(num_files_complete,0)) as Sum_FailedFiles,
round( 100 * 1.0*(sum(num_files)- sum(coalesce(num_files_complete,0)))/sum(num_files),2) as "FailedRate %"
from
restores, restore_types
where
restores.is_ready = true and
restores.restore_type_id = restore_types.id and
restores.finish_time > now() - interval '7 days' and
restore_types.id = 3
group by Site
order by  Site ;




