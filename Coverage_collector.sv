package cvg_pkg ;

    import uvm_pkg::*;
    import seq_item_pkg::*;
    `include "uvm_macros.svh"

class FIFO_cvg_collector extends uvm_component ;
`uvm_component_utils(FIFO_cvg_collector)

FIFO_seq_item seq_item ; 
uvm_analysis_export   #(FIFO_seq_item) cvg_export ;
uvm_tlm_analysis_fifo #(FIFO_seq_item) cvg_fifo   ;

covergroup  cvr_gp  ;

cross_coverage_almostfull  : cross  seq_item.wr_en, seq_item.rd_en, seq_item.almostfull  ;
cross_coverage_almostempty : cross  seq_item.wr_en, seq_item.rd_en, seq_item.almostempty ;
  
  /* whenever the RD_EN = 1 the full = 0 so we will ignore the bins of RD_EN = 1 and full = 1 */ 
cross_coverage_full        : cross  seq_item.wr_en, seq_item.rd_en, seq_item.full        ;

  /* whenever the WR_EN = 1 the empty = 0 so we will ignore the bins of WR_EN = 1 and empty = 1 */ 
cross_coverage_empty       : cross  seq_item.wr_en, seq_item.rd_en, seq_item.empty       ;

  /* whenever the WR_EN = 0 the WR_ACK = 0 so we will ignore the bins of wr_en = 0 and wr_ack = 1 */ 
cross_coverage_wr_ack      : cross  seq_item.wr_en, seq_item.rd_en, seq_item.wr_ack      ;

  /* whenever the WR_EN = 0 the overflow = 0 as we not intend to write so ignore the bins of wr_en = 0 and overflow = 1 */ 
cross_coverage_overflow    : cross  seq_item.wr_en, seq_item.rd_en, seq_item.overflow    ;   
  
  /* whenever the RD_EN = 0 the underflow = 0 as we not intend to read so ignore the bins of rd_en = 0 and underflow = 1 */ 
cross_coverage_underflow   : cross  seq_item.wr_en, seq_item.rd_en, seq_item.underflow   ;

endgroup

function new(string name = "FIFO_cvg_collector", uvm_component parent = null);
    super.new(name , parent);
    cvr_gp = new();
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cvg_fifo   = new("cvg_fifo"  , this);
    cvg_export = new("cvg_export", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cvg_export.connect(cvg_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever 
    begin
        cvg_fifo.get(seq_item);
        cvr_gp.sample();    
    end
endtask

endclass 
endpackage