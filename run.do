vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
coverage save top.ucdb -onexit -du FIFO
run 0
## Add the signals on wave
add wave -position insertpoint  \
sim:/top/FIFOif/clk \
sim:/top/FIFOif/rst_n \
sim:/top/FIFOif/wr_en \
sim:/top/FIFOif/rd_en \
sim:/top/FIFOif/wr_ack \
sim:/top/FIFOif/full \
sim:/top/FIFOif/empty \
sim:/top/FIFOif/overflow \
sim:/top/FIFOif/underflow \
sim:/top/FIFOif/almostfull \
sim:/top/FIFOif/almostempty \
sim:/top/FIFOif/data_in \
sim:/top/FIFOif/data_out \
sim:@FIFO_scoreboard@1.data_out_ref \
sim:/top/DUT/count \
sim:@FIFO_scoreboard@1.counter
## Add assertions to wave
add wave /top/DUT/SVA_inst/assert_reset_falgs
add wave /top/DUT/SVA_inst/assert_empty
add wave /top/DUT/SVA_inst/assert_full
add wave /top/DUT/SVA_inst/assert_almostfull
add wave /top/DUT/SVA_inst/assert_almostempty
add wave /top/DUT/SVA_inst/RD_PTR_assert
add wave /top/DUT/SVA_inst/WR_PTR_assert
add wave /top/DUT/SVA_inst/assert_overflow
add wave /top/DUT/SVA_inst/assert_underflow
add wave /top/DUT/SVA_inst/assert_wr_ack_1
add wave /top/DUT/SVA_inst/assert_wr_ack_0
## Excluding the illegal bins
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_wr_ack/<auto[0],auto[1],auto[1]>} 
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_wr_ack/<auto[0],auto[0],auto[1]>}
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_overflow/<auto[0],auto[1],auto[1]>}
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_overflow/<auto[0],auto[0],auto[1]>}
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_underflow/<auto[1],auto[0],auto[1]>} 
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_underflow/<auto[0],auto[0],auto[1]>}
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_full/<auto[1],auto[1],auto[1]>}
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_full/<auto[0],auto[1],auto[1]>}
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_empty/<auto[1],auto[1],auto[1]>}
coverage exclude -cvgpath {/cvg_pkg/FIFO_cvg_collector/cvr_gp/cross_coverage_empty/<auto[1],auto[0],auto[1]>}
run -all 
#vcover report top.ucdb -details -annotate -all -output coverage_report.txt