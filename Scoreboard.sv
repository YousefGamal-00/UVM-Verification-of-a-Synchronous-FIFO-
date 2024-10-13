package scoreboard_pkg ;
    import uvm_pkg::*;
    import seq_item_pkg::*;
    `include "uvm_macros.svh"

class FIFO_scoreboard extends uvm_scoreboard ;
`uvm_component_utils(FIFO_scoreboard)

FIFO_seq_item seq_item_sb ;
uvm_analysis_export #(FIFO_seq_item) sb_export ;
uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;

/*---------------signals of reference model ------------------------------*/
localparam FIFO_DEPTH = 8;
localparam FIFO_WIDTH = 16;

logic [FIFO_WIDTH-1 : 0] data_out_ref ;
bit [$clog2(FIFO_DEPTH) : 0] counter ;              
int My_ref_Queue[$] ;           

    int error_count = 0;
    int correct_count = 0;


function new(string name = "FIFO_scoreboard", uvm_component parent = null) ;
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_fifo   = new("sb_fifo"  , this);
    sb_export = new("sb_export", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever 
    begin
            sb_fifo.get(seq_item_sb);
        golden_model( seq_item_sb );

        if(data_out_ref != seq_item_sb.data_out)
            begin
                error_count++;
                `uvm_error("run_phase" , $sformatf("transaction received : %s , output expected = %0d " ,
                                            seq_item_sb.convert2string() , data_out_ref  ) )
                                            $stop ;
            end    
        else
            begin
                correct_count++ ;
            end
    end
endtask


task golden_model(  FIFO_seq_item seq_item_sb );
fork
    begin // first thread -> write operation
        if (!seq_item_sb.rst_n) 
            begin
                My_ref_Queue.delete() ;
                counter = 0 ;
            end   
        else
             begin
                if ( seq_item_sb.wr_en && (counter < FIFO_DEPTH) ) 
                    begin  
                        My_ref_Queue.push_front(seq_item_sb.data_in) ;
                    end                
             end         
    end   

    begin // second thread -> read operation
        if (seq_item_sb.rst_n) 
        begin
            if ( seq_item_sb.rd_en && (counter != 0) ) 
            begin  
                data_out_ref = My_ref_Queue.pop_back() ;
            end
        end

    end   

    begin //  third thread -> Counter updating   
        if (!seq_item_sb.rst_n) 
            counter = 0;
        else 
            begin
                casex ({seq_item_sb.wr_en, seq_item_sb.rd_en, (counter == FIFO_DEPTH), (counter == 0) })
                    4'b11_01: // Both write and read enabled, FIFO empty
                        counter = counter + 1; // Prioritize write if FIFO is empty

                    4'b11_10: // Both write and read enabled, FIFO full
                        counter = counter - 1; // Prioritize read if FIFO is full

                    4'b10_0x: // Write enabled, not full
                        counter = counter + 1;

                    4'b01_x0: // Read enabled, not empty
                        counter = counter - 1;
                 endcase
            end
    end            
join
endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful counts: %0d", correct_count), UVM_LOW);
            `uvm_info("report_phase", $sformatf("Total failed counts: %0d", error_count), UVM_LOW);
        endfunction

endclass
endpackage