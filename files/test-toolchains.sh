#!/bin/bash
prior_gcc="$(which gcc)"

cat > /tmp/test.c << 'EOF'
#include <stdio.h>

int main() {
  printf("Test!\n");
  return 0;
}
EOF

for toolchain in /home/toolchain-user/toolchains/*.activate
do
  source "$toolchain"
  
  new_gcc="$(which gcc)"
  if [ "$new_gcc" = "$prior_gcc" ]
  then
    echo "ERROR: gcc executable did not change, environment broken or duplicate toolchain"
    /bin/false
  fi
  prior_gcc="$new_gcc"
  gcc /tmp/test.c -o /tmp/test
done
