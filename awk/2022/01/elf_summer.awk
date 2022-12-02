BEGIN {
  elf = 1
  elves[1] = 0
}
$1 == "" { elf += 1; elves[elf] = 0 }
/[0-9]/ {
  elves[elf] += $1
}
END {
  for (elf in elves)
    print elves[elf]
}
