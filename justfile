# Build and run exercise 1.
ex1:
    #!/bin/bash
    set -e
    ghdl -a tp1/neg.vhd tp1/neg_tb.vhd
    ghdl -s tp1/neg.vhd tp1/neg_tb.vhd
    ghdl -e neg_tb
    ghdl -r neg_tb --vcd=neg_tb.vcd --stop-time=1000ns
    gtkwave neg_tb.vcd



# Clean repository.
clean:
    #!/bin/bash
    # rm -rf */*.aux */*.log */*.out */*.toc */*.pdf */build
    echo -e "\033[0;31mUnimplemented\033[0m"
