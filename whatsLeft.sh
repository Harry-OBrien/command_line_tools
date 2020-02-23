todo () { grep -nr "TODO" ./$1 | grep -v git; }
