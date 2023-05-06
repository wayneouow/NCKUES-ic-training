remove_design -designs
read_file -format verilog {./CONV.v}
uplevel #0 source ./CONV.sdc

compile -exact_map

#compile_ultra

write -hierarchy -format verilog -output ./CONV_syn.v
write_sdf -version 2.1 -context verilog ./CONV_syn.sdf
#report_timing > ./timing.log
#report_area > ./area.log
exit