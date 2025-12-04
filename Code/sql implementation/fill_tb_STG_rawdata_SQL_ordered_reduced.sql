
INSERT INTO tb_STG_rawdata_SQL_ordered_reduced
    (production_line_id, status, "timestamp")
SELECT 
    t.production_line_id, 
    t.status, 
    t."timestamp"
FROM (
    SELECT 
        production_line_id, 
        status, 
        "timestamp"
    FROM public.tb_stg_rawdata
    WHERE status IN ('START', 'STOP')
    ORDER BY production_line_id, "timestamp"
) AS t;