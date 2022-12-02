#!/usr/bin/env bash

# A Rock 1 point
# B Paper 2 points
# C Scissors 3 points

while getopts "h" option
do
  case $option in
    # n) n="${OPTARG}"
    #   ;;
    h|*) echo "usage: $0 file"
      exit 1
      ;;
  esac
done

shift $(($OPTIND - 1))

# : ${n:=1}

cat ${1:--} \
| awk \
'
/A X/ { score += 3 + 0 }
/A Y/ { score += 1 + 3 }
/A Z/ { score += 2 + 6 }
/B X/ { score += 1 + 0 }
/B Y/ { score += 2 + 3 }
/B Z/ { score += 3 + 6 }
/C X/ { score += 2 + 0 }
/C Y/ { score += 3 + 3 }
/C Z/ { score += 1 + 6 }
END { print score }
'
