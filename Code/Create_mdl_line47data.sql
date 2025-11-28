CREATE TABLE tb_mdl_line47data (
	    production_line_id VARCHAR(8) NOT NULL,   
        start_time TIMESTAMP NOT NULL,
        stop_time TIMESTAMP NOT NULL,
		duration INTERVAL NOT NULL,
		CONSTRAINT line_time47 PRIMARY KEY (production_line_id,start_time)
    
);