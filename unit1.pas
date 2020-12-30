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
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
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
NazwaPliku = "OD_Labo_4_TEKST_ANSI.txt";

function szyfrujCezar(Przesuniecie: Integer);
var
  plikTekstowy    : File of Char;
  C : Char;
  tekst: String;
  i, indeks: integer;
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
      C := CezarAlfabet[i];
      Write(plikTekstowy, C);
    end;

   CloseFile(plikTekstowy);

   Assignfile(plikTekstowy, 'szyfrogram.txt');
   ReWrite(plikTekstowy);

   for i := 1 to dlugoscPliku do
    begin
      C := Chr(Ord(tekst[i]) xor Ord(kluczVernama[i]));
      Write(plikTekstowy, C);
    end;

   CloseFile(plikTekstowy);
   Application.MessageBox('Plik oryginal.txt został zaszyfrowany kodem Vernama', 'Zaszyfrowanie');

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Application.MessageBox('Kryptografia - Mateusz Macheta 141147, 2020/21, wydzial techniki i informatyki, semestr V','Info',MB_OK);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
i: integer;
begin
     for i:=0 to 37 do
     begin
       Memo1.Append(chr(CezarAlfabet[i]));
     end;
end;


end.

