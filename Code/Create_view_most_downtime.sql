
Create View VIEW_most_downtime as 
select production_line_id, (INTERVAL '05:00:00' - A.duration)  as downtime
from (
select production_line_id , sum(duration) as duration 
from tb_mdl_linedata
group by production_line_id
order by sum(duration) 
limit 1)
as A