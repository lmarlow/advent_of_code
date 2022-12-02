BEGIN {
  max = 0
  running = 0
}
$1 == "" { running = 0 }
/[0-9]/ {
  running += $1
  if (running > max)
    max = running
}
END { print max }
