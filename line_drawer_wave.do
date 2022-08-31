onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group General /line_drawer_testbench/clk
add wave -noupdate -expand -group General /line_drawer_testbench/reset
add wave -noupdate -expand -group {X & Y Inputs} -radix unsigned /line_drawer_testbench/x0
add wave -noupdate -expand -group {X & Y Inputs} -radix unsigned /line_drawer_testbench/y0
add wave -noupdate -expand -group {X & Y Inputs} -radix unsigned /line_drawer_testbench/x1
add wave -noupdate -expand -group {X & Y Inputs} -radix unsigned /line_drawer_testbench/y1
add wave -noupdate -expand -group {Output Signals} /line_drawer_testbench/done
add wave -noupdate -expand -group {Output Signals} -radix unsigned /line_drawer_testbench/x
add wave -noupdate -expand -group {Output Signals} -radix unsigned /line_drawer_testbench/y
add wave -noupdate -expand -group {Temp Values} -radix unsigned /line_drawer_testbench/dut/abs_x
add wave -noupdate -expand -group {Temp Values} -radix unsigned /line_drawer_testbench/dut/abs_y
add wave -noupdate -expand -group {Temp Values} -radix unsigned /line_drawer_testbench/dut/new_x0
add wave -noupdate -expand -group {Temp Values} -radix unsigned /line_drawer_testbench/dut/d_unit/new_y0
add wave -noupdate -expand -group {Temp Values} -radix unsigned /line_drawer_testbench/dut/new_x1
add wave -noupdate -expand -group {Temp Values} -radix unsigned /line_drawer_testbench/dut/d_unit/new_y1
add wave -noupdate -expand -group {Temp Values} -radix unsigned /line_drawer_testbench/dut/result_x
add wave -noupdate -expand -group {Temp Values} -radix unsigned /line_drawer_testbench/dut/d_unit/result_y
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/d_unit/error
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/d_unit/delta_x
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/d_unit/delta_y
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/d_unit/y_step
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/d_unit/prep_reg
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/c_unit/ps
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/d_unit/swap_x_y
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/d_unit/load_reg
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/d_unit/error_gt_0
add wave -noupdate -expand -group Others /line_drawer_testbench/dut/c_unit/load_yx
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3069 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {6878 ps}
