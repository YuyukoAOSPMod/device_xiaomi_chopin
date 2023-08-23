#!/vendor/bin/sh

########################################################
### init.insmod.cfg format:                          ###
### -----------------------------------------------  ###
### [insmod|setprop|enable/moprobe] [path|prop name] ###
### ...                                              ###
########################################################

if [ $# -eq 1 ]; then
  cfg_file=$1
else
  exit 1
fi

if [ -f $cfg_file ]; then
  while IFS="|" read -r action arg
  do
    case $action in
      "insmod") insmod $arg ;;
      "setprop") setprop $arg 1 ;;
      "enable") echo 1 > $arg ;;
      "modprobe")
        case ${arg} in
          "-b *" | "-b")
            arg="-b $(cat /vendor/lib/modules/modules.load)" ;;
          "*" | "")
            arg="$(cat /vendor/lib/modules/modules.load)" ;;
        esac
        modprobe -a -d /vendor/lib/modules $arg ;;
    esac
  done < $cfg_file
fi

