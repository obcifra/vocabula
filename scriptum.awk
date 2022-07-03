BEGIN {
  printf ".TL\n%s %d\n", "Psalmum", psalmum
  printf ".AU\n%s\n\n", "Vocabula et Glossae"
}

/\{*\}/ {
  ret = match($0, /([[:alpha:]]+)/, matches)
  if (ret != 0) {
    print ".LP"
    printf ".B \"%s\"\n", matches[0]
  }
}

/<</ {
  getline
  print ".RS"
  do {
    ret = match($0, /\[[[:alpha:]]+\]/)
    if (ret != 0) {
      printf ".IP \"%s\"\n", substr($0, 0, ret - 1)
    } else {
      ret = match($0, /^[[:space:]]*$/)
      if (ret == 0) {
        print
      }
    }
    getline
  } while ($0 !~ />>/)
  print ".RE"
}
