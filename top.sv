import uvm_pkg::*;
import test_pkg::*;
`include "uvm_macros.svh"

module top ();
    bit clk; // Clock signal

    // Initial block to generate the clock signal
    initial 
    begin
        clk = 0; // Initialize clock to 0
        forever #1 clk = ~clk; // Toggle clock every 1 time unit
    end

    // Instantiate the FIFO interface
    FIFO_if FIFOif (clk);

    // Instantiate the FIFO design under test (DUT)
    FIFO DUT (
                .clk         (  clk              ),
                .rst_n       (FIFOif.rst_n       ),        
                .wr_en       (FIFOif.wr_en       ),        
                .rd_en       (FIFOif.rd_en       ),        
                .full        (FIFOif.full        ),        
                .empty       (FIFOif.empty       ),        
                .wr_ack      (FIFOif.wr_ack      ),        
                .data_in     (FIFOif.data_in     ),        
                .data_out    (FIFOif.data_out    ),        
                .overflow    (FIFOif.overflow    ),        
                .underflow   (FIFOif.underflow   ),        
                .almostfull  (FIFOif.almostfull  ),        
                .almostempty (FIFOif.almostempty )       
             );

    bind FIFO SVA SVA_inst  (
                                .clk         (  clk               ),
                                .rst_n       (FIFOif.rst_n        ),        
                                .wr_en       (FIFOif.wr_en        ),        
                                .rd_en       (FIFOif.rd_en        ),                                     
                                .full        (FIFOif.full         ),        
                                .empty       (FIFOif.empty        ),        
                                .wr_ack      (FIFOif.wr_ack       ),        
                                .data_in     (FIFOif.data_in      ),        
                                .data_out    (FIFOif.data_out     ),        
                                .overflow    (FIFOif.overflow     ),        
                                .underflow   (FIFOif.underflow    ),        
                                .almostfull  (FIFOif.almostfull   ),        
                                .almostempty (FIFOif.almostempty  ),
                                .count       (DUT.count           ),     
                                .wr_ptr      (DUT.wr_ptr          ),        
                                .rd_ptr      (DUT.rd_ptr          )        
                            ); 
    initial 
    begin
        uvm_config_db #(virtual FIFO_if)::set(null , "uvm_test_top" , "FIFOif" , FIFOif);
        run_test("FIFO_test");
    end
    
endmodule


