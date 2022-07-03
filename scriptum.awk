BEGIN {
  printf ".TL\n%s %d\n", "Psalmum", psalmum
  printf ".AU\n%s\n\n", "Vocabula et Glossae"
}

/\{*\}/ {
  ret = match($0, /([[:alpha:]]+)/, matches)
  if (ret != 0) {
    printf ".IP %s\n", matches[0]
  }
}

/<</ {
  getline
  do {
    print
    getline
  } while ($0 !~ />>/)
}
