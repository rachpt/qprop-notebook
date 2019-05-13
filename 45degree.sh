#!/bin/bash
# Author: rachpt@126.com
# Date: 2019-05-13

# TODO :line integrate at 45 degree
# Parameter tsurff_polar.dat

[[ -f $1 ]] && \
awk 'BEGIN{se=0.7853981633974483}{
  if ($4 <= se) {rr=$2;old=$5;n=1;} 
  else { if (n == 1) 
      {print ($2+rr)/2,($5+old)/2}; n++ }
  }' "$1" > 45.dat || echo 'Need a parameter!'

