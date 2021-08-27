myss	SEGMENT PARA STACK 'STACK'
		DW 100 DUP (?)
myss 	ENDS 

myds	SEGMENT PARA 'DATA'
CR 		EQU 13
LF 		EQU 10 		
PRTF	DB CR , LF ,' Eleman giriniz = ' , 0
PRTF1   DB CR , LF , 'Eleman Sayisini giriniz = ' , 0
HATA  	DB CR , LF , 'ERROR!! Sayi girilimedi , Yeniden eleman giriniz =  ' , 0
dizi	DB 100 DUP (?)
PRTFHATA	DB CR , LF ,'-128 ve 127 arasinda bir sayi giriniz! Yeniden ' , 0  		
PRTF2	DB ' , ' , 0

myds	ENDS 

mycs	SEGMENT PARA 'CODE'
		ASSUME CS:mycs , DS:myds , SS:myss
qsort 	PROC NEAR 				;QUICKSORT YORDAMI BASLANGICI
		CMP DL , DH
		JGE SON
		CALL prtion				
		
		 
		MOV AL , DH			;high değeri ikinci quicksort icin AL de tutulur.
		 		
		MOV DH , AH			;pi degeri ah icindedir  ve high  icine (DH) atilir.(ilk pivotun sol kısmı quicksortlanir.)
		DEC DH 				;high - 1 
		 
		PUSH AX 			;pi degeri ve high value ikinci quicksorta kadar korunmasi amaciyla AX degeri stacke atilir.
		CALL qsort			;QUICKSORT YORDAMI CAGRILIR ve ilk recursion baslar.
		POP AX  			;pi degeri ve high value ikinic quicksort yordamında kullanılmak üzere geri alinir.
		MOV DL , AH 		;korunan pi degeri low value olur.
		INC DL 				;low value bir arttırılır 
					
		MOV DH , AL 		;high value geri alinir.
		CALL qsort 			;QUICKSORT YORDAMI CAGRILIR ve ikinci recursion baslar.(ilk pivotun sag kısmı quicksortlanir.)
SON:    
		RET 
qsort	ENDP 					;QUICKSORT YORDAMI BITISI 

prtion	PROC NEAR 				;PARTITION YORDAMI BASLANGICI
		XOR BX , BX 			
		MOV BL , DH 			;high value BL ye atılır
		MOV AL , dizi[BX]		;dizi[high] AL(pivot) ye atılır.
		XOR CX , CX 			;CX SIFIRLANIR
		MOV CL , DL 			;low value CL ye atılır.
		MOV SI , CX				;low value SI (i) ye atılır.
		DEC SI 					;SI (i) bir azaltılır.
		MOV DI ,CX				;DI (j) ya cx içindeki low value atılır.
		XOR CX , CX 			;CX sıfırlanır
		MOV CL , DH 			;CL e high value atanır
		
		SUB CL , DL				;high valuedan low value çıkarılır CL içine atılır. (CX= highvalue - lowvalue)
FOR1:	
		CMP dizi[DI] , AL  		;CMP dizi[j] pivot 
		JG SON1 				;dizi[j] pivottan büyük ise son1 e git.
		INC SI 					;dizi[j] pivottan büyük değil ise kod devam eder , i bir arttırılır.
		MOV AH , dizi[SI]       ;----------------------------------------;
		XCHG dizi[DI] , AH 		;dizi[j] ve dizi[i] arasında swap yapılır;
		MOV dizi[SI] , AH 		;----------------------------------------;
		
SON1:	INC DI 					;indis j bir arttirilir.
		LOOP FOR1 
		INC SI 					;i = i+1 
		MOV BL , DH 			;high degeri BL icine atilir. Swapte kullanılma amaci ile.
		MOV AH , dizi[SI]		;---------------------------------------;
		XCHG dizi[BX] , AH 		;dizi[i+1] ile dizi[highvalue] swaplenir;
		MOV dizi[SI] , AH 		;---------------------------------------;
		MOV CX , SI 		;Pi değeri ilk CX içine atılır.
		MOV AH , CL 		;Pi değeri AH icindedir ;pi değeri CL den AH a aktarılır.
		RET 
prtion	ENDP					;PARTITION YORDAMI BITISI

ANA 	PROC FAR 				;ANA YORDAM BASLANGICI 
		;DONUS ICIN GEREKLI OLAN DEGERLER YIGINDA SAKLANIYOR
		PUSH DS 				
		XOR AX , AX 			
		PUSH AX 				
		MOV AX , myds 
		MOV DS , AX 
		;---------------------------------------------------;
		XOR SI , SI 	;
		XOR DI , DI 	;SI VE DI SIFIRLANIR
		
		MOV AX , OFFSET PRTF1 	
		CALL PUT_STR 			;PRTF1 mesaji gosterilir. 
		CALL GETN 				;Klavyeden girilen eleman AX'e alinir. (eleman sayisi)
		MOV CX , AX 			;AX te tutulan deger CX' e atanir. CX = eleman sayisi 
		PUSH CX  				;CX icindeki deger korunmak uzere stacke atilir.
		XOR BX , BX 			;BX sifirlanir.(dongu indisi 0 dan baslamali)

		
		
L1:		;L1 labeli dizi alinma dongusunun donus yeri.	
		MOV AX , OFFSET PRTF    
		CALL PUT_STR			;PRTF mesajı ekrana yazdirilir (Eleman giriniz)
		CALL GETN				;Klavyeden girilen deger AX icine alinir.
		CMP AX , -128			;Alinan deger alt siniri asiyormu diye kontrol edilir.
		JL	SNRHATA				;Asiyor ise Hata mesaji verilir.
		CMP AX , 127			;Alinan deger ust siniri asiyormu diye kontrol edilir.
		JG  SNRHATA				;Asiyor ise Hata mesaji verilir.
		JMP TRUEE 				;Herhangi gibi bir hata yok ise hata mesaji atlanir.
SNRHATA:
		MOV AX , OFFSET PRTFHATA 
		CALL PUT_STR			;SINIRLAR ile ilgili bir hata var ise gerekli hata mesaji verilir.
		JMP L1 					;Yeniden eleman alinir.

TRUEE:	MOV dizi[BX] , AL		;Girililen sayi hatali değil ise diziye yazdirilir.
		
		INC BX 					;Birdahaki elemanin dogru adrese alinmasi icin indis 1 arttirilir.
		LOOP L1 			    ;Dizi alma islemi sonlanir.
		XOR BX , BX 			;BX sifiranir
		
		XOR DL , DL  			;low degeri baslangıcta 0 olucaktir. DL = low 
		POP CX 					;Eski CX degeri stackten alinir.
		MOV DH , CL  			;CX icindeki deger (dizi uzunluğu) DH a atilir.
		DEC DH 					;High degeri baslangicta n-1 olucaktir. DH = high
		PUSH CX 				;CX icindeki deger korunmak uzere stacke atilir.
		CALL qsort 				;QUICKSORT YORDAMI CAGRILIR;
		
		
		POP CX 					;n degeri dizinin ekrana yazdirilma dongusu icin CX e geri cekilir.
		XOR BX , BX 			;BX sifirlanir. Dizi yazdirilirken ilk indis 0 olmalidir.
L2:								;EKRANA DIZI YAZDIRMA BASLANGICI
		XOR AX , AX				;AX sifirlanir.
		MOV AL , dizi[BX]		;Dizi[i] AL icine atilir.
		CBW 					;AL degeri WORD boyutuna getirili ve AX icinde saklanir.(isaretli sayiların basimi amaciyla)
		CALL PUTN				;AX degeri ekrana yazdirilir.
								
		MOV AX , OFFSET PRTF2	
		CALL PUT_STR			;Eleman aralarina virgul koyulur.
		
		INC BX 
		LOOP L2           		;Birdahaki elemanin yazdirilmasi amaci ile Dongude basa Donulur.
								;Dizi basarili bir sekilde yazdirilir.
		RETF					
ANA 	ENDP					;ANA YORDAM BITISI
		
GETC 	PROC NEAR 	;GETC YORDAMI BASLANGICI
		;Klavyeden basilan karakteri AL yazmacina alir ve ekranda gosterir .
		;islem sonucunda sadece AL etkilenir.
		MOV AH , 1h
		INT 21h
		RET 
GETC 	ENDP		;GETC YORDAMI BITISI
	
PUTC 	PROC NEAR 	;PUTC YORDAMI BASLANGICI 
		;AL yazmacindaki degeri ekrana gosterir.
		PUSH AX 
		PUSH DX 	;DL VE AH degistiginden PUSH /POP yapilir.
		MOV DL , AL 
		MOV AH , 2 
		INT 21h 
		POP DX 
		POP AX 
		RET 
PUTC 	ENDP		;PUTC YORDAMI BITISI

PUT_STR	PROC NEAR 	;PUT_STR YORDAMI BASLANGICI
		;AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazdirir.
		PUSH BX 
		MOV BX , AX 	;adresi BX ' e al.
		MOV AL , BYTE PTR[BX]	;AL2 de ilk karakter var. 
PTLOOP: CMP AL , 0 
		JE PUTFIN		;0 geldi ise dizgi sona erdi demek
		CALL PUTC 		;AL deki karakteri ekrana yazar.
		INC BX 			;bir sonraki karaktere geç.
		MOV AL , BYTE PTR [BX]
	    JMP PTLOOP		;birdahaki karakteri yazdirmaya devam.
PUTFIN: POP BX 
        RET 
PUT_STR ENDP		;PUT_STR YODAMI BITISI

GETN 	PROC NEAR 	;GETN YORDAMI BASLANGICI
		;Klavyeden basilan sayiyi okur , sonucu AX üzerinden dondurur.
		PUSH BX 
		PUSH CX 
		PUSH DX 
BEGINGETN:
		MOV DX , 1 	;sayinin pozitif oldugunu varsayalim
		XOR BX , BX ;okuma yapmadi hane 0 olur.
		XOR CX , CX ;ara toplam degeri de 0 olur.
NEW:	
		CALL GETC 	;klavyeden ilk degeri al Al' ye oku.
		CMP AL , CR 
		JE ENDED_READ ;Enter tusuna basilmis ise okuma biter. 
		CMP AL , '-'	;AL '-' mi geldi ?
		JNE CONTROL_NUM	;gelen 0-9 arasinda bir sayimi?
NEGETIVE:
		MOV DX , -1		; - basildi ise sayi negati , DX = -1
		JMP NEW 		;yeni haneyi al.
CONTROL_NUM:
		CMP AL , '0' 	;sayinin 0-9 arasinda oldugunu kontrol et.
		JB  ERR			
		CMP AL , '9'
		JA  ERR			;degil ise hata mesaji verilir.
		SUB AL , '0'	;rakam alindi  , haneyi toplama dahil et 
		MOV BL , AL 	;BL'ye okunan haneyi koy. 
		MOV AX , 10 	;Haneyi eklerken *10 yapilacak
		PUSH DX 		;MUL komutu DX i bozar  isaret icin saklanmali. 
		MUL CX 			;CX ile AX carpilir
		POP DX 			;isaret geri alinir.
		MOV CX , AX 	;CX deki ara deger *10 yapildi
		ADD CX , BX 	;okunan haneyi ara degere ekle 
		JMP NEW 		;klavyeden yeni basilan degeri al.
ERR:   
		MOV AX , OFFSET HATA
		CALL PUT_STR 		;hata mesajini goster 
		JMP BEGINGETN		;okunanları unut ve yenide sayi al 
ENDED_READ:
	    MOV AX , CX 		;sonuc AX uzerinden donucek
		CMP DX , 1 			;isarete gore sayi ayarlanmali
		JE  ENDED_GETN
		NEG AX 				;AX = -AX 
ENDED_GETN:
		POP DX 
		POP CX 
		POP BX 
		RET 
GETN 	ENDP 	;GETN YORDAMI BITISI

PUTN 	PROC NEAR 	;PUTN YORDAMI BASLANGICI 
		;AX de buluna sayiyi onluk tabanda hane hane yazdirir.
		PUSH CX 
		PUSH DX 
		XOR DX , DX 	;32 bit bolmede sonucu etkilenmemeli
		PUSH DX 		;Haneleri ASCII karakter olarak yıgında saklayacagız , kac haneyi alacagımızı
						;bilmedigimiz icin  yıgına 0 degeri koyup onu alana kadar devam edelim.
		MOV CX , 10 	
		CMP AX , 0 	
		JGE CALC_DIGITS
		NEG AX 			;sayi negatif ise AX pozitif yapilir.
		PUSH AX 		;AX SAKLANIYOR
		MOV AL , '-'	;işareti ekran yazdir.
		CALL PUTC 	
		POP AX 			;AX'i geri al .
CALC_DIGITS:
		DIV CX 			
		ADD DX , '0'	;kalan degerin ASCII olarak bul. 
		PUSH DX 		;yigina sakla 
		XOR DX , DX 	
		CMP AX , 0 		;bolen 0 kaldi ise sayini islenmedi bitti .
		JNE CALC_DIGITS
DISP_LOOP:
		POP AX 			;sırayla degerler yigindan alinir.
		CMP AX , 0 		;AX  =  0 olursa sona geldik demek .
		JE  ENDED_DISP_LOOP
		CALL PUTC 		;AL deki ASCII  degeri yazdir.
		JMP DISP_LOOP
ENDED_DISP_LOOP:
		POP DX 
		POP CX 
		RET 
PUTN 	ENDP	;PUTN YORDAMI BITISI 
		
		
		
mycs 	ENDS 	;CODE SEGMENT BITISI
		END ANA ;PROGRAMIN BITISI VE HANGI YORDAMDAN BASLANACAGI BILGISI














