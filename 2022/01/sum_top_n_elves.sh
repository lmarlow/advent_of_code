#!/usr/bin/env bash

while getopts "n:" option
do
  case $option in
    n) n="${OPTARG}"
      ;;
    *) echo "$0 [-n N] file"
      exit 1
      ;;
  esac
done

shift $(($OPTIND - 1))

: ${n:=1}

cat ${1:--} \
| awk -f elf_summer.awk \
| sort -n \
| tail -${n} \
| awk '{ sum += $1 } END { print sum }'
