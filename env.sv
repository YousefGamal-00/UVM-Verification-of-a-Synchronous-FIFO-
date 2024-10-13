package env_pkg ;
    
    import uvm_pkg::* ;
    import cvg_pkg::* ;
    import agent_pkg::* ;
    import scoreboard_pkg::* ;
    `include "uvm_macros.svh"

class FIFO_env extends uvm_env ;
`uvm_component_utils(FIFO_env)

FIFO_agent         agt ;
FIFO_scoreboard    sb  ;
FIFO_cvg_collector cvg ;


function new(string name = "FIFO_env", uvm_component parent = null);
super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = FIFO_agent::type_id::create("agt" , this) ;
    sb  = FIFO_scoreboard::type_id::create("sb", this);
    cvg = FIFO_cvg_collector::type_id::create("cvg", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.agent_aport.connect(sb.sb_export);
    agt.agent_aport.connect(cvg.cvg_export);
endfunction

endclass
endpackage