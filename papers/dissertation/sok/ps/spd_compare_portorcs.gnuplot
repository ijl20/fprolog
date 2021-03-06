
# This is a command file for gnuplot

set key 38.45,18.7

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "L"

set yrange [1:20]

set size 0.5,0.5

set terminal postscript portrait mono "Times-Roman" 12

set output "spd_compare_portorcs.ps"

plot "spd_compare.data" using 1:2 title "one-time" with linespoints, \
     "spd_compare.data" using 1:5 title "fixed, orcs to ports" with linespoints, \
     "spd_compare.data" using 1:6 title "doubling, orcs to ports" with linespoints





