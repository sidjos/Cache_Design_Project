onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/reset
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/clk
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/clk_with_stop
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/clk_with_stop_and_trigger
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/not_clk_with_stop_and_trigger
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/L2_Miss
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/main_write
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/data_valid
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/address
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/data_out_with_tag
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/data_out_sig
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/mux0
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/mux1
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/mux2
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/mux3
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/mux4
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/shifter
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/syncram0
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/mux6
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/counter
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/counter_minus_one
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/counter_minus_one_to_be_64
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/syncram_map/addr
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/syncram_map/dout
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/not1
add wave -noupdate /cache_grader/mem_map/mainMemoryMap/and0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {967 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 463
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 10
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {44 ns}
