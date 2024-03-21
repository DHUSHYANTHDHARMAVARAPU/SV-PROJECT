
vlib work
vlog 8088if.svp +acc -lint -source
vlog RAM.sv +acc -lint -source
vlog top.sv -lint +acc -lint -source
vlog Intel088Pins.sv +acc -lint -source

vsim -c top

add wave -r *
run -all



