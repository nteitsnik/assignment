



UPDATE public.tb_stg_rawdata p
SET status = 'START'
FROM (
    SELECT production_line_id,timestamp,
           ROW_NUMBER() OVER (
               PARTITION BY production_line_id
               ORDER BY timestamp
           ) AS rn
    FROM public.tb_stg_rawdata
) x
WHERE p.production_line_id = x.production_line_id and p.timestamp = x.timestamp
  AND x.rn = 1;	

UPDATE public.tb_stg_rawdata p
SET status = 'STOP'
FROM (
    SELECT production_line_id,timestamp,
           ROW_NUMBER() OVER (
               PARTITION BY production_line_id
               ORDER BY timestamp Desc
           ) AS rn
    FROM public.tb_stg_rawdata
) x
WHERE p.production_line_id = x.production_line_id and p.timestamp = x.timestamp
  AND x.rn = 1;	
  