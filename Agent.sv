package agent_pkg ;
 
    import uvm_pkg::*;
    import driver_pkg::*;
    import monitor_pkg::*;
    import sequencer_pkg::*;
    import config_obj_pkg::*;
    import seq_item_pkg::*;
    `include "uvm_macros.svh"

class FIFO_agent extends uvm_agent ;
`uvm_component_utils(FIFO_agent)

FIFO_driver driver ;
FIFO_monitor monitor ;
FIFO_Sequencer sequencer ;
FIFO_config_obj config_obj ;
uvm_analysis_port #(FIFO_seq_item) agent_aport ;


function new(string name = "FIFO_agent", uvm_component parent = null);   
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(FIFO_config_obj)::get(this , "" , "CFG" , config_obj)  )
        `uvm_fatal("build_phase" , "Agent - couldn't get the configuration object")
        
        driver = FIFO_driver::type_id::create("driver" , this);
        monitor = FIFO_monitor::type_id::create("monitor" , this);
        sequencer = FIFO_Sequencer::type_id::create("sequencer" , this);
        agent_aport = new("agent_aport" , this);
endfunction

function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.FIFOif  = config_obj.FIFOif;
        monitor.FIFOif = config_obj.FIFOif;
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.monitor_aport.connect(agent_aport);
endfunction

endclass 
endpackage