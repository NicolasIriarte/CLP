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

# Build and run exercise 2.
ex2:
    #!/bin/bash
    set -e
    DIR=2_sum4b

    FILE=sum4b
    TEST_BENCH=sum4b_tb

    ghdl -a $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd $DIR/sum1b.vhd
    ghdl -s $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd $DIR/sum1b.vhd
    ghdl -e $TEST_BENCH
    ghdl -r $TEST_BENCH --vcd=$TEST_BENCH.vcd --stop-time=1000ns


# Build and run exercise 3.
ex3:
    #!/bin/bash
    set -e
    DIR=3_sumres4b

    FILE=sumres4b
    TEST_BENCH=sumres4b_tb

    ghdl -a $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd $DIR/sum1b.vhd
    ghdl -s $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd $DIR/sum1b.vhd
    ghdl -e $TEST_BENCH
    ghdl -r $TEST_BENCH --vcd=$TEST_BENCH.vcd --stop-time=1000ns

# Build and run exercise 4.
ex4:
    #!/bin/bash
    set -e
    DIR=4_mux_2x1

    FILE=mux_2x1
    TEST_BENCH=mux_2x1_tb

    ghdl -a $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd
    ghdl -s $DIR/$FILE.vhd $DIR/$TEST_BENCH.vhd
    ghdl -e $TEST_BENCH
    ghdl -r $TEST_BENCH --vcd=$TEST_BENCH.vcd --stop-time=1000ns

# Open last compiled file.
wave:
    #!/bin/bash
    set -e
    FILE=$(ls -t *.vcd | head -n1)
    gtkwave $FILE

# Clean repository.
clean:
    #!/bin/bash
    rm -rf *.vcd *.cf
