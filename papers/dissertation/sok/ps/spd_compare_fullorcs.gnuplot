
# This is a command file for gnuplot

set key 26,23

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "L"

set yrange [1:20]

set label "A" at 1.6,12.6

set size 0.5,0.5

set terminal postscript portrait mono "Times-Roman" 12

set output "spd_compare_fullorcs.ps"

plot "spd_compare.data" using 1:8 title "SOK doubling, full orcs" with linespoints, \
     "spd_compare.data" using 1:7 title "SOK fixed, full orcs" with linespoints, \
     "spd_compare.data" using 1:2 title "BFP one-time" with linespoints



