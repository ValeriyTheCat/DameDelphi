unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
    TForm1 = class(TForm)  //Form
    LabelTitel: TLabel;  //Titel "Dame"
    LabelTitel2: TLabel;  //Untertitel "von Jonas und Valerii"
    ButtonDebug: TButton; //Debug-Knopf, später löschen!!!
    procedure FormCreate(Sender: TObject);  //Zeile 46-165; Wird beim starten des Programms ausgeführt.
    procedure ButtonDebugClick(Sender: TObject);  //Zeile 37-42; Debug
    {}{}procedure ClickHandlerRot(Sender: TObject);  //Zeile X-X; Zug von Spieler Rot
    {}{}procedure ClickHandlerGelb(Sender: TObject);  //Zeile X-X; Zug von Spieler Gelb
    {}{}procedure Feldauswahl(Sender: TObject);  //Zeile X-X; Ändert Zustand der Variablen PosXStart, PosYStart, PosXZiel und PosYZiel je nach Situation.

private
 {Private-Deklarationen}
public
 {Public-Deklarationen}
end;

var  //Globale Variablen
  Form1: TForm1;  //Form
  ImH,ImSR,ImSG:array [1..8,1..8] of TImage;  //ImH(ImageHintergrund) ist das Spielfeld, ImSR(ImageSpielsteinRot) und ImSG(ImageSpielsteinGelb) sind die Spielsteine.
  ImP: TImage;  //ImP(ImagePointer ist das blaue Rechteck, was wir als Umrandung benutzen.
  i,j,k,l,MPosX,MPosY,PosXStart,PosYStart,PosXZiel,PosYZiel,ZoS: Integer;  //i,jk und l werden als flexible Variablen für Schleifen, oder als kurzzeitiger Speicher genutzt. MPosX(MausPositionX) und MPosY(MausPositionY) werden zum zwischenspeichern der Mausposition auf der X und Y Achse genutzt (X=.Left,Y=.Top). Die Variablen PosXStart(PositionXStart), PosYStart(PositionYStart), PosXZiel(PositionXZiel) und PosYZiel(PositionYZiel) werden beim bewegen der Steine als Speicher genutzt, sie bestimmen welcher Stein (PosXStart und PosYStart) wohin (PosXZiel,PosYZiel) gezogen werden soll. ZoS(ZielOderStart) hat nur die zwei Zustände 1 und 0, und wird als Zwischensspeicher im Auswahl-Prozess verwender.
  MPos: TPoint;  //MPos(MausPosition) wird genutzt um die Mausposition zwischen zu speichern.

implementation
{$R *.dfm}
//Wenn irgendwo ein {}//{} vorsteht, muss/könnte man an der jeweiligen Zeile noch arbeiten.
//Wenn irgendwo ein {}{} vorsteht, muss noch was dran ändern.

procedure TForm1.ButtonDebugClick(Sender: TObject); //Debug Knopf zum testen
 begin
  //ShowMessage('Debug: Debug');
  //ShowMessage(FloatToStr());
  //ShowMessage(IntToStr()) ;
 end;

 

procedure TForm1.FormCreate(Sender: TObject);  //Wird beim starten des Programms ausgeführt
 begin
  k := 1;  //Hier: k bestimmt, wann Spielsteine gneriert werden und wann ein Hintergrund-Feld Braun bzw. Weiss ist.
  for i := 1 to 8 do  //Schleife zum Erstellen aller Felder/Spielsteine
   begin
    for j := 1 to 8 do  //Siehe Zeile 49
     begin
      //Spielfeld Erstellen 1
      ImH[i,j]:=TImage.Create(Self);  //Erstellen
      ImH[i,j].Parent := Self;  //Erstellen
      ImH[i,j].Left:=500+50*j;  //Position auf der X-Achse, abhängig von j
      ImH[i,j].Top:=50+50*i;  //Position auf der Y-Achse, abhängig von i
      ImH[i,j].Width:=50;  //Größe
      ImH[i,j].Height:=50;  //Größe
      ImH[i,j].AutoSize:=false;  //Größe (Korrektur)
      ImH[i,j].Visible:=true;  //Hintergrund ist am Anfang sichtbar
      ImH[i,j].Enabled:=false;  //Hintergrund hat keine Funktion außer das Aussehen
      ImH[i,j].Canvas.Brush.Style := bssolid;  //Hintergrund besteht aus AUSGEFÜLLTEN(bssolid) Rechtecken

      //Spielsteine Erstellen
      if k = -1 then  //Spielsteine werden nur aúf jedem zweiten Feld erstellt. Siehe Zeile 48.
       begin
        //Spielsteine Rot
        ImSR[i,j]:=TImage.Create(Self);  //Erstellen
        ImSR[i,j].Parent := Self;  //Erstellen
        ImSR[i,j].Left:=500+50*j;  //Position auf der X-Achse, abhängig von j
        ImSR[i,j].Top:=50+50*i;  //Position auf der Y-Achse, abhängig von i
        ImSR[i,j].Width:=50;  //Größe
        ImSR[i,j].Height:=50;  //Größe
        ImSR[i,j].AutoSize:=false;  //Größe (Korrektur)
        ImSR[i,j].Visible:=false;  //Da die Spielsteine überall erstellt werden wo sie irgendwann mal seien könnten, die meisten am Start aber nicht sichtbar sind, ist .visible standardmäßig false
        ImSR[i,j].Enabled:=false;  //Da die Spielsteine überall erstellt werden wo sie irgendwann mal seien könnten, die meisten am Start aber nicht bewegbar sind, ist .enabled standardmäßig false
        ImSR[i,j].Transparent := true;  //Funktioniert sonst nicht immer.

        //Spielsteine Rot erstellen: Generell 1
        ImSR[i,j].Canvas.Brush.Style := bssolid;  //"Stil"
        //Spielsteine Rot: Hintergrund
        ImSR[i,j].Canvas.Brush.Color := clMaroon;  //Farbe Hintergrund
        ImSR[i,j].Canvas.Rectangle(1,1,50,50);  //Erstellen des Hintergrunds
        //Spielsteine Rot erstellen: Steine
        ImSR[i,j].Canvas.Brush.Color := clRed;  //Farbe Steine
        if i >= 6 then  //Am Start sollen nur die Steine in den Reihen 6, 7 und 8 sichtbar/bewegbar seien.
         begin
          ImSR[i,j].Visible:=true;  //Siehe Zeile 87
          ImSR[i,j].Enabled:=true;  //Siehe Zeile 87
         end;
        //Spielsteine Rot erstellen: Generell 2
        ImSR[i,j].Canvas.Ellipse(5,5,46,46);  //Erstellen der Steine
        ImSR[i,j].BringToFront;  //Damit die Spielsteine im Vordergrund sind.
        {}{}ImSR[i,j].OnClick:=ClickHandlerRot;  //Auswahlprozess, siehe Zeile X.

        //Spielsteine Gelb: Für Erklärung Siehe Oben "Spielsteine Rot", Zeile 68-95.
        ImSG[i,j]:=TImage.Create(Self);
        ImSG[i,j].Parent := Self;
        ImSG[i,j].Left:=500+50*j;
        ImSG[i,j].Top:=50+50*i;
        ImSG[i,j].Width:=50;
        ImSG[i,j].Height:=50;
        ImSG[i,j].AutoSize:=false;
        ImSG[i,j].Visible:=false;
        ImSG[i,j].Enabled:=false;
        ImSG[i,j].Transparent:=true;

        ImSG[i,j].Canvas.Brush.Style:=bssolid;
        ImSG[i,j].Canvas.Brush.Color:=clMaroon;
        ImSG[i,j].Canvas.Rectangle(1,1,50,50);
        ImSG[i,j].Canvas.Brush.Color:=clYellow;
        if i <= 3 then  //Am Start sollen nur die Steine in den Reihen 1, 2 und 3 sichtbar/bewegbar seien.
         begin
          ImSG[i,j].Visible:=true;  //Siehe Zeile 113
          ImSG[i,j].Enabled:=true;  //Siehe Zeile 113
         end;
        ImSG[i,j].Canvas.Ellipse(5,5,46,46);
        ImSG[i,j].BringToFront;
        {}{}ImSG[i,j].OnClick:=ClickHandlerGelb;  //Auswahlprozess, siehe Zeile X
       end;  //Bezogen auf: Spielsteine erstellen, Start bei Zeile 65

      //Spielfeld erstellen 2
      if k = -1 then //Bestimmt wann das Spielfeld mit weißer/brauner Farbe erstellt wird, siehe Zeile 48.
       begin
        ImH[i,j].Canvas.Brush.Color:=clMaroon;  //Farbe, siehe oben, Zeile 124.
       end
      else  //Bezug auf Zeile 124.
       begin
        ImH[i,j].Canvas.Brush.Color:=clCream;  //Farbe, siehe oben, Zeile 124.
       end;
      ImH[i,j].Canvas.Rectangle(1,1,50,50);  //Erstellen
      ImH[i,j].SendToBack;  //Damit das Spielfeld im Hintergrund ist.

      //Korrekter Zustand k Variable (bestimmt Farben, und wo/wann die Spielsteine erstellt werden).
      k:=k*-1;  //Siehe oben, Zeile 135
     end;
    k:=k*-1;  //Siehe oben, Zeile 135
   end;


  //Highlight zum feld auswählen erstellen
  ImP:=TImage.Create(Self);  //Erstellen
  ImP.Parent:=Self;  //Erstellen
  ImP.Width:=51;  //Größe
  ImP.Height:=51;  //Größe
  ImP.AutoSize:=False;  //Größe
  ImP.Left:=550;  //Start-Position (Oberstes Feld)
  ImP.Top:=100;  //Start-Position, siehe oben
  ImP.Transparent:=True;  //Sorgt dafür, dass man weiterhin das Spielfeld sehen kann.
  //Bitmap erstellen
  ImP.Picture.Bitmap:=TBitmap.Create;  //Erstellen
  ImP.Picture.Bitmap.PixelFormat:=pf32bit;  //Format 32 damit man trasnsparente Pixel erstellen kann. --> Gefunden durch Recherche
  ImP.Picture.Bitmap.SetSize(ImP.Width,ImP.Height);  //Bitmap Größe der Image Größe (Zeile 145-147) gleichsetzen.
  ImP.Picture.Bitmap.Canvas.FillRect(Rect(0,0,ImP.Width,ImP.Height)); //Rechteck auf der Bitmap erstellen.
  ImP.Picture.Bitmap.Transparent := True;  //Sorgt dafür, dass man weiterhin das Spielfeld sehen
  with ImP.Picture.Bitmap.Canvas do  //Eigenschaften der Bitmap deklarieren
   begin
    Pen.Color := clBlue; //Farbe
    Pen.Width := 2; //Wie breit die Umrandung ist, 2 sieht scön aus.
    Brush.Style := bsClear; //Nur Umrandung (des Rechtecks), bei "bssolid" wäre das ganze Feld bedeckt.
    Rectangle(1, 1, ImP.Width - 1, ImP.Height - 1); //Rechteck erstellen. "ImP.Widtht - 1"/"ImP.Height - 1" sorgen dafür, dass die Ecke des Rechtecks auf dem letzten sichtbaren Pixel ist.
   end;
  ImP.BringToFront;  //Sorgt dafür, dass man die Umrandung auch sehen kann (bringt die Umrandung in den Vordergrund).
 {}{}end;  //Ende der Prozedur. Start in Zeile 46.

 

{}{}procedure TForm1.Feldauswahl(Sender: TObject);  //Ändert Zustand der Variablen PosXStart, PosYStart, PosXZiel und PosYZiel je nach Situation.
 begin
  GetCursorPos(MPos);  //Speichert die aktuelle Mausposition.
  MPos := Form1.ScreenToClient(MPos);  //Sorgt dafür, das die Position realativ zum Fenster (also im selben "Koordinatensystem" wie die Komponenten) gespeichert wird.
  MPosX := MPos.X - ImP.Width div 2;  //Nicht benötigt. Sorgt halt einfach dafür, dass die angegebene Position etwas verschoben ist. Wenn man jetzt in die Mitte klickt kommen ca. die Koordinaten von .Left und .Top des angeklickten Feldes raus. "div 2" = "/2", aber das Ergebnis ist automatisch gerundet.
  MPosY  := MPos.Y - ImP.Height div 2;  //Siehe oben.
  {}//{} Setze PosXStart, PosYStart, PosXZiel und PosYZiel.
 end;

 

{}{}procedure TForm1.ClickHandlerRot(Sender: TObject);  //Genutzt in Zeile X
 begin
  ShowMessage('Klick bei Rot');
 end;

 

{}{}procedure TForm1.ClickHandlerGelb(Sender: TObject);  //Genutzt in Zeile X
 begin
  Showmessage('Klick bei Gelb');
 end;

 

end.  //Ende. (-:
