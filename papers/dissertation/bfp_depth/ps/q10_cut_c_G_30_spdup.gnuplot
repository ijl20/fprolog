
# This is a command file for gnuplot

# set title "queens10_cut_c Speedup G=30, L=1..30"

set nokey

set grid

set xtics (1,3,6,9,12,15,18,21,24,27,30)

set ylabel "Speedup"

set xlabel "L"

set yrange [1:20]

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 12

set output "q10_cut_c_G_30_spdup.ps"

plot "q10_cut_c_G_30.data" using 1:3 with linespoints



