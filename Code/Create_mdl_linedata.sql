CREATE TABLE tb_mdl_linedata (
	    production_line_id VARCHAR(8) NOT NULL,   
        start_time TIMESTAMP NOT NULL,
        stop_time TIMESTAMP NOT NULL,
		duration INTERVAL NOT NULL,
		CONSTRAINT line_time PRIMARY KEY (production_line_id,start_time)
    
);