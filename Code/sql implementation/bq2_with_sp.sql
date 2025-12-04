WITH events AS (
    SELECT production_line_id, start_time AS timestamp, 1 AS score
    FROM tb_mdl_linedata
    UNION ALL
    SELECT production_line_id, stop_time AS timestamp, -1 AS score
    FROM tb_mdl_linedata
), -- +1 -1 in events as discussed
ordered_events AS (
    SELECT *
    FROM events
    ORDER BY timestamp
), -- ordering 
running AS (
    SELECT
        timestamp,
        SUM(score) OVER (ORDER BY timestamp) AS running_total
    FROM ordered_events
), --cumsum in scores to flag running machines
intervals AS (
	SELECT
   		timestamp AS interval_start ,
    	LEAD(timestamp) OVER (ORDER BY timestamp) AS interval_end,
		running_total
FROM running
ORDER BY timestamp
) -- shift -1 to create time interval 

--select and sum only the rows-time intervals with 4 running machines
SELECT  SUM( interval_end - interval_start) as UPTIME,

    INTERVAL '5 hours' - SUM(interval_end- interval_start) AS DOWNTIME
	from intervals
	where running_total=4