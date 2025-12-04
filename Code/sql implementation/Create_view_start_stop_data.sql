CREATE  VIEW view_start_stop_data AS
WITH ordered AS (
    SELECT
        production_line_id,
        status,
        "timestamp",
        ROW_NUMBER() OVER (
            PARTITION BY production_line_id
            ORDER BY "timestamp"
        ) AS row_ordering
    FROM tb_stg_rawdata_sql_ordered_reduced
),
paired AS (
    SELECT
        s.production_line_id,
        s."timestamp" AS start_time,
        e."timestamp" AS stop_time
    FROM ordered s
    JOIN ordered e
      ON s.production_line_id = e.production_line_id
     AND e.row_ordering = s.row_ordering + 1
     AND s.status = 'START'
     AND e.status = 'STOP'
)
SELECT
    production_line_id,
    start_time,
    stop_time,
	stop_time - start_time AS duration 
FROM paired
ORDER BY production_line_id, start_time;