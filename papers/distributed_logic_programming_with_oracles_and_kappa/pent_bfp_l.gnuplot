
# This is a command file for gnuplot

# set title "pentbook_cut_c Speedup G=30, L=1..30"

set key 12.45,18.7

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "L"

set yrange [1:20]

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 12

set output "pent_bfp_l.ps"

plot "pent_bfp_l.data" using 1:5 title "fixed" with linespoints, \
     "pent_bfp_l.data" using 1:11 title "demand 25ms" with linespoints, \
     "pent_bfp_l.data" using 1:14 title "demand 250ms" with linespoints




