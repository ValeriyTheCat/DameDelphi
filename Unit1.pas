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
    procedure ClickHandler(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  ImH,ImR,ImG:array [1..8,1..8] of TImage;
  ImP: TImage;
  i,j,k,x,x2: integer;


implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
 {i := 6;
 j := 1;
 ImR[i,j].Visible:=false;
 i := 5;
 j := 2;
 ImR[i,j].Visible:=true;}
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

         //Wann dürfen Steine erstllt werden
         if x = -1 then
         if i <> 4 then
         if i <> 5 then
         begin
          //Spielsteine Rot Eigenschaften

          //Konstruktor der Komponente aufrufen ....TImage.Create, nicht TEdit.Create(..)
          ImR[i,j]:=TImage.Create(Self);
          ImR[i,j].Parent := Self;
          //Eigenschaften der Komponente setzen
          //Position und Größe
          ImR[i,j].Left:=500+50*j;
          ImR[i,j].Width:=50;
          ImR[i,j].Top:=50+50*i;
          ImR[i,j].Height:=50;
          //Sichtbarkeit, ...
          ImR[i,j].Visible:=false;
          ImR[i,j].Enabled:=true;
          ImR[i,j].AutoSize:=false;
          //Farbe Spielstein-Hintergrund
          ImR[i,j].Canvas.Brush.Style := bssolid;
          ImR[i,j].Canvas.Brush.Color := clMaroon;
          //Erstellen Spielstein-Hintergrund
          ImR[i,j].Transparent := true;
          ImR[i,j].Canvas.Rectangle(1,1,50,50);
          ImR[i,j].BringToFront;
          //Farbe Spielstein
          ImR[i,j].Canvas.Brush.Style := bssolid;
           ImR[i,j].Canvas.Brush.Color := clRed;
           if i >= 6 then
           begin
            ImR[i,j].Visible:=true;
           end;
          //Erstellen Spielsteine
          ImR[i,j].Transparent := true;
          ImR[i,j].Canvas.Ellipse(5,5,46,46);
          ImR[i,j].BringToFront;
          ImR[i,j].OnClick := ClickHandler;


          //Spielsteine Gelb Eigenschaften

          //Konstruktor der Komponente aufrufen ....TImage.Create, nicht TEdit.Create(..)
          ImG[i,j]:=TImage.Create(Self);
          ImG[i,j].Parent := Self;
          //Eigenschaften der Komponente setzen
          //Position und Größe
          ImG[i,j].Left:=500+50*j;
          ImG[i,j].Width:=50;
          ImG[i,j].Top:=50+50*i;
          ImG[i,j].Height:=50;
          //Sichtbarkeit, ...
          ImG[i,j].Visible:=false;
          ImG[i,j].Enabled:=true;
          ImG[i,j].AutoSize:=false;
          //Farbe Spielstein-Hintergrund
          ImG[i,j].Canvas.Brush.Style := bssolid;
          ImG[i,j].Canvas.Brush.Color := clMaroon;
          //Erstellen Spielstein-Hintergrund
          ImG[i,j].Transparent := true;
          ImG[i,j].Canvas.Rectangle(1,1,50,50);
          ImG[i,j].BringToFront;
          //farbe Spielstein
          ImG[i,j].Canvas.Brush.Style := bssolid;
           ImG[i,j].Canvas.Brush.Color := clYellow;
           if i <= 3 then
           begin
            ImG[i,j].Visible:=true;
           end;
          //Erstellen Spielsteine
          ImG[i,j].Transparent := true;
          ImG[i,j].Canvas.Ellipse(5,5,46,46);
          ImG[i,j].BringToFront;
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
  ImP:= TImage.Create(Self);
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
 procedure TForm1.ClickHandler(Sender: TObject);
 begin
   showmessage('TEST');
 end;
end.
