
# This is a command file for gnuplot

set nokey

set grid

set ylabel "Depth"

set xlabel "Branches"

set tics out

set label "root" at -50,-4

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 10

set output "cl2_tree.ps"

set yrange [70:0]

plot "cl2_tree.data" using 2:1 with lines 1





