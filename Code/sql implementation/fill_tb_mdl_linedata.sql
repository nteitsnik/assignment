INSERT INTO public.tb_mdl_linedata
    (production_line_id, start_time, stop_time, duration)
SELECT
    production_line_id,
    start_time,
    stop_time,
    duration
FROM public.vieww_start_stop_data ;