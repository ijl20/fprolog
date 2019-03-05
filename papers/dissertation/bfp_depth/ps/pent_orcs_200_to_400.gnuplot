
# This is a command file for gnuplot

set nokey

set grid

set ylabel "ms"

set xlabel "Oracle number"

set tics out

set size 0.4,0.4

set terminal postscript portrait mono "Times-Roman" 12

set output "pent_orcs_200_to_400.ps"

plot [200:400] "pent.orcs" using 4:10 with lines



