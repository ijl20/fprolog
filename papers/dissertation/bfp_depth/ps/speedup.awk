 $1 == 1 { single_cpu_time = $2 
           print $1 " " $2 " " 1 
         }
 $1 != 1 { print $1 " " $2 " " single_cpu_time / $2 } 
