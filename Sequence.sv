package sequence_pkg ;

import uvm_pkg::*;
import seq_item_pkg::*;
`include "uvm_macros.svh"

/*----------------------------reset sequence-----------------------------*/
class FIFO_reset_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_reset_seq)
   
FIFO_seq_item seq_item;

function new(string name = "FIFO_reset_seq");
    super.new(name);
endfunction 

task body();
        seq_item = FIFO_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n = 0 ;
        seq_item.wr_en = 0 ;
        seq_item.rd_en = 0 ;
        finish_item(seq_item);
endtask 
endclass


/*----------------------------Write only sequence-----------------------------*/
class FIFO_write_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_write_seq)
   
FIFO_seq_item seq_item;

function new(string name = "FIFO_write_seq");
    super.new(name);
endfunction 

task body( );
    repeat(500)
    begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    seq_item.WR_EN_cons.constraint_mode(0); /* disable the constraint of write Enable */ 
    seq_item.RD_EN_cons.constraint_mode(0); /* disable the constraint of read  Enable */ 
    seq_item.read_only.constraint_mode(0);  /* disable the constraint of read only    */ 

    seq_item.rst_cons.constraint_mode(1);   /* Enable the constraint of reset         */
    seq_item.write_only.constraint_mode(1); /* Enable the constraint of write only    */

        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
    end
endtask 
endclass

/*----------------------------read only sequence-----------------------------*/
class FIFO_read_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_read_seq)
   
FIFO_seq_item seq_item;

function new(string name = "FIFO_read_seq");
    super.new(name);
endfunction 

task body();

    repeat(500)
    begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    seq_item.WR_EN_cons.constraint_mode(0); /* disable the constraint of write Enable */ 
    seq_item.RD_EN_cons.constraint_mode(0); /* disable the constraint of read  Enable */ 
    seq_item.write_only.constraint_mode(0); /* disable the constraint of write only   */

    seq_item.rst_cons.constraint_mode(1);   /* Enable the constraint of reset         */
    seq_item.read_only.constraint_mode(1);  /* Enable the constraint of read only     */ 
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
    end
endtask 
endclass

/*----------------------------read write sequence-----------------------------*/
class FIFO_rd_wr_seq extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(FIFO_rd_wr_seq)
   
FIFO_seq_item seq_item;

function new(string name = "FIFO_rd_wr_seq");
    super.new(name);
endfunction 

task body();

    repeat(100000)
    begin
    seq_item = FIFO_seq_item::type_id::create("seq_item");
    seq_item.write_only.constraint_mode(0); /* disable the constraint of write only   */
    seq_item.read_only.constraint_mode(0);  /* disable the constraint of read only    */ 

    seq_item.rand_value( );                  /* set the default values for randomization */
    seq_item.rst_cons.constraint_mode(1);    /* Enable the constraint of reset           */
    seq_item.WR_EN_cons.constraint_mode(1);  /* Enable the constraint of write Enable    */ 
    seq_item.RD_EN_cons.constraint_mode(1);  /* Enable the constraint of read  Enable    */ 
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
    end
endtask 
endclass

endpackage