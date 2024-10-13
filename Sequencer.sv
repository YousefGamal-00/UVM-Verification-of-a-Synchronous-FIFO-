package sequencer_pkg;

import uvm_pkg::*;
import seq_item_pkg::*;
`include "uvm_macros.svh"

class FIFO_Sequencer extends uvm_sequencer #(FIFO_seq_item);
        `uvm_component_utils(FIFO_Sequencer)

        function new( string name = "FIFO_Sequencer", uvm_component parent = null );
            super.new(name,parent);
        endfunction 
endclass 
endpackage