# Build and run Sum1B (Example).
ex00:
    #!/bin/bash
    set -e
    DIR=00_neg

    FILE=neg
    TEST_BENCH=neg_tb

    ghdl -a $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd
    ghdl -s $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd
    ghdl -e $TEST_BENCH
    ghdl -r $TEST_BENCH --vcd=$TEST_BENCH.vcd --stop-time=1000ns
    gtkwave $TEST_BENCH.vcd

# Build and run Hello world.
ex01:
    #!/bin/bash
    set -e
    DIR=01_hello_world

    FILE=hello_world

    ghdl -a $DIR/$FILE.vhd
    ghdl -s $DIR/$FILE.vhd
    ghdl -e $FILE
    ghdl -r $FILE --vcd=$FILE.vcd --stop-time=1000ns

# Build and run Hello world.
ex02:
    #!/bin/bash
    set -e
    DIR=02_heartbeat

    FILE=heart_beat

    ghdl -a $DIR/$FILE.vhd
    ghdl -s $DIR/$FILE.vhd
    ghdl -e $FILE
    ghdl -r $FILE --wave=$FILE.ghw --stop-time=400ns
    gtkwave $FILE.ghw

# Build and run exercise 1.
ex1:
    #!/bin/bash
    set -e
    DIR=1_sum1b

    FILE=sum1b
    TEST_BENCH=sum1b_tb

    ghdl -a $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd
    ghdl -s $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd
    ghdl -e $TEST_BENCH
    ghdl -r $TEST_BENCH --vcd=$TEST_BENCH.vcd --stop-time=1000ns
    gtkwave $TEST_BENCH.vcd



# Clean repository.
clean:
    #!/bin/bash
    rm -rf *.vcd *.cf
