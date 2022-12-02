#!/usr/bin/env bash

# A Rock
# B Paper
# C Scissors

# X Rock 1 point
# Y Paper 2 points
# Z Scissors 3 points

# lose 0 points
# draw 3 points
# win 6 points

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
/A X/ { score += 1 + 3 }
/A Y/ { score += 2 + 6 }
/A Z/ { score += 3 + 0 }
/B X/ { score += 1 + 0 }
/B Y/ { score += 2 + 3 }
/B Z/ { score += 3 + 6 }
/C X/ { score += 1 + 6 }
/C Y/ { score += 2 + 0 }
/C Z/ { score += 3 + 3 }
END { print score }
'
