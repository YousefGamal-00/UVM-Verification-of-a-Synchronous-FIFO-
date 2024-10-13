package monitor_pkg ;

    import uvm_pkg::*;
    import seq_item_pkg::*;
    `include "uvm_macros.svh"

class FIFO_monitor extends uvm_monitor  ;
`uvm_component_utils(FIFO_monitor)

virtual FIFO_if FIFOif ;
FIFO_seq_item seq_item ;
uvm_analysis_port #(FIFO_seq_item) monitor_aport ;

function new(string name = "FIFO_monitor" , uvm_component parent = null);
        super.new(name , parent);
endfunction

function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        monitor_aport = new("monitor_aport" , this);
endfunction

task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever 
        begin
            seq_item = FIFO_seq_item::type_id::create("seq_item" , this);
            @(negedge FIFOif.clk);
            seq_item.rst_n        = FIFOif.rst_n        ;
            seq_item.wr_en        = FIFOif.wr_en        ;
            seq_item.rd_en        = FIFOif.rd_en        ;
            seq_item.full         = FIFOif.full         ;
            seq_item.empty        = FIFOif.empty        ;
            seq_item.wr_ack       = FIFOif.wr_ack       ;
            seq_item.data_in      = FIFOif.data_in      ;
            seq_item.data_out     = FIFOif.data_out     ;
            seq_item.overflow     = FIFOif.overflow     ;
            seq_item.underflow    = FIFOif.underflow    ;
            seq_item.almostfull   = FIFOif.almostfull   ;
            seq_item.almostempty  = FIFOif.almostempty  ;
            monitor_aport.write(seq_item); /* broadcast the seq_item to analysis component */
        end
endtask

endclass
endpackage