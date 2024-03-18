ghdl -a ../Fuentes/neg.vhd ../Fuentes/neg_tb.vhd
ghdl -s ../Fuentes/neg.vhd ../Fuentes/neg_tb.vhd
ghdl -e neg_tb
ghdl -r neg_tb --vcd=neg_tb.vcd --stop-time=1000ns
gtkwave neg_tb.vcd
