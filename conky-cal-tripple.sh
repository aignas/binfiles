#!/bin/bash
# calendar3.sh
# by Ignas Anikevicius
# Usage:
#  ${execpi 5 ~/.conky/conkyparts/calendar.sh [[m] [m1] [s] [s1]] [--reset]}
#  m - if weeks start from monday
#
DATE_FILE=${HOME}/.conky/.cal.sys.conky
OUT_FILE=${HOME}/.conky/.cal.out.conky

# if the cal is restarted
if [ "X$1" = "X--reset" ]; then
  rm $DATE_FILE; fi
# if the script is running the first time
if [ ! -r $DATE_FILE ]; then
  echo "0" > $DATE_FILE; fi

Date=`date +"%Y %m %d"`
Date_f=`cat $DATE_FILE`

if [ "X$Date_f" != "X$Date" ]; 
then
#  Chose the weekdays format you want:
  wk_days="Mo Tu We Th Fr Sa Su"
#  wk_days=" M  T  W  T  F  S  S "
#  wk_days="Su Mo Tu We Th Fr Sa"
#  wk_days=" S  M  T  W  T  F  S "

#  Adjust the cal commands according to the manual if you want to start the week on sunday or monday
#  read the cal man page

  Day=`date +%_d`

  Mnr=`date +%m`
  Mnr_p=$(($Mnr-1))
  Mnr_n=$(($Mnr+1))

  Year=`date +%Y`
  Year_p=$Year
  Year_n=$Year

  font="\${font monaco:size=10}"
  font_b="\${font monaco:bold:size=10}"
  font_huge="\${font monaco:size=12}"
  font_huge_b="\${font monaco:bold:size=12}"

  case $Mnr in
    01)
    Mnr_p="12"
    Year_p=$(($Year-1))
    ;;
    12)
    Mnr_n="01"
    Year_n=$(($Year+1))
    ;;
  esac
 
  Month=`date -d "${Year}-${Mnr}-01" +%B`
  Month_p=`date -d "${Year_p}-${Mnr_p}-01" +%B`
  Month_n=`date -d "${Year_n}-${Mnr_n}-01" +%B`
 #
#  | sed '/./!d' \
  cal_p=`cal -m $Mnr_p $Year_p \
  | sed '1,2d' \
  | sed '/./!d' \
  | sed 's/$/                     /' \
  | sed -n '/^.\{21\}/p' \
  | sed 's/^/${goto 14} /' `
  #
  cal=`cal -m $Mnr $Year \
  | sed '1,2d' \
  | sed '/./!d' \
  | sed 's/$/                     /' \
  | sed -n '/^.\{21\}/p' \
  | sed 's/^/${goto 14} /' \
  | sed /" $Day "/s/" $Day "/""'${color1}'" $font_b$Day$font "'${color}'""/`
  #
  cal_n=`cal -m $Mnr_n $Year_n \
  | sed '1,2d' \
  | sed '/./!d' \
  | sed 's/$/                     /' \
  | sed -n '/^.\{21\}/p' \
  | sed 's/^/${goto 14} /' `
 
echo -e "\
\${hr 1}
${font_huge_b}\${alignc}${Month_p} ${Year_p}
\${voffset -9}\${hr 1} 
${font}\${color1}\${alignc} $wk_days\${color2}
$cal_p \${color}
\${hr 1}
$font_huge_b\${alignc}${Month} ${Year}
\${voffset -9}\${hr 1} 
$font\${color1}\${alignc} $wk_days\${color2} 
$cal \${color}
\${hr 1}
$font_huge_b\${alignc}${Month_n} ${Year_n}
\${voffset -9}\${hr 1} 
$font\${color1}\${alignc} $wk_days\${color2} 
$cal_n\
" > $OUT_FILE

  echo $Date > $DATE_FILE
fi

if [ "X$1" != "X--reset" ]; then
  # Reading the file of commands
  Text=`cat $OUT_FILE`
  echo "$Text"
fi

exit 0
