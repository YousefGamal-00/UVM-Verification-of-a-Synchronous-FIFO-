package seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_seq_item extends uvm_sequence_item ;
    `uvm_object_utils(FIFO_seq_item)

localparam FIFO_DEPTH = 8 ;
localparam FIFO_WIDTH = 16 ;
rand bit  rst_n, wr_en, rd_en ;
rand bit [FIFO_WIDTH-1:0] data_in;

logic  [FIFO_WIDTH-1:0] data_out;
logic  wr_ack, overflow;
logic  full, empty, almostfull, almostempty, underflow;

int RD_EN_ON_DIST = 0 ;
int WR_EN_ON_DIST = 0 ;

        function void rand_value ( int RD_EN_ON_DIST = 30 , int WR_EN_ON_DIST = 70 ) ;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST ;    
            this.RD_EN_ON_DIST = RD_EN_ON_DIST ;    
        endfunction
        
        function new(string name = "FIFO_seq_item");
            super.new(name);            
        endfunction 

        function string convert2string( );
                return $sformatf("%s , rst_n: %0b , wr_en: %0b , rd_en: %0b , data_in: %0d , data_out: %0d , full: %0b , almostfull: %0b , empty: %0b , almostempty: %0b , overflow: %0b , underflow: %0b , wr_ack: %0b",
                                super.convert2string() , rst_n , wr_en , rd_en , data_in , data_out , full , almostfull , empty , almostempty , overflow , underflow , wr_ack );
        endfunction

        function string convert2string_stimulus( );
            return $sformatf("rst_n: %0b , wr_en: %0b , rd_en: %0b , data_in: %0d", rst_n , wr_en , rd_en , data_in);
        endfunction

        /*-------------------- Constraints -------------------------*/
        constraint rst_cons   { rst_n dist {0:/5 , 1:/95 } ;}
        constraint WR_EN_cons { wr_en dist {0:/(100-WR_EN_ON_DIST) , 1:/WR_EN_ON_DIST } ;}
        constraint RD_EN_cons { rd_en dist {0:/(100-RD_EN_ON_DIST) , 1:/RD_EN_ON_DIST } ;}
        constraint write_only { rd_en == 0 ; wr_en == 1 ;}
        constraint read_only  { rd_en == 1 ; wr_en == 0 ;}

endclass 

endpackage