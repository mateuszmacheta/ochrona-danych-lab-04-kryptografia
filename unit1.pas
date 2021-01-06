// Kryptografia - Mateusz Macheta 141147, 2020/21, wydzial techniki i informatyki, semestr V
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button_deszyfrCezar: TButton;
    Button_szyfrCezar: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button_deszyfrCezarClick(Sender: TObject);
    procedure Button_szyfrCezarClick(Sender: TObject);
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
//NazwaPliku = 'test.txt';

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

procedure TForm1.Button1Click(Sender: TObject);
begin
  Application.MessageBox('Kryptografia - Mateusz Macheta 141147, 2020/21, wydzial techniki i informatyki, semestr V','Info',MB_OK);
end;

procedure TForm1.Button_deszyfrCezarClick(Sender: TObject);
var
  przesuniecie : Integer;
begin
  przesuniecie := StrToInt(InputBox('Podaj przesuniecie','Podaj przesuniecie' , ''));
  deszyfrujCezar(przesuniecie);
end;

procedure TForm1.Button_szyfrCezarClick(Sender: TObject);
var
  przesuniecie : Integer;
begin
  przesuniecie := StrToInt(InputBox('Podaj przesuniecie','Podaj przesuniecie' , ''));
  szyfrujCezar(przesuniecie);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
i: integer;
begin
  CezarAlfabetLen := Length(CezarAlfabet);
     for i:=0 to CezarAlfabetLen do
     begin
       Memo1.Append(chr(CezarAlfabet[i]));
     end;
     //s := IntToStr(znajdzIndeks(CezarAlfabet,byte(',')));
     //Application.MessageBox( PChar(s),'Info',MB_OK);
end;


end.

