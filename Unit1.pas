unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    LabelTitel: TLabel;
    LabelTitel2: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  ImH,ImS:array [1..8,1..8] of TImage;
  ImP: TImage;
  i,j,x,x2: integer;


implementation

{$R *.dfm}






procedure TForm1.Button1Click(Sender: TObject);
begin
 ImP.Left := ImP.Left + 50;
end;

procedure TForm1.FormCreate(Sender: TObject);
 begin
  x := 1;
   for i := 1 to 8 do
     begin
      for j := 1 to 8 do
       begin
         //Spielfeld Eigenschaften
         //Konstruktor der Komponente aufrufen ....TEdit.Create(..)
         ImH[i,j]:=TImage.Create(Self);
         ImH[i,j].Parent := Self;
         //Eigenschaften der Komponente setzen
         //Position und Größe
         ImH[i,j].Left:=500+50*j;
         ImH[i,j].Width:=50;
         ImH[i,j].Top:=50+50*i;
         ImH[i,j].Height:=50;
         //Sichtbarkeit, ...
         ImH[i,j].Visible:=true;
         ImH[i,j].Enabled:=false;
         ImH[i,j].AutoSize:=false;
         ImH[i,j].Canvas.Brush.Style := bssolid;


         //Spielsteine Eigenschaften
         //Wann dürfen Steine erstllt werden
         if x = -1 then
         if i <> 4 then
         if i <> 5 then
         begin
         //Konstruktor der Komponente aufrufen ....TImage.Create, nicht TEdit.Create(..)
         ImS[i,j]:=TImage.Create(Self);
         ImS[i,j].Parent := Self;
         //Eigenschaften der Komponente setzen
         //Position und Größe
         ImS[i,j].Left:=500+50*j;
         ImS[i,j].Width:=50;
         ImS[i,j].Top:=50+50*i;
         ImS[i,j].Height:=50;
         //Sichtbarkeit, ...
         ImS[i,j].Visible:=true;
         ImS[i,j].Enabled:=true;
         ImS[i,j].AutoSize:=false;
         //Farbe Spielstein-Hintergrund
         ImS[i,j].Canvas.Brush.Style := bssolid;
         ImS[i,j].Canvas.Brush.Color := clMaroon;
         //Erstellen Spielstein-Hintergrund
         ImS[i,j].Transparent := true;
         ImS[i,j].Canvas.Rectangle(1,1,50,50);
         ImS[i,j].BringToFront;
         //Farbe Spielstein
         ImS[i,j].Canvas.Brush.Style := bssolid;
          ImS[i,j].Canvas.Brush.Color := clYellow;
          if i >= 6 then
          begin
          ImS[i,j].Canvas.Brush.Color := clRed;
          end;
         //Erstellen Spielsteine
         ImS[i,j].Transparent := true;
         ImS[i,j].Canvas.Ellipse(5,5,46,46);
         ImS[i,j].BringToFront;
         end;

         //Restliche Eigenschaften Spielfeld
         //Farben Spielfeld
         if x = -1 then
         begin
          ImH[i,j].Canvas.Brush.Color := clMaroon;
         end
         else
         begin
          ImH[i,j].Canvas.Brush.Color := clCream;
         end;
         //Erstellen
         ImH[i,j].Canvas.Rectangle(1,1,50,50);
         ImH[i,j].SendToBack;



         //Korrekter Zustand x Variable (bestimt Fraben und wo die Spielsteine erstellt werden.)
         x := x*-1;
       end;
       x := x*-1;
     end;



   //highlight zum feld auswählen erstellen
   //Erstes Setup, wie Feld Größe
  ImP := TImage.Create(Self);
  ImP.Parent := Self;
  ImP.AutoSize := False;
  ImP.Width := 51;
  ImP.Height := 51;
  ImP.Left := 550;
  ImP.Top := 100;
  ImP.Transparent := True;

  //Bitmap Setup
  ImP.Picture.Bitmap := TBitmap.Create;                 //Bitmap erstellen
  ImP.Picture.Bitmap.PixelFormat := pf32bit;            //Format 32 damit man trasnsparente pixel nutzen kann (gefunde auf stackoverflow)
  ImP.Picture.Bitmap.SetSize(ImP.Width, ImP.Height);    //Bitmap größe gleich der Image größe


  ImP.Picture.Bitmap.Canvas.FillRect(Rect(0,0,ImP.Width,ImP.Height)); //Rechteck
  ImP.Picture.Bitmap.Transparent := True;  //Damit man das feld halt noch sieht

  with ImP.Picture.Bitmap.Canvas do
  begin
    Pen.Color := clBlue; //Farbe
    Pen.Width := 2; //Wie breit die umrandung ist
    Brush.Style := bsClear; //Nur umrandung, bei bssolid wäre das ganze feld überdeckt
    Rectangle(1, 1, ImP.Width - 1, ImP.Height - 1); //ImP.Width/Height-1 sorgt dafür das die ecke des rechecks auf dem letzten möglichem pixel ist. in den klammern sind koordinaten wie auch sonst immer.
  end;
   ImP.BringToFront;
  end;







 //Hier Code für bewegen und rest halt.

end.
