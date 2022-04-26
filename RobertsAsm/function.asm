.data

Params struct ;Struktura parametrow
inputData dq ? ;Wejsciowy obrazek
outputData dq ? ;Wyjsciowy obrazek
startY dd ? ;Poczatkowa wspolrzedna y
s dd ? ;Ilosc pikseli do przetworzenia
w dd ? ;Szerokosc obrazka
Params ends ;Koniec definicji struktury

.code
;Funkcje potrzebne do wygenerowania dll
DllEntry  proc hInstDll: dword, fdwReason: dword, lpReserved: dword
	mov rax, 1
	ret
DllEntry  endp

_DllMainCRTStartup proc
mov rax, 1
ret
_DllMainCRTStartup endp


robertsCross proc ;Funkcja realizujaca krzyz Robertsa
;Odloz na stos dotychczasowe wartosci rejestrow
push rbx 
push rdx 
push rsi 
push rdi  
push r9 
push r10 
push r11 
push r12 
push r13 
push r14 

mov rsi, [rcx].Params.inputData ;Wpisz adres wejsciowego obrazu do rsi
mov rdi, [rcx].Params.outputData ;Wpisz adres wyjsciowego obrazu do rsi
mov ebx, [rcx].Params.startY ;Wpisz poczatkowa wspolrzedna y do rbx
mov edx, [rcx].Params.w ;Wpisz szerokosc obrazu do rdx

xor r9, r9 ;Wyzeruj rejestr r9 (wspolrzedna x)

mainLoop: ;Glowna petla programu
;Obliczanie indeksow tablicy
mov r10, rdx ;Przenies zawartosc rdx do r10
mov r11, rbx ;Przenies rbx do r11
inc r11 ;Powieksz r11
imul r10, rbx ;Pomnoz r10 przez rbx
imul r11, rdx ;Pomnoz r11 przez rdx
add r10, r9 ;Dodaj r9 do r10 (Indeks dla piksela (x, y))
add r11, r9 ;Dodaj r9 do r11 (Indeks dla piksela (x, y + 1))
movups xmm7, [rsi][r10] ;Zaladuj 16 pikseli od piksela (x, y)
inc r11 ;Powieksz r11 o 1 (Indeks (x + 1, y + 1))
movups xmm6, [rsi][r11] ;Zaladuj 16 pikseli od piksela (x + 1, y + 1)
dec r11 ;Powroc do piksela (x, y + 1)
psubb xmm7, xmm6 ;Odejmij od siebie wartosci 16 pikseli w rejestrach xmm7 i xmm6
inc r10  ;Powieksz r10 o 1 (Indeks (x + 1, y))
movups xmm6, [rsi][r10] ;Zaladuj 16 pikseli od piksela (x + 1, y)
dec r10 ;Powroc do piksela (x, y)
movups xmm5, [rsi][r11] ;Zaladuj 16 pikseli od piksela (x, y + 1)
psubb xmm6, xmm5 ;Odejmij od siebie wartosci 16 pikseli w rejestrach xmm6 i xmm5

;Oblicz wartosci bezwgledne kazdej uzyskanej wartosci w rejestrach xmm7 i xmm6
pextrb r11, xmm7, 0;Zaladuj pierwszy bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 0 ;Zaladuj uzyskana wartosc spowrotem do xmm7
pextrb r11, xmm6, 0 ;Zaladuj pierwszy bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 0 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 1 ;Zaladuj drugi bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 1 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 1 ;Zaladuj drugi bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 1 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 2 ;Zaladuj trzeci bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 2 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 2 ;Zaladuj trzeci bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 2 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 3 ;Zaladuj czwarty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 3 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 3 ;Zaladuj czwarty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 3 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 4 ;Zaladuj piaty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 4 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 4 ;Zaladuj piaty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 4 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 5 ;Zaladuj szosty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 5 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 5 ;Zaladuj szosty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 5 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 6 ;Zaladuj siodmy bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 6 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 6 ;Zaladuj siodmy bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 6 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 7 ;Zaladuj osmy bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 7 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 7 ;Zaladuj osmy bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 7 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 8 ;Zaladuj dziewiaty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 8 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 8 ;Zaladuj dziewiaty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 8 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 9 ;Zaladuj dziesiaty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 9 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 9 ;Zaladuj dziesiaty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 9 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 10 ;Zaladuj jedenasty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 10 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 10 ;Zaladuj jedenasty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 10 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 11 ;Zaladuj dwunasty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 11 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 11 ;Zaladuj dwunasty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 11 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 12  ;Zaladuj trzynasty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 12 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 12 ;Zaladuj trzynasty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 12 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 13 ;Zaladuj czternasty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 13 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 13 ;Zaladuj czternasty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 13 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 14 ;Zaladuj pietnasty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 14 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 14 ;Zaladuj pietnasty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 14 ;Zaladuj uzyskana wartosc spowrotem do xmm6

pextrb r11, xmm7, 15 ;Zaladuj szesnasty bajt w rejestrze xmm7 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm7, r11, 15 ;Zaladuj uzyskana wartosc spowrotem do xmm6
pextrb r11, xmm6, 15 ;Zaladuj szesnasty bajt w rejestrze xmm6 do rejestru r11
mov r12, r11 ;Skopiuj zawartosc r11 do r12
sar r12b, 7 ;Przesun w prawo wartosc r12 o 7 bitow
xor r11b, r12b ;Dokonaj operacji xor na rejestrze r11 rejestrem r12
sub r11b, r12b ;Odejmij r12 od xorowanej wartosci r11, uzyskujac wartosc bezwzgledna liczby
pinsrb xmm6, r11, 15 ;Zaladuj uzyskana wartosc spowrotem do xmm6

paddb xmm7, xmm6 ;Dodaj wartosci w xmm6 do xmm7, uzyskujac nowe piksele
movups [rdi][r10], xmm7 ;Zaladuj nowe wartosci pikseli do tablicy wyjsciowej
add r9, 16 ;Dodaj 16 rejestru r9
sub [rcx].Params.s, 16 ;Pomniejsz liczbe rozpatrywanych pikseli o 16
cmp [rcx].Params.s, 0 ;Sprawdz czy jest rozmiar jest rowny zero
je exit ;Jezeli tak, to skoncz procedure
cmp r9, rdx ;Porownaj r9 z szerokoscia obrazu
jbe yIterate ;Jezeli jest wieksza lub rowna, to zwieksz wspolrzedna y
cmp [rcx].Params.s, 16 ;Porownaj liczbe pikseli do przetworzenia z liczba 16
jl innerRemainingLoop ;Jezeli jest mniejsza, to rozpatrz je po kolei
jmp mainLoop ;Zapetl

yIterate: ;Iteruj po y
inc rbx ;Powieksz wspolrzedna y
sub r9, rdx ;Uzyskaj wspolrzedna x, przez odjecie szerokosci od wpisanej wspolrzednej x
cmp [rcx].Params.s, 16 ;Porownaj liczbe pikseli do przetworzenia z liczba 16
jl innerRemainingLoop ;Jezeli jest mniejsza, to rozpatrz je po kolei
jmp mainLoop ;Zapetl

mainRemainingLoop: ;Petla do pozostalych pikseli
xor r9, r9 ;Wyzeruj wspolrzedna x

innerRemainingLoop: ;Petla wewnetrzna, po wspolrzednej x
;Oblicz indeksy pikseli
mov r10, rdx ;Przenies zawartosc rdx do r10
mov r11, rbx ;Przenies rbx do r11
inc r11 ;Powieksz r11
imul r10, rbx ;Pomnoz r10 przez rbx
imul r11, rdx ;Pomnoz r11 przez rdx
add r10, r9 ;Dodaj r9 do r10 (Indeks dla piksela (x, y))
add r11, r9 ;Dodaj r9 do r11 (Indeks dla piksela (x, y + 1))
mov r12b, byte ptr [rsi][r10] ;Wpisz do r12b piksel (x,y)
inc r11 ;Powieksz r11
mov r13b, byte ptr [rsi][r11] ;Wpisz do r14b piksel (x + 1, y + 1)
dec r11 ;Pomniejsz r11
sub r12b, r13b ;Odejmij r13b od r12b
inc r10 ;Powieksz r10
mov r13b, byte ptr [rsi][r10] ;Wpisz do r13b piksel (x + 1, y)
dec r10 ;Pomniejsz r10
mov r14b, byte ptr [rsi][r11] ;Wpisz do r14b piksel (x, y + 1)
sub r13b, r14b ;Odejmij r14b od r13b

;abs value
mov r11b, r12b ;Skopiuj zawartosc r12 do r11
sar r11b, 7 ;Przesun w prawo wartosc r11 o 7 bitow
xor r12b, r11b ;Dokonaj operacji xor na rejestrze r12 rejestrem r11
sub r12b, r11b ;Odejmij r11 od xorowanej wartosci r12, uzyskujac wartosc bezwzgledna liczby

mov r11b, r13b ;Skopiuj zawartosc r13 do r11
sar r11b, 7 ;Przesun w prawo wartosc r11 o 7 bitow
xor r13b, r11b ;Dokonaj operacji xor na rejestrze r13 rejestrem r11
sub r13b, r11b ;Odejmij r11 od xorowanej wartosci r13, uzyskujac wartosc bezwzgledna liczby

add r12b, r13b ;Dodaj r12 do r13, uzyskajac nowy piksel
mov byte ptr[rdi][r10], r12b ;Zapisz nowy piksel do tablicy wyjsciowej 
dec [rcx].Params.s ;Zmniejsz ilosc przetwarzanych pikseli
cmp [rcx].Params.s, 0 ;Porownaj ilosc przetwarzanych pikseli z 0
je exit ;Jezeli jest rowna, to skoncz funkcje
inc r9 ;Zwieksz wspolrzedna x
cmp r9, rdx ;Porownaj wspolrzedna x z szerokoscia
jl innerRemainingLoop ;Jezeli jest mniejsza, to iteruj dalej po x
inc rbx ;Zwieksz wartosc y
jmp mainRemainingLoop ;Wskocz na poczatek glownej petli

exit: ;Zdejmowanie starych wartosci rejestrow ze stosu 
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop rdi
pop rsi
pop rdx
pop rbx

ret ;Powrot z funkcji
robertsCross endp ;Koniec funkcji

end ;Koniec programu