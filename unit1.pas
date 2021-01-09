// Kryptografia - Mateusz Macheta 141147, 2020/21, wydzial techniki i informatyki, semestr V
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType,
  Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button_szyfrujVigenere: TButton;
    Button_deszyfrujVigenere: TButton;
    Button_deszyfrCezarMod: TButton;
    Button_szyfModCezar: TButton;
    Button_zlamCezar: TButton;
    Button_deszyfrCezar: TButton;
    Button_szyfrCezar: TButton;
    Edit_przesuniecie1: TEdit;
    Edit_przesuniecie2: TEdit;
    Edit_przesuniecie3: TEdit;
    Edit_przesuniecie4: TEdit;
    Edit_przesuniecie5: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ListBox_iloscBlokow: TListBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button_szyfrujVigenereClick(Sender: TObject);
    procedure Button_deszyfrCezarModClick(Sender: TObject);
    procedure Button_szyfModCezarClick(Sender: TObject);
    procedure Button_deszyfrCezarClick(Sender: TObject);
    procedure Button_szyfrCezarClick(Sender: TObject);
    procedure Button_zlamCezarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

Type ArrayOfByte =  Array of Byte;

const
CezarAlfabet: ArrayOfByte  = (65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 32, 44, 46, 140, 143, 163, 165, 175, 198,
202, 209, 211);
NazwaPliku = 'OD_Labo_4_TEKST_ANSI.txt';
NazwaPlikuMod = 'cezarZmodyfikowany.txt';
NazwaPlikuVinegere='vigenere.txt';

var
CezarAlfabetLen : Integer;

function znajdzIndeks(tablica: ArrayOfByte; znak: Byte) : Integer;
var
  i: integer;
begin
  i := -1;
  for i:=0 to Length(tablica) do
  begin
    if tablica[i] = znak then
       exit(i);
  end;
exit(i);
end;

function wprowadzPrzesuniecie() : Integer;
begin
  exit(StrToInt(InputBox('Podaj przesuniecie','Podaj przesuniecie' , '')));
end;

procedure szyfrujCezar(przesuniecie: Integer);
var
  plikTekstowy    : File of Char;
  C : Char;
  tekst: String;
  i, indeks, nowyIndeks, dlugoscPliku: Integer;
begin
  AssignFile(plikTekstowy, NazwaPliku);
  Reset(plikTekstowy);
  tekst := '';

   while not eof(plikTekstowy)
     do begin
       read(plikTekstowy, C);
       tekst := tekst + C;
     end;

   CloseFile(plikTekstowy);

   dlugoscPliku := Length(tekst);

   Assignfile(plikTekstowy, 'ZakodowanyCezar.txt');
   ReWrite(plikTekstowy);

   for i := 1 to dlugoscPliku do
    begin
      indeks := znajdzIndeks(CezarAlfabet,byte(tekst[i]));
      nowyIndeks := indeks+przesuniecie;
      if ( nowyIndeks >= 0) then
         C := Char(CezarAlfabet[nowyIndeks Mod CezarAlfabetLen])
      else
         C := Char(CezarAlfabet[ CezarAlfabetLen + (nowyIndeks Mod CezarAlfabetLen)]);
      Write(plikTekstowy, C);
    end;

   CloseFile(plikTekstowy);

   Application.MessageBox('Plik został zaszyfrowany kodem Cezara', 'Zaszyfrowanie');

end;

procedure deszyfrujCezar(przesuniecie: Integer);
var
  plikTekstowy    : File of Char;
  C : Char;
  tekst: String;
  i, indeks, nowyIndeks, dlugoscPliku: Integer;
begin
  AssignFile(plikTekstowy, 'ZakodowanyCezar.txt');
  Reset(plikTekstowy);
  tekst := '';

   while not eof(plikTekstowy)
     do begin
       read(plikTekstowy, C);
       tekst := tekst + C;
     end;

   CloseFile(plikTekstowy);

   dlugoscPliku := Length(tekst);

   Assignfile(plikTekstowy, 'odzyskanyCezar.txt');
   ReWrite(plikTekstowy);

   for i := 1 to dlugoscPliku do
    begin
      indeks := znajdzIndeks(CezarAlfabet,byte(tekst[i]));
      nowyIndeks := indeks+przesuniecie;
      if ( nowyIndeks >= 0) then
         C := Char(CezarAlfabet[nowyIndeks Mod CezarAlfabetLen])
      else
         C := Char(CezarAlfabet[ CezarAlfabetLen + (nowyIndeks Mod CezarAlfabetLen)]);
      Write(plikTekstowy, C);
    end;

   CloseFile(plikTekstowy);

   Application.MessageBox('Plik został odszyfrowany kodem Cezara', 'Odszyfrowanie');

end;

procedure zlamCezar;
var
plikTekstowy    : File of Char;
C : Char;
tekst, odzyskanyTekst: String;
i, przesuniecie, indeks, nowyIndeks, dlugoscPliku: integer;
begin
   AssignFile(plikTekstowy, 'ZakodowanyCezar.txt');
  Reset(plikTekstowy);
  tekst := '';
  i := 0;

   while (not eof(plikTekstowy) And (i<50))
     do begin
       read(plikTekstowy, C);
       tekst := tekst + C;
       Inc(i);
     end;

   CloseFile(plikTekstowy);

   dlugoscPliku := Length(tekst);
   for przesuniecie := 1 to CezarAlfabetLen do
    begin
      odzyskanyTekst := '';
      for i := 1 to dlugoscPliku do
      begin
        indeks := znajdzIndeks(CezarAlfabet,byte(tekst[i]));
        nowyIndeks := indeks+przesuniecie;
        if ( nowyIndeks >= 0) then
           C := Char(CezarAlfabet[nowyIndeks Mod CezarAlfabetLen])
        else
           C := Char(CezarAlfabet[ CezarAlfabetLen + (nowyIndeks Mod CezarAlfabetLen)]);
        odzyskanyTekst := odzyskanyTekst + C;
      end;
      Form1.Memo1.Append('Tekst dla przesuniecia ' + IntToStr(przesuniecie) + ': ' + odzyskanyTekst);
    end;
end;

function cezarModWprowadzKlucz : string;
var
temp, klucz: String;
i: Integer;
C: Char;
begin
  temp := InputBox('Podaj klucz','Podaj klucz' , '');
  klucz  := '';
  // usuwamy powtarzajace sie znaki
  for i:=1 to Length(temp) do
  begin
       C := temp[i];
       if (pos(C,klucz) = 0) then
          klucz := klucz + C;
  end;
  InputBox('Klucz bez powtarzajacych znakow to: ' + klucz,'Klucz' , klucz);
  exit(klucz);
end;

procedure szyfrujCezarMod(przesuniecie: Integer);
var
plikTekstowy    : File of Char;
NowyAlfabet: ArrayOfByte;
C : Char;
tekst, klucz: String;
i, j, indeks, nowyIndeks, dlugoscPliku: integer;
begin
  klucz := cezarModWprowadzKlucz();
  setLength(NowyAlfabet, CezarAlfabetLen);

  j:=0;

  // budujemy nowy alfabet - zaczynamy od slowa-klucza
  for i:=1 to Length(klucz) do
  begin
       NowyAlfabet[j] := Ord(klucz[i]);
       Inc(j);
  end;

  // uzupelniamy pozostalymi znakami - jesli znak wystepuje w kluczu to go nie
  // dodajemy
  for i:=0 to (CezarAlfabetLen-1) do
  begin
       if(pos(Char(CezarAlfabet[i]),klucz) = 0) then
          begin
            NowyAlfabet[j] := CezarAlfabet[i];
            Inc(j);
          end;
  end;

    Form1.Memo1.Append('Zmodyfikowany Cezar alfabet:');
     for i:=0 to CezarAlfabetLen do
     begin
       Form1.Memo1.Append(chr(NowyAlfabet[i]));
     end;

  AssignFile(plikTekstowy, NazwaPlikuMod);
  Reset(plikTekstowy);
  tekst := '';

   while not eof(plikTekstowy)
     do begin
       read(plikTekstowy, C);
       tekst := tekst + C;
     end;

   CloseFile(plikTekstowy);

   dlugoscPliku := Length(tekst);

   Assignfile(plikTekstowy, 'ZakodowanyCezarMod.txt');
   ReWrite(plikTekstowy);

   for i := 1 to dlugoscPliku do
    begin
      indeks := znajdzIndeks(NowyAlfabet,byte(tekst[i]));
      nowyIndeks := indeks+przesuniecie;
      if ( nowyIndeks >= 0) then
         C := Char(NowyAlfabet[nowyIndeks Mod CezarAlfabetLen])
      else
         C := Char(NowyAlfabet[ CezarAlfabetLen + (nowyIndeks Mod CezarAlfabetLen)]);
      Write(plikTekstowy, C);
    end;

   CloseFile(plikTekstowy);

   Application.MessageBox('Plik został zaszyfrowany zmodyfikowanym kodem Cezara', 'Zaszyfrowanie');

end;

procedure deszyfrujCezarMod(przesuniecie: Integer);
var
plikTekstowy    : File of Char;
NowyAlfabet: ArrayOfByte;
C : Char;
tekst, klucz: String;
i, j, indeks, nowyIndeks, dlugoscPliku: integer;
begin
  klucz := cezarModWprowadzKlucz();
  setLength(NowyAlfabet, CezarAlfabetLen);

  j:=0;

  // budujemy nowy alfabet - zaczynamy od slowa-klucza
  for i:=1 to Length(klucz) do
  begin
       NowyAlfabet[j] := Ord(klucz[i]);
       Inc(j);
  end;

  // uzupelniamy pozostalymi znakami - jesli znak wystepuje w kluczu to go nie
  // dodajemy
  for i:=0 to (CezarAlfabetLen-1) do
  begin
       if(pos(Char(CezarAlfabet[i]),klucz) = 0) then
          begin
            NowyAlfabet[j] := CezarAlfabet[i];
            Inc(j);
          end;
  end;

    Form1.Memo1.Append('Zmodyfikowany Cezar alfabet:');
     for i:=0 to CezarAlfabetLen do
     begin
       Form1.Memo1.Append(chr(NowyAlfabet[i]));
     end;

  AssignFile(plikTekstowy, 'ZakodowanyCezarMod.txt');
  Reset(plikTekstowy);
  tekst := '';

   while not eof(plikTekstowy)
     do begin
       read(plikTekstowy, C);
       tekst := tekst + C;
     end;

   CloseFile(plikTekstowy);

   dlugoscPliku := Length(tekst);

   Assignfile(plikTekstowy, 'odzyskanyCezarMod.txt');
   ReWrite(plikTekstowy);

   for i := 1 to dlugoscPliku do
    begin
      indeks := znajdzIndeks(NowyAlfabet,byte(tekst[i]));
      nowyIndeks := indeks+przesuniecie;
      if ( nowyIndeks >= 0) then
         C := Char(NowyAlfabet[nowyIndeks Mod CezarAlfabetLen])
      else
         C := Char(NowyAlfabet[ CezarAlfabetLen + (nowyIndeks Mod CezarAlfabetLen)]);
      Write(plikTekstowy, C);
    end;

   CloseFile(plikTekstowy);

   Application.MessageBox('Plik został odszyfrowany zmodyfikowanym kodem Cezara', 'Odszyfrowanie');

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Application.MessageBox('Kryptografia - Mateusz Macheta 141147, 2020/21, wydzial techniki i informatyki, semestr V','Info',MB_OK);
end;

procedure TForm1.Button_szyfrujVigenereClick(Sender: TObject);
var
plikTekstowy    : File of Char;
przesuniecia: Array of Integer;
rozmiarBloku : Integer;
C : Char;
tekst: String;
i, indeks, nowyIndeks, dlugoscPliku: integer;
begin
     rozmiarBloku:=StrToInt(ListBox_iloscBlokow.GetSelectedText);
     SetLength(przesuniecia,rozmiarBloku);
     case rozmiarBloku of
           3: begin
             przesuniecia[0] := StrToInt(Form1.Edit_przesuniecie1.Text);
             przesuniecia[1] := StrToInt(Form1.Edit_przesuniecie2.Text);
             przesuniecia[2] := StrToInt(Form1.Edit_przesuniecie3.Text);
             end;
           4: begin
             przesuniecia[0] := StrToInt(Form1.Edit_przesuniecie1.Text);
             przesuniecia[1] := StrToInt(Form1.Edit_przesuniecie2.Text);
             przesuniecia[2] := StrToInt(Form1.Edit_przesuniecie3.Text);
             przesuniecia[3] := StrToInt(Form1.Edit_przesuniecie4.Text);
             end;
           5: begin
             przesuniecia[0] := StrToInt(Form1.Edit_przesuniecie1.Text);
             przesuniecia[1] := StrToInt(Form1.Edit_przesuniecie2.Text);
             przesuniecia[2] := StrToInt(Form1.Edit_przesuniecie3.Text);
             przesuniecia[3] := StrToInt(Form1.Edit_przesuniecie4.Text);
             przesuniecia[4] := StrToInt(Form1.Edit_przesuniecie5.Text);
           end;
     end;

     AssignFile(plikTekstowy, NazwaPlikuVinegere);
     Reset(plikTekstowy);
     tekst := '';

   while not eof(plikTekstowy)
     do begin
       read(plikTekstowy, C);
       tekst := tekst + C;
     end;

   CloseFile(plikTekstowy);

   dlugoscPliku := Length(tekst);

   Assignfile(plikTekstowy, 'zaszyfrowanyVigenere.txt');
   ReWrite(plikTekstowy);

   for i := 1 to dlugoscPliku do
    begin
      indeks := znajdzIndeks(CezarAlfabet,byte(tekst[i]));
      nowyIndeks := indeks+przesuniecia[(i Mod rozmiarBloku)-1];
      if ( nowyIndeks >= 0) then
         C := Char(CezarAlfabet[nowyIndeks Mod CezarAlfabetLen])
      else
         C := Char(CezarAlfabet[ CezarAlfabetLen + (nowyIndeks Mod CezarAlfabetLen)]);
      Write(plikTekstowy, C);
    end;

   CloseFile(plikTekstowy);

   Application.MessageBox('Plik został zaszyfrowany kodem Vigenere`a', 'Odszyfrowanie');
end;

procedure TForm1.Button_deszyfrCezarModClick(Sender: TObject);
var
przesuniecie : Integer;
begin
przesuniecie := wprowadzPrzesuniecie();
  deszyfrujCezarMod(-przesuniecie);
end;

procedure TForm1.Button_szyfModCezarClick(Sender: TObject);
var
przesuniecie : Integer;
begin
  przesuniecie := wprowadzPrzesuniecie();
  szyfrujCezarMod(przesuniecie);
end;


procedure TForm1.Button_deszyfrCezarClick(Sender: TObject);
var
  przesuniecie : Integer;
begin
  przesuniecie := wprowadzPrzesuniecie();
  deszyfrujCezar(-przesuniecie);
end;

procedure TForm1.Button_szyfrCezarClick(Sender: TObject);
var
  przesuniecie : Integer;
begin
  przesuniecie := wprowadzPrzesuniecie();
  szyfrujCezar(przesuniecie);
end;

procedure TForm1.Button_zlamCezarClick(Sender: TObject);
begin
  zlamCezar();
end;

procedure TForm1.FormCreate(Sender: TObject);
var
i: integer;
begin
  CezarAlfabetLen := Length(CezarAlfabet);
  Memo1.Append('Cezar alfabet:');
     for i:=0 to CezarAlfabetLen do
     begin
       Memo1.Append(chr(CezarAlfabet[i]));
     end;
     //s := IntToStr(znajdzIndeks(CezarAlfabet,byte(',')));
     //Application.MessageBox( PChar(s),'Info',MB_OK);
end;


end.

