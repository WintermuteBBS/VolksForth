\ *** Block No. 10, Hexblock a

\ include loadscreen           19jul20pz


\ : i/o-status?  $90 c@ ;

  : dos-error  ( dev -- )
   15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;

\ : unloop  r> rdrop rdrop rdrop >r ;

  : lo/hi> ( lo hi -- u )
     255 and 256 * swap 255 and + ;


  1 4 +thru


  : .filename  2dup cr type ;

  ' .filename IS on-fload




\ *** Block No. 11, Hexblock b

\   fload-dev freadline        25apr20pz

  create fload-dev  8 ,
  create fload-2nd  15 ,
| 132 constant /fib
  create fib /fib allot
  variable #fib

| : eol? ( c -- f )
   dup 0= swap #cr = or IF 0 exit THEN
   i/o-status? IF 1 exit THEN  -1 ;

| : freadline ( -- eof )
 fload-dev @ fload-2nd @ busin
 fib /fib bounds
 DO bus@ dup eol? under
     IF I c! ELSE drop THEN
 dup 0<
   IF drop ELSE I + fib - #fib ! UNLOOP
   i/o-status? busoff exit THEN
 LOOP /fib #fib !
 ." warning: line exceeds max " /fib .
 cr ." extra chars ignored" cr
 BEGIN bus@ eol? 1+ UNTIL
 i/o-status? busoff ;

\ *** Block No. 12, Hexblock c

\   fload-open  fload-close    30jun20pz

| : i/o-status?abort  i/o-status? IF cr
   fload-dev @ dos-error abort THEN ;

  defer on-fload  ' noop is on-fload
| : fload-open ( addr c -- )
 on-fload  fload-dev @
 fload-2nd @ 1- dup fload-2nd !
 busopen bustype
 " ,s,r" count bustype busoff
 i/o-status?abort ;

| : fload-close ( -- )
 fload-dev @ fload-2nd @
 dup 1+ fload-2nd !
 busclose ;

  : factive? ( -- flag )
 fload-2nd @ 15 < ;

  : fload-close-all ( -- )
 factive? IF 15 fload-2nd @ DO
   fload-dev @ I busclose  -1 +LOOP
 15 fload-2nd ! THEN ;

\ *** Block No. 13, Hexblock d

\   include                    09jun20pz

  : \ ( -- )
 blk @ IF [compile] \ exit THEN
 #tib @ >in ! ; immediate

 create >tib-orig >tib @ ,
 fib >tib !

  : interpret-via-fib
 BEGIN freadline >r  >in off
 #fib @ #tib !  interpret  r> UNTIL ;

  : include ( -- )
 blk @ Abort" no include from blk"
 bl parse  fload-open
   interpret-via-fib
 fload-close
 #tib off >in off ;







\ *** Block No. 14, Hexblock e

\ dir dos cat                  09jun20pz
| : dev fload-dev @ ;

: dir  ( -- )
   dev 0 busopen  ascii $ bus! busoff
   dev 0 busin bus@ bus@ 2drop
   BEGIN cr bus@ bus@ 2drop
   i/o-status? 0= WHILE
   bus@ bus@ lo/hi> u.
   BEGIN bus@ ?dup WHILE con! REPEAT
   REPEAT busoff  dev 0 busclose ;

: dos  ( -- )
   bl word count ?dup
      IF dev 15 busout bustype
      busoff cr ELSE drop THEN
   dev dos-error ;

: cat   ( -- ) cr
   dev 2 busopen  bl word count bustype
   busoff  i/o-status?abort
   dev 2 busin  BEGIN bus@ con!
   i/o-status? UNTIL busoff
   dev 2 busclose ;


\ *** Block No. 20, Hexblock 14

\ savesystem w/o editor        12jun20pz

| : (savsys ( adr len -- )
 [ Assembler ] Next  [ Forth ]
 ['] pause  dup push  !  \ singletask
 i/o push  i/o off  bustype ;

: savesystem   \ name must follow
    \ prepare Forth Kernal
 scr push  1 scr !  r# push  r# off
    \ now we save the system
 save
 8 2 busopen  0 parse bustype
 " ,p,w" count bustype  busoff
 8 2 busout  origin $17 -
 dup  $100 u/mod  swap bus! bus!
 here over - (savsys  busoff
 8 2 busclose
 0 (drv ! derror? abort" save-error" ;

Onlyforth





