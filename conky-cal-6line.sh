#!/bin/bash
# A calendar inspired by one in the gmail.
# I thought it is a good idea to have one in conky.
# So Here it is.
#
# Inspiration to use a calendar came from Crinos512 at conkyhardcore.net
#
# by Ignas Anikevicius
# Usage:
#  ${execpi 5 ~/scripts/conky/calendar.sh [[-m][-ms][-s][-ss]] [--reset]}
#
# SEE THE SCRIPT BELLOW THE FUNCTION DEFINITIONS !!!!!!!!!!!!

text_noopts ()
{
  echo -e "
  No or wrong options were provided.
  Edit the command options, please.
  "
}

text_help ()
{
  echo -e "\
  -------------------
  Options available:
  -------------------

    [--help] - to display this text.
    [--reset] - to redraw the calendar.

    [-m] - Week starts on Monday.
    [-ms] - Week starts on Monday, day names in short version.
    [-s] - Week starts on Sunday.
    [-ss] - Week starts on Sunday, day names in short version.

  -------------------
  Usage:
  -------------------

    to show the calendar:
      <path to script> [[-m][-ms][-s][-ss]]
    to reset the calendar (now output will be produced)
      <path to script> [[-m][-ms][-s][-ss]] --reset
    to show help:
      <path to script> --help\n"
  exit 0
}

calendar ()
{
#  Chose the weekdays format you want:
  case $1 in
    -m)
    wk_days="Mo Tu We Th Fr Sa Su"
    cal_var=-m
    ;;
    -ms)
    wk_days=" M  T  W  T  F  S  S "
    cal_var=-m
    ;;
    -s)
    wk_days="Su Mo Tu We Th Fr Sa"
    cal_var=-s
    ;;
    -ss)
    wk_days=" S  M  T  W  T  F  S "
    cal_var=-s
    ;;
  esac
# Font definitions
  font="\${font inconsolata:medium:size=12}"
  font_b="\${font inconsolata:bold:size=12}"
  font_huge="\${font inconsolata:size=13}"
  font_huge_b="\${font inconsolata:bold:size=13}"
# What is the day number today?
  Day=$(date +%_d)
# Month numbers?
  Mnr=$(date +%_m)
# Year numbers?
  Year=$(date +%Y)
# In case of two critical cases if the month is changing
  case $Mnr in
    1)
    Mnr_p="12"
    Mnr_n="2"
    Year_p=$(($Year-1))
    Year_n=$Year
    ;;
    12)
    Mnr_p="11"
    Mnr_n="1"
    Year_p=$Year
    Year_n=$(($Year+1))
    ;;
    *)
    Mnr_p=$(($Mnr-1))
    Mnr_n=$(($Mnr+1))  
    Year_p=$Year
    Year_n=$Year
  esac
# The name of the currnet month 
#  Month=$(date -d "${Year}-${Mnr}-01" +%B)
  Month=$(date +'%B %Y')
#
  cal_p=$(cal $cal_var $Mnr_p $Year_p \
  | sed '/./!d' \
  | sed '$!d' \
  | sed 's/^/ /')
#
  cal_now="$(cal $cal_var $Mnr $Year \
  | sed '3!d' \
  | sed 's/^[ \t]*/  /')\
\n$(cal $cal_var $Mnr $Year \
  | sed '1,3d' \
  | sed '/./!d' \
  | sed 's/^/ /')"
#
  if [ $(echo $cal_p | wc -c) -eq 21 ]; then
    cal_p="$cal_p\n"
  fi

  count_l=$((8-$(echo -e "$cal_p$cal_now" | wc -l)))
  count_sll=$(echo -e "$cal_now" | sed '$!d' | wc -c)

  if [ $count_l -eq 3 ] && [ $count_sll -ne 22 ]; then
    count_l=4
  fi

  cal_n=$(cal $cal_var $Mnr_n $Year_n \
      | sed "3,$count_l!d" \
      | sed 's/^[ \t]*/ /' \
      | sed 's/^/ /')

  if [ $count_sll -eq 22 ]; then
    cal_n="\n$cal_n"
  fi

  cal_now=$(echo -e "$cal_now" \
  | sed /" $Day"/s/" $Day"/""'\${color1}'" $Day"'\${color}'""/)

  cal=$(echo -e "$cal_p$font_b"'${color}'"$cal_now"'${color2}'"$font$cal_n"'${color}' | sed 's/^/\${alignc}/')
#
  echo -e "\
\${hr 1}
$font_huge_b\${alignc}${Month}
\${voffset -7}\${hr 1}
$font_b\${color1}\${alignc} $wk_days\${color2}$font
$cal
\${hr 1}\
" > $OUT_FILE

  echo $Date > $DATE_FILE
  echo $1 >> $DATE_FILE
}

# The script starts here
DATE_FILE=${HOME}/.conky/.cal.sys.conky
OUT_FILE=${HOME}/.conky/.cal.out.conky

if [ "X$2" = "X--reset" ]; then
  rm $DATE_FILE; fi

# if the script is running for the first time
if [ ! -r $DATE_FILE ]; then
  echo "0" > $DATE_FILE; fi

if [ "X$1" = "X" -o "X$1" = "X--reset" ]; then
  text_noopts
  text_help
fi

if [ "X$1" = "X--help" ]; then
  text_help
fi

Date=$(date +"%Y %m %d")
Date_f=$(cat $DATE_FILE | sed '1!d')

Format=$(cat $DATE_FILE | sed '2!d')

if [ "X$Date_f" != "X$Date" -o "X$Format" != "X$1" ]; 
then
  calendar $1
fi

if [ "X$2" != "X--reset" ]; then
  # Reading the file of commands
  Text=`cat $OUT_FILE`
  echo "$Text"
fi

exit 0
