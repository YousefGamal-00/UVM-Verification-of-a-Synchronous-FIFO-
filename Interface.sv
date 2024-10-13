interface FIFO_if (clk) ;

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
    
input bit clk ; 
logic rst_n; 
logic wr_en; 
logic rd_en;
logic wr_ack; 
logic full;
logic empty;
logic overflow;
logic underflow;
logic almostfull; 
logic almostempty;
logic [FIFO_WIDTH-1:0] data_in;
logic [FIFO_WIDTH-1:0] data_out;  

endinterface