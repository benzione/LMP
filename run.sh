#!/bin/bash

y=1
while [ $y -le 2 ]
do

z=1
while [ $z -le 4 ]
do

k=1
while [ $k -le 5 ]
do

x=1
while [ $x -le 5 ]
do

m=1
while [ $m -le 4 ]
do

JOB=`qsub -cwd -q boaz.q << EOJ

/storage/matlab/bin/matlab << M_PROG
BigExp(${y},${z},${k},${x},${m});
M_PROG
EOJ
`
echo "JobID = ${JOB} submitted on `date`" 

m=$(( $m + 1))
done

x=$(( $x + 1))
done

k=$(( $k + 1))
done

z=$(( $z + 1))
done

y=$(( $y + 1))
done
exit