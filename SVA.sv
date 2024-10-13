module SVA #(parameter FIFO_WIDTH = 16 , FIFO_DEPTH = 8 )
( 
   input logic clk,
   input logic rst_n, 
   input logic wr_en, 
   input logic rd_en,
   input logic wr_ack, 
   input logic full,
   input logic empty,
   input logic overflow,
   input logic underflow,
   input logic almostfull, 
   input logic almostempty,
   input logic [2:0]wr_ptr, 
   input logic [2:0]rd_ptr, 
   input logic [FIFO_WIDTH-1:0] data_in,
   input logic [FIFO_WIDTH-1:0] data_out, 
   input logic [$clog2(FIFO_DEPTH) : 0] count

);


always_comb 
begin
if( !rst_n )
begin
	assert_reset_falgs:  assert final ( !full && empty && !almostempty && !almostfull  ) ;
	cover_reset_falgs :  cover  ( !full && empty && !almostempty && !almostfull  ) ;
end
else 
begin
		if( count == 0 )
		begin
			assert_empty: assert (!full && empty && !almostempty && !almostfull ) ; 
			cover_empty : cover  (!full && empty && !almostempty && !almostfull ) ; 			
		end

		else if( count == FIFO_DEPTH )
		begin
			assert_full: assert (full && !empty && !almostempty && !almostfull ) ; 
			cover_full : cover  (full && !empty && !almostempty && !almostfull) ; 			
		end

		else if( count == (FIFO_DEPTH - 1'b1) )
		begin
			assert_almostfull: assert (!full && !empty && !almostempty && almostfull) ; 
			cover_almostfull : cover  (!full && !empty && !almostempty && almostfull) ; 
		end

		else if( count == 1'b1 )
		begin
			assert_almostempty: assert (!full && !empty && almostempty && !almostfull) ; 
			cover_almostempty : cover  (!full && !empty && almostempty && !almostfull) ; 
		end
end
end

property RD_ptr;
	@(posedge clk) disable iff(!rst_n) (rd_en && (count != 0) && rd_ptr < 7 ) |=> ( (rd_ptr == ($past(rd_ptr) + 1)) % FIFO_DEPTH );
endproperty

property WR_ptr;
	@(posedge clk) disable iff(!rst_n) (wr_en && (count < FIFO_DEPTH) && wr_ptr < 7) |=> ((wr_ptr == ($past(wr_ptr) + 1)) % FIFO_DEPTH);
endproperty

property prop_overflow ;
	@(posedge clk) disable iff (!rst_n) (wr_en && full) |=> (overflow) ;
endproperty

property prop_underflow ;
	@(posedge clk) disable iff (!rst_n) (rd_en && empty) |=> (underflow) ;
endproperty

property wr_ack_1 ;
	@(posedge clk) disable iff (!rst_n) (wr_en && ! full) |=> (wr_ack) ;
endproperty

property wr_ack_0 ;
	@(posedge clk) disable iff (!rst_n) (wr_en && full) |=> (!wr_ack) ;
endproperty

RD_PTR_assert : assert property (RD_ptr);
RD_PTR_cover  : cover  property (RD_ptr);

WR_PTR_assert : assert property (WR_ptr);
WR_PTR_cover  : cover  property (WR_ptr);


assert_overflow : assert property (prop_overflow) ; 
cover_overflow  : cover  property (prop_overflow) ; 

assert_underflow : assert property (prop_underflow) ; 
cover_underflow  : cover  property (prop_underflow) ; 

assert_wr_ack_1 : assert property (wr_ack_1) ; 
cover_wr_ack_1  : cover  property (wr_ack_1) ; 

assert_wr_ack_0 : assert property (wr_ack_0) ; 
cover_wr_ack_0  : cover  property (wr_ack_0) ; 

endmodule