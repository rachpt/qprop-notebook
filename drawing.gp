#!/usr/bin/env gnuplot
# Author: rachpt
# Date: 2019-05-14

##文件夹名
##-------------------------------------##
foldername=system("basename `pwd`")
##------------select-theta--------------#

system sprintf("rm -f %s_tsurff_polar.dat", foldername)
### print only the lines for theta=pi/2 and blank lines between the data blocks
system "awk '$3==1.5707963267948966 || $0==\"\" {print $0}' $(ls -v tsurff-polar*) > tsurff-polar.dat"
### erase superfluous blank lines
system "cat -s tsurff-polar.dat > temp"
### copy line for phi=0 to the end of a data block
system sprintf("awk '$4==0 { line=$0 }; $0==\"\" { $0 = $0 line \"\\n\" }; { print $0 }' temp > %s_tsurff_polar.dat", foldername)
system "rm -f temp" 

##------------select-theta--------------#
reset # 重置
set encoding utf8
set term png enhanced size 1400,800 background rgb "white" # font "Noto Sans CJK SC"

# 图片输出路径
set output foldername."_polar_spectrum.png"

set grid  # 显示网格
# 设置标题
set label foldername at -3.8,6.2 font ',22'

# 设置 color bar
set palette defined ( 0 0 0 0, 0.1667 0 0 1, 0.5 1 1 0, 1 1 0 0 )

# Heaviside function
theta(x)=(x<0)?0.0:1.0

##-------------------------------------##
set multiplot layout 1,2 # 画多个图片
# 170  --> x
# 171  --> y
set xlabel 'energy {/CMU10 \170}-direction (eV)' font ',18'
set ylabel 'energy {/CMU10 \171}-direction (eV)' font ',18'

set tics nomirror # 不显示坐标对称刻度

set mapping cylindrical # 柱对称坐标系
set pm3d map # 投影到底面

#------位置一-------#
set origin 0.0,0.25
set size 0.6,0.6
set size square # 矩形

#------边界-------#
 set tmargin  at screen 0.95
 set bmargin  at screen 0.05
 set lmargin at screen 0.05
 set rmargin at screen 0.5

#------范围-------#
set xrange [-10:10]           #########----!!!
set yrange [-10:10]           #########----!!!

# 最大能量值，需要修改
mx=0.5 * 27.2114              #########----!!!
set border 1+2+4
unset key
# gnuplot expects: theta, z, r
 splot sprintf("%s_tsurff_polar.dat", foldername) u 4:($5)*(theta(mx-$2)):($1 * 27.2114) w pm3d t foldername

##-------------------------------------##
set mapping cartesian # 笛卡尔坐标系

#------范围-------#
set xrange [2:7]              #########----!!!
set yrange [0:6.283185307]

set view 0,0 # 俯视图
set ylabel 'phi' offset -3,1 rotate by 18
set xlabel 'energy' offset 1,2.5
unset key

#------边界-------#
 set tmargin  at screen 0.95
 set bmargin  at screen 0.1
 set lmargin at screen 0.6
 set rmargin at screen 0.95

unset colorbox # 不显示 colorbar

splot sprintf("%s_tsurff_polar.dat", foldername) u ($1*27.2114):4:5 w pm3d

##-------------------------------------##
unset multiplot

