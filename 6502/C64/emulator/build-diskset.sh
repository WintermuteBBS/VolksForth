#!/bin/bash
export PATH=$PATH:$HOME/bin

c1541 -format v4th-3.9.6,01 d64 v4th-3.9.6_1.d64 8
c1541 -format v4th-3.9.6,02 d64 v4th-3.9.6_2.d64 8

c1541 v4th-3.9.6_1.d64 -write ../cbmfiles/v4thblk-c64
c1541 v4th-3.9.6_1.d64 -write ../cbmfiles/v4th-c64
c1541 v4th-3.9.6_1.d64 -write ../cbmfiles/v4thblk-c16-
c1541 v4th-3.9.6_1.d64 -write ../cbmfiles/v4th-c16-
c1541 v4th-3.9.6_1.d64 -write ../cbmfiles/v4thblk-c16+
c1541 v4th-3.9.6_1.d64 -write ../cbmfiles/v4th-c16+
c1541 v4th-3.9.6_1.d64 -write ../cbmfiles/v4th-x16
c1541 v4th-3.9.6_1.d64 -write ../cbmfiles/v4th-x16e

for i in $(ls ../cbmfiles/*.fth | grep -v grep | grep -v 'vf-' | grep -v 'v4th') ; do c1541 v4th-3.9.6_2.d64 -write $i `basename $i`,s ; done
