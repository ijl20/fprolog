
# This is a command file for gnuplot

set nokey

set grid

set ylabel "Depth"

set xlabel "Branches"

set tics out

set xtics 0,200000,1000000

set label "root" at -40000, -15
set size 0.4,0.4

set terminal post portrait mono "Times-Roman" 10

set output "over_tree.ps"

set yrange [340:0]
set xrange [0:1000000]

plot "over_tree.data" using 2:1 with lines 1





