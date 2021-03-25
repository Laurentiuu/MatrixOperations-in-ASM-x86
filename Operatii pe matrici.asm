.386
.model flat, stdcall

includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern fopen: proc
extern fclose: proc
extern fprintf: proc
extern fscanf: proc
public start

.data
s1 db 10 dup(10 dup(?))
s2 db 10  dup(10 dup (?))
s3 db 10  dup(10 dup (?))

op1 db 10,"1. A+B(Adunare)",13,10,0
op2 db "2. AB(Inmultire)",13,10,0
op3 db "3. aA(Inmultire cu scalar)",13,10,0
op4 db "4. A-B(Scadere)",13,10,13,10,0
msg1 db "Introduceti o operatie cu matrici(1-4): ",0
msg2 db 10,13,"Numarul de linii nu este egal cu numarul de coloane!!!",10,13,0
msg3 db 10,"Rezultatul se poate vedea in fisierul rezultat.txt",10,13,0
msg4 db "Matricile sunt patratice si se afla in fisierele a.txt si b.txt",10,13,0
msg5 db 10,"Introduceti scalarul: ",0
msg6 db "Numerele si rezultatul se vor afla in intervalul [-128, +127]",10,13,0
endl db 10,0
format_sp db "%d ",0
format db "%d",0
n dd ?
numar dd 0
nume1 db "a.txt",0
nume2 db "b.txt", 0
nume3 db "rezultat.txt",0
mod1 db "r",0
mod2 db "w",0
pf dd 0
i dd 0.0
j dd 0.0
lsir dd 0
aux db 0
aux1 db 0
.code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ADUNARE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
adunare proc 
	push ebp
	mov ebp, esp

;;;;;;;;;;;;;;; CITIRE MATRICE 1 DIN a.txt ;;;;;;;;;;;
	push offset mod1
	push offset nume1
	call fopen 
	add esp,8
	mov pf,eax
	
	mov esi,0
et:
	push offset numar
	push offset format
	push pf
	call fscanf 
	add esp,12
	cmp eax, -1
	jz continuare
	mov ebx, numar
	mov s1[esi], bl
	inc esi
	jmp et
continuare:
	mov i, esi
	push pf
	call fclose
	add esp, 4
;;;;;;;;;;;;;;; CITIRE MATICE 2 DIN b.txt ;;;;;;;;;;;
	
	push offset mod1
	push offset nume2
	call fopen 
	add esp,8
	mov pf,eax
	mov edi,0
et2:
	push offset numar
	push offset format
	push pf
	call fscanf 
	add esp,12
	cmp eax, -1
	jz continuare1
	mov ebx, numar
	mov s2[edi], bl
	inc edi
	jmp et2
continuare1:
	mov j, edi
	push pf
	call fclose
	add esp, 4
;;;;;;;;;;;;;;;;;;;; AFLAM NUMARUL DE LINII SI COLOANE ;;;;;;;;;;;;;
	finit 
	fild i
	fsqrt
	fst i 
	finit 
	fild j
	fsqrt
	fst j 
	mov edx,j
	cmp edx,i ; comparam doua numere intregi sa poata fi verificata conditia
	jne eroare
	
;;;;;;;;;;;;;;;;;;; CONVERTIM i SI j IN NUMERE ZECIMALE;;;;;;;;;;;;;;;
	finit 
	fld i
	fist i
	finit 
	fld j
	fist j
	
;;;;;;;;;;;;;;;;;; AUNAM MATRICILE SI LE PUNEM IN s3;;;;;;;;;;;;;;;;;;
	mov ebx,0
	mov esi,0
	mov edi,0
coloane:
linii:
	mov eax,0
	add al, s1[esi][edi]
	add al, s2[esi][edi]
	mov s3[esi][edi],al
	inc edi
	cmp edi, i
	jl linii
	inc ebx
	mov edi,0
	add esi, i
	cmp ebx,i
	jl coloane

;;;;;;;;;;;;;;; DESCHIDEM rezultat.txt SI AFISAM REZULTATUL ;;;;;;;;;;;
	push offset mod2
	push offset nume3
	call fopen
	add esp,8
	mov pf,eax
	
	mov esi,0
	mov edi,0
	mov eax,0
	mov ebx,0
coloane1:
linii1:
	movsx eax, s3[esi][edi]		;mutam in eax s3[esi][edi] cu extensie de semn
	push eax
	push offset format_sp
	push pf
	call fprintf
	add esp,12
	inc edi
	cmp edi,i
	jl linii1
	push offset endl
	push pf
	call fprintf
	add esp, 8
	inc ebx
	mov edi,0
	add esi,i
	cmp ebx,i
	jl coloane1
	
	jmp final
eroare:
	push offset msg2
	call printf
	add esp,4
	push 0
	call exit
final:

	mov esp,ebp
	pop ebp
	ret 
adunare endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INMULTIRE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inmultire proc 
	push ebp
	mov ebp, esp

;;;;;;;;;;;;;;; CITIRE MATRICE 1 DIN a.txt ;;;;;;;;;;;
	push offset mod1
	push offset nume1
	call fopen 
	add esp,8
	mov pf,eax
	
	mov esi,0
et:
	push offset numar
	push offset format
	push pf
	call fscanf 
	add esp,12
	cmp eax, -1
	jz continuare
	mov ebx, numar
	mov s1[esi], bl
	inc esi
	jmp et
continuare:
	mov i, esi
	push pf
	call fclose
	add esp, 4
;;;;;;;;;;;;;;; CITIRE MATICE 2 DIN b.txt ;;;;;;;;;;;
	
	push offset mod1
	push offset nume2
	call fopen 
	add esp,8
	mov pf,eax
	mov edi,0
et2:
	push offset numar
	push offset format
	push pf
	call fscanf 
	add esp,12
	cmp eax, -1
	jz continuare1
	mov ebx, numar
	mov s2[edi], bl
	inc edi
	jmp et2
continuare1:
	mov j, edi
	push pf
	call fclose
	add esp, 4
;;;;;;;;;;;;;;;;;;;; AFLAM NUMARUL DE LINII SI COLOANE ;;;;;;;;;;;;;
	finit 
	fild i
	fsqrt
	fst i 
	finit 
	fild j
	fsqrt
	fst j 
	mov edx,j
	cmp edx,i ; comparam doua numere intregi sa poata fi verificata conditia
	jne eroare
	
;;;;;;;;;;;;;;;;;;; CONVERTIM i SI j IN NUMERE ZECIMALE;;;;;;;;;;;;;;;
	finit 
	fld i
	fist i
	finit 
	fld j
	fist j
	
	mov eax,i
	mul i
	mov lsir,eax
	
;;;;;;;;;;;;;;;;;; INMULTIM MATRICILE SI LE PUNEM IN s3;;;;;;;;;;;;;;;;;;
	mov esi,0
	mov ebx,0
	mov eax,0
	mov ecx,0
linii:
	mov edi,0
coloane:
	mov eax,0
	mov aux,al
	mov aux1,al
inm:
									;;;; Pseudocod in C ;;;;;;;;
	mov al, s1[esi][ecx]			;for(i=0; i<3; ++i){
	mov aux,al							;for(j=0; j<3; ++j){
	mov al, s2[ebx]							;for (k = 0; k < 3; k++){
	mul aux										;aux = a[i][k]*b[k][j];
	add al, aux1								;s[i][j] = s[i][j]+aux;}
	mov aux1, al
	add ebx,i								
	inc esi							;esi=i	edi=j	ebx=k
	cmp esi, i
	jl inm					;fac operatiile
	
	mov s3[edi][ecx], al			
	inc edi
	mov esi,0
	mov ebx,0
	mov ebx,edi
	cmp edi,i
	jl coloane				;parcurg coloanele din a doua matrice
	
	
	add ecx,i
	mov ebx,0
	
	cmp ecx,lsir			;parcurg liniile din prima matrice
	jl linii

;;;;;;;;;;;;;;; DESCHIDEM rezultat.txt SI AFISAM REZULTATUL ;;;;;;;;;;;
	push offset mod2
	push offset nume3
	call fopen
	add esp,8
	mov pf,eax
	
	mov esi,0
	mov edi,0
	mov eax,0
	mov ebx,0
coloane1:
linii1:
	movsx eax, s3[esi][edi]		;mutam in eax s3[esi][edi] cu extensie de semn
	push eax
	push offset format_sp
	push pf
	call fprintf
	add esp,12
	inc edi
	cmp edi,i
	jl linii1
	push offset endl
	push pf
	call fprintf
	add esp, 8
	inc ebx
	mov edi,0
	add esi,i
	cmp ebx,i
	jl coloane1
	
	jmp final
eroare:
	push offset msg2
	call printf
	add esp,4
	push 0
	call exit
final:

	mov esp,ebp
	pop ebp
	ret 
inmultire endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INMULTIRE CU UN SCALAR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inmultire_scalar proc 
	push ebp
	mov ebp, esp

;;;;;;;;;;;;;;; CITIRE MATRICE 1 DIN a.txt ;;;;;;;;;;;
	push offset mod1
	push offset nume1
	call fopen 
	add esp,8
	mov pf,eax
	
	mov esi,0
et:
	push offset numar
	push offset format
	push pf
	call fscanf 
	add esp,12
	cmp eax, -1
	jz continuare
	mov ebx, numar
	mov s1[esi], bl
	inc esi
	jmp et
continuare:
	mov i, esi
	push pf
	call fclose
	add esp, 4
;;;;;;;;;;;;;;; CITIRE MATICE 2 DIN b.txt ;;;;;;;;;;;
	
	push offset mod1
	push offset nume2
	call fopen 
	add esp,8
	mov pf,eax
	mov edi,0
et2:
	push offset numar
	push offset format
	push pf
	call fscanf 
	add esp,12
	cmp eax, -1
	jz continuare1
	mov ebx, numar
	mov s2[edi], bl
	inc edi
	jmp et2
continuare1:
	mov j, edi
	push pf
	call fclose
	add esp, 4
;;;;;;;;;;;;;;;;;;;; AFLAM NUMARUL DE LINII SI COLOANE ;;;;;;;;;;;;;
	finit 
	fild i
	fsqrt
	fst i 
	finit 
	fild j
	fsqrt
	fst j 
	mov edx,j
	cmp edx,i ; comparam doua numere intregi sa poata fi verificata conditia
	jne eroare
	
;;;;;;;;;;;;;;;;;;; CONVERTIM i SI j IN NUMERE ZECIMALE;;;;;;;;;;;;;;;
	finit 
	fld i
	fist i
	finit 
	fld j
	fist j
	
;;;;;;;;;;;;;;;;;; INMULTIM PRIMA MATRICE CU SCALARUL SI PUNEM IN s3 REZULTATUL;;;;;;;;;;;;;;;;;;
	mov ebx,0
	mov esi,0
	mov edi,0
coloane:
linii:
	mov eax,0
	mov al, s1[esi][edi]
	mul n
	mov s3[esi][edi],al
	inc edi
	cmp edi, i
	jl linii
	inc ebx
	mov edi,0
	add esi, i
	cmp ebx,i
	jl coloane

;;;;;;;;;;;;;;; DESCHIDEM rezultat.txt SI AFISAM REZULTATUL ;;;;;;;;;;;
	push offset mod2
	push offset nume3
	call fopen
	add esp,8
	mov pf,eax
	
	mov esi,0
	mov edi,0
	mov eax,0
	mov ebx,0
coloane1:
linii1:
	movsx eax, s3[esi][edi]		;mutam in eax s3[esi][edi] cu extensie de semn
	push eax
	push offset format_sp
	push pf
	call fprintf
	add esp,12
	inc edi
	cmp edi,i
	jl linii1
	push offset endl
	push pf
	call fprintf
	add esp, 8
	inc ebx
	mov edi,0
	add esi,i
	cmp ebx,i
	jl coloane1
	
	jmp final
eroare:
	push offset msg2
	call printf
	add esp,4
	push 0
	call exit
final:

	mov esp,ebp
	pop ebp
	ret 
inmultire_scalar endp	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SCADERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scadere proc 
	push ebp
	mov ebp, esp

;;;;;;;;;;;;;;; CITIRE MATRICE 1 DIN a.txt ;;;;;;;;;;;
	push offset mod1
	push offset nume1
	call fopen 
	add esp,8
	mov pf,eax
	
	mov esi,0
et:
	push offset numar
	push offset format
	push pf
	call fscanf 
	add esp,12
	cmp eax, -1
	jz continuare
	mov ebx, numar
	mov s1[esi], bl
	inc esi
	jmp et
continuare:
	mov i, esi
	push pf
	call fclose
	add esp, 4
;;;;;;;;;;;;;;; CITIRE MATICE 2 DIN b.txt ;;;;;;;;;;;
	
	push offset mod1
	push offset nume2
	call fopen 
	add esp,8
	mov pf,eax
	mov edi,0
et2:
	push offset numar
	push offset format
	push pf
	call fscanf 
	add esp,12
	cmp eax, -1
	jz continuare1
	mov ebx, numar
	mov s2[edi], bl
	inc edi
	jmp et2
continuare1:
	mov j, edi
	push pf
	call fclose
	add esp, 4
;;;;;;;;;;;;;;;;;;;; AFLAM NUMARUL DE LINII SI COLOANE ;;;;;;;;;;;;;

	finit 
	fild i
	fsqrt
	fst i 
	finit 
	fild j
	fsqrt
	fst j 
	mov edx,j
	cmp edx,i ; comparam doua numere intregi sa poata fi verificata conditia
	jne eroare
	
;;;;;;;;;;;;;;;;;;; CONVERTIM i SI j IN NUMERE ZECIMALE ;;;;;;;;;;;;;;;
	finit 
	fld i
	fist i
	finit 
	fld j
	fist j
	
;;;;;;;;;;;;;;;;;; SCADEM MATRICILE SI LE PUNEM IN s3 ;;;;;;;;;;;;;;;;;;
	mov ebx,0
	mov esi,0
	mov edi,0
coloane:
linii:
	mov eax,0
	mov al, s1[esi][edi]
	sub al, s2[esi][edi]
	mov s3[esi][edi],al
	inc edi
	cmp edi, i
	jl linii
	inc ebx
	mov edi,0
	add esi, i
	cmp ebx,i
	jl coloane

;;;;;;;;;;;;;;; DESCHIDEM rezultat.txt SI AFISAM REZULTATUL ;;;;;;;;;;;
	push offset mod2
	push offset nume3
	call fopen
	add esp,8
	mov pf,eax
	
	mov esi,0
	mov edi,0
	mov eax,0
	mov ebx,0
coloane1:
linii1:
	movsx eax, s3[esi][edi]		;mutam in eax s3[esi][edi] cu extensie de semn
	push eax
	push offset format_sp
	push pf
	call fprintf
	add esp,12
	inc edi
	cmp edi,i
	jl linii1
	push offset endl
	push pf
	call fprintf
	add esp, 8
	inc ebx
	mov edi,0
	add esi,i
	cmp ebx,i
	jl coloane1
	
	jmp final
eroare:
	push offset msg2
	call printf
	add esp,4
	push 0
	call exit
final:

	mov esp,ebp
	pop ebp
	ret 
scadere endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAIN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start: 
	push offset msg4		
	call printf
	add esp,4
	push offset msg6	
	call printf
	add esp,4

	push offset op1		;Afisare optiuni
	call printf
	add esp,4
	push offset op2
	call printf
	add esp,4
	push offset op3
	call printf
	add esp,4
	push offset op4
	call printf
	add esp,4
	push offset msg1
	call printf
	add esp,4
	
	push offset n		;Citire optiune
	push offset format
	call scanf
	add esp,8	
	mov eax,n
	
	cmp eax,1
	je Adunare1	
	cmp eax,2
	je Inmultire1
	cmp eax,3
	je Inmultire_scalar1
	cmp eax,4
	je Scadere1
	
Adunare1:
	call adunare
	jmp gata

Inmultire1:
	call inmultire
	jmp gata
	
Inmultire_scalar1:
	push offset msg5
	call printf
	add esp,4
	push offset n		;Citire scalar
	push offset format
	call scanf
	add esp,8	
	mov eax,n
	push n
	call inmultire_scalar		;apelam functia cu parametrul n, void inmultire_scalar(int n);
	add esp, 4
	jmp gata
	
Scadere1:
	call scadere
	jmp gata
	
gata:
	push offset msg3
	call printf
	add esp,4

	push 0
	call exit
end start