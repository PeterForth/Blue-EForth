\ Runs on STM32
\ DUMPS INTEL HEX TO SERIAL OUT, A GOOD IDEA TO CAPTURE TO FILE ON PC
HEX
VARIABLE ADDR-OFFSET 20000000 ADDR-OFFSET ! \ USED TO 0 BASE DUMP ADDRESS
VARIABLE CS  \ CHECK SUM FOR HEX LINE

: .B ( VAL - ) \ EMITS A 2 CHARACTER HEX BYTE, LESS THEN 10 HEX HAS LEADING 0
   DUP <# # # #> TYPE  \ ASSUME BASE SET TO HEX
   CS @ + CS ! ;

\ REQUIRES SPACE CHAR FOR HANDSHAKE EACH LINE
: HEX-LINE ( ADDR CNT - ADDR' ) \ DOES 10 HEX BYTES
    CR
    BEGIN  KEY 20 = UNTIL
    3A EMIT ( : ) 0 CS !
    DUP .B  \ COUNT
    OVER ADDR-OFFSET @ - 100 /MOD .B .B
    0 .B \ TYPE OF RECORD
    1- FOR
         DUP C@ .B 1+
       NEXT
    CS @ NEGATE 0FF AND .B \ CHECK SUM
    KEY DROP ; \ HAND SHAKE

: INTHEX  ( ADDR COUNT - )
    HEX \ JUST IN CASE
    BEGIN
      DUP
    WHILE
      DUP >R  10 MIN
      HEX-LINE
      R> 10 - DUP 0 > AND  \ NEXT COUNT
    REPEAT
    DROP DROP CR
    BEGIN  KEY 20 = UNTIL
    ." :00000001FF" KEY DROP CR ;




