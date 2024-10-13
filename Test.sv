package test_pkg ;
    
    import uvm_pkg::* ;
    import env_pkg::* ;
    import sequence_pkg::* ;
    import config_obj_pkg::* ;

    `include "uvm_macros.svh"

class FIFO_test extends uvm_test ;
`uvm_component_utils(FIFO_test)

FIFO_env  env ;
FIFO_config_obj cnf_obj   ;
FIFO_reset_seq  rst_seq   ;
FIFO_write_seq  wr_seq    ; 
FIFO_read_seq   rd_seq    ; 
FIFO_rd_wr_seq  rd_wr_seq ; 

function new(string name = "FIFO_test", uvm_component parent = null) ;
super.new(name, parent) ;
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cnf_obj   = FIFO_config_obj::type_id::create("cnf_obj");
    env       = FIFO_env::type_id::create("env", this);
    rst_seq   = FIFO_reset_seq::type_id::create("rst_seq" , this);
    wr_seq    = FIFO_write_seq::type_id::create("wr_seq", this);
    rd_seq    = FIFO_read_seq::type_id::create("rd_seq" , this);
    rd_wr_seq = FIFO_rd_wr_seq::type_id::create("rd_wr_seq" , this);
    
    if(!uvm_config_db #(virtual FIFO_if)::get(this , "" , "FIFOif" , cnf_obj.FIFOif ) )
    `uvm_fatal("build_phase" , "Test - couldn't get the interface")

    uvm_config_db#(FIFO_config_obj)::set(this , "*" , "CFG" , cnf_obj);

endfunction

task run_phase( uvm_phase phase );
    super.run_phase(phase);
    phase.raise_objection(this);

    `uvm_info("run-phase" , "reset sequence asserted"   , UVM_LOW); 
    rst_seq.start(env.agt.sequencer); 
    `uvm_info("run-phase" , "reset sequence deasserted" , UVM_LOW); 

    `uvm_info("run-phase" , "write sequence asserted"   , UVM_LOW); 
     wr_seq.start(env.agt.sequencer); 
    `uvm_info("run-phase" , "write sequence deasserted" , UVM_LOW); 

    `uvm_info("run-phase" , "read sequence asserted"   , UVM_LOW); 
     rd_seq.start(env.agt.sequencer); 
    `uvm_info("run-phase" , "read sequence deasserted" , UVM_LOW); 

    `uvm_info("run-phase" , "rd_wr sequence asserted"   , UVM_LOW); 
     rd_wr_seq.start(env.agt.sequencer); 
    `uvm_info("run-phase" , "rd_wr sequence deasserted" , UVM_LOW); 

    phase.drop_objection(this) ; 
endtask
endclass     
endpackage