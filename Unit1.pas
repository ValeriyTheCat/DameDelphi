unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
    TForm1 = class(TForm)  //Form
    LabelTitel: TLabel;  //Titel "Dame"
    LabelTitel2: TLabel;  //Untertitel "von Jonas und Valerii"
    ButtonDebug: TButton;
    WaZLabel: TLabel;
    KnZurücksetzen: TButton; //Debug-Knopf, später löschen!!!
    {}{}procedure FormCreate(Sender: TObject);  //Zeile X-X; Wird beim starten des Programms ausgeführt.
    {}{}procedure ButtonDebugClick(Sender: TObject);  //Zeile X-X
    {}{}procedure ClickHandlerRot(Sender: TObject);  //Zeile X-X; Zug von Spieler Rot
    {}{}procedure ClickHandlerGelb(Sender: TObject);  //Zeile X-X; Zug von Spieler Gelb
    {}{}procedure ClickHandlerRotDame(Sender: TObject);  //Zeile X-X; Zug von Spieler  bei Dame
    {}{}procedure ClickHandlerGelbDame(Sender: TObject);  //Zeile X-X; Zug von Spieler Gelb bei Dame
    {}{}procedure Feldauswahl1(Sender: TObject);  //Zeile X-X; Ändert Zustand der Variablen PosXStart und PosYStart je nach Situation.
    {}{}procedure ClickHandlerElse(Sender: TObject);  //Zeile X-X; Ausführen eines Zuges (Experimentell)
    {}{}procedure Zurücksetzen(Sender: TObject);
    procedure KnZurücksetzenClick(Sender: TObject);  //Zeile X-X; Zurücksetzen von allem

private
 {Private-Deklarationen}
public
 {Public-Deklarationen}
end;

var  //Globale Variablen
 Form1: TForm1;  //Form
 ImH,ImSR,ImSG,ImSRD,ImSGD,ImSN:array [1..8,1..8] of TImage;  //ImH(ImageHintergrund) ist das Spielfeld, ImSR(ImageSpielsteinRot) und ImSG(ImageSpielsteinGelb) sind die standard Spielsteine. ImSRD/ImSGD (ImageSpielstein[Farbe]Dame) sind die umgewandelten Spielsteine. ImSN(ImageSpielsteinNichts) wird als klickbare Oberfläche zum ziehen von Spielsteinen verwendet.
 ImP,ImP2: TImage;  //ImP(ImagePointer ist das blaue Rechteck, was wir als Umrandung benutzen.
 i,j,k,l,m,MPosX,MPosY,PosXStart,PosYStart,PosXZiel,PosYZiel,WaZ,AZA,SZ,DZ: Integer;  //i,j,k,l und m werden als flexible Variablen für Schleifen, oder als kurzzeitiger Speicher genutzt. MPosX(MausPositionX) und MPosY(MausPositionY) werden zum zwischenspeichern der Mausposition auf der X und Y Achse genutzt (X=.Left,Y=.Top). Die Variablen PosXStart(PositionXStart), PosYStart(PositionYStart), PosXZiel(PositionXZiel) und PosYZiel(PositionYZiel) werden beim bewegen der Steine als Speicher genutzt, sie bestimmen welcher Stein (PosXStart und PosYStart) wohin (PosXZiel,PosYZiel) gezogen werden soll. WaZ(WerAmZug) hat nur die zwei Zustände 1 und -1, und wird als Zwischensspeicher im Auswahl-Prozess verwendet. AZA(AuswahlZugAuswahl) bestimmt den Zeitpunkt des Zugprozesses, beim ersten Klick ist AZA = 1, beim zweiten ist AZA = -1. Sz(Szenario) wird ab und zu als flexible Variable genutzt. DZ(DamenZug)wird genutz, um zu bestimmen welche Art von Spielstein Am Zug ist.
 MPos: TPoint;  //MPos(MausPosition) wird genutzt um die Mausposition zwischen zu speichern.

 //x: extended;

implementation
{$R *.dfm}
//Wenn irgendwo ein {}//{} vorsteht, muss/könnte man an der jeweiligen Zeile noch arbeiten.
//Wenn irgendwo ein {}{} vorsteht, muss am Ende dort noch die Zeilenangabe eingetragen werden.

procedure TForm1.ButtonDebugClick(Sender: TObject); //Debug Knopf zum testen
 begin
  //ShowMessage('Debug: Debug');
  //ShowMessage(FloatToStr(x));
  //ShowMessage(IntToStr(l)) ;
  ImSRD[4,1].Visible:=true;
  ImSRD[4,1].BringToFront;
 end;



procedure TForm1.FormCreate(Sender: TObject);  //Wird beim starten des Programms ausgeführt
 begin
  //ButtonDebug.Visible:=false;  //Wird später entfernt
  //ButtonDebug.Enabled:=false;  //Wird später entfernt
  AZA:=1;  //Wichtig für später.
  WaZ:=1;  //Rot wird zuerst ziehen.
  k := 1;  //Hier: k bestimmt, wann Spielsteine gneriert werden und wann ein Hintergrund-Feld Braun bzw. Weiss ist.
  for i := 1 to 8 do  //Schleife zum Erstellen aller Felder/Spielsteine
   begin
 {}{}   for j := 1 to 8 do  //Siehe Zeile X
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
{}{}      if k = -1 then  //Spielsteine werden nur aúf jedem zweiten Feld erstellt. Siehe Zeile X.
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
 {}{}         ImSR[i,j].Visible:=true;  //Siehe Zeile X
 {}{}         ImSR[i,j].Enabled:=true;  //Siehe Zeile X
         end;
        //Spielsteine Rot erstellen: Generell 2
        ImSR[i,j].Canvas.Ellipse(5,5,46,46);  //Erstellen der Steine
        ImSR[i,j].BringToFront;  //Damit die Spielsteine im Vordergrund sind.
{}{}        ImSR[i,j].OnClick:=ClickHandlerRot;  //Auswahlprozess, siehe Zeile X.

{}{}        //Spielsteine Gelb: Für Erklärung Siehe Oben "Spielsteine Rot", Zeile X-X.
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
{}{}          ImSG[i,j].Visible:=true;  //Siehe Zeile X
{}{}          ImSG[i,j].Enabled:=true;  //Siehe Zeile X
         end;
        ImSG[i,j].Canvas.Ellipse(5,5,46,46);
        ImSG[i,j].BringToFront;
{}{}        ImSG[i,j].OnClick:=ClickHandlerGelb;  //Auswahlprozess, siehe Zeile X


        //Das gleiche noch zweimal für die Spielsteine als Dame
        //Rote Damen
        ImSRD[i,j]:=TImage.Create(Self);
        ImSRD[i,j].Parent := Self;
        ImSRD[i,j].Left:=500+50*j;
        ImSRD[i,j].Top:=50+50*i;
        ImSRD[i,j].Width:=50;
        ImSRD[i,j].Height:=50;
        ImSRD[i,j].AutoSize:=false;
        ImSRD[i,j].Visible:=false;
        ImSRD[i,j].Enabled:=false;
        ImSRD[i,j].Transparent:=true;

        ImSRD[i,j].Canvas.Brush.Style:=bssolid;
        ImSRD[i,j].Canvas.Brush.Color:=clMaroon;
        ImSRD[i,j].Canvas.Rectangle(1,1,50,50);
        ImSRD[i,j].Canvas.Brush.Color:=clRed;
        ImSRD[i,j].Canvas.Ellipse(5,5,46,46);
        ImSRD[i,j].Canvas.Rectangle(20,20,31,31);
        ImSRD[i,j].SendToBack;
{}{}        ImSRD[i,j].OnClick:=ClickHandlerRotDame;  //Auswahlprozess, siehe Zeile X

        //Gelbe Damen
        ImSGD[i,j]:=TImage.Create(Self);
        ImSGD[i,j].Parent := Self;
        ImSGD[i,j].Left:=500+50*j;
        ImSGD[i,j].Top:=50+50*i;
        ImSGD[i,j].Width:=50;
        ImSGD[i,j].Height:=50;
        ImSGD[i,j].AutoSize:=false;
        ImSGD[i,j].Visible:=false;
        ImSGD[i,j].Enabled:=false;
        ImSGD[i,j].Transparent:=true;

        ImSGD[i,j].Canvas.Brush.Style:=bssolid;
        ImSGD[i,j].Canvas.Brush.Color:=clMaroon;
        ImSGD[i,j].Canvas.Rectangle(1,1,50,50);
        ImSGD[i,j].Canvas.Brush.Color:=clYellow;
        ImSGD[i,j].Canvas.Ellipse(5,5,46,46);
        ImSGD[i,j].Canvas.Rectangle(20,20,31,31);
        ImSGD[i,j].SendToBack;
{}{}        ImSGD[i,j].OnClick:=ClickHandlerGelbDame;  //Auswahlprozess, siehe Zeile X



        //Oberfläche zum Ziehen erstellen
        ImSN[i,j]:=TImage.Create(Self);  //
        ImSN[i,j].Parent := Self;  //
        ImSN[i,j].Left:=500+50*j;  //
        ImSN[i,j].Top:=50+50*i;  //
        ImSN[i,j].Width:=50;  //
        ImSN[i,j].Height:=50;  //
        ImSN[i,j].AutoSize:=false;  //
        ImSN[i,j].Visible:=false;  //
        ImSN[i,j].Enabled:=false;  //
        ImSN[i,j].Transparent:=true;  //
        ImSN[i,j].Canvas.Brush.Style:=bssolid;  //Sieht aus wie ein leeres Feld.
        ImSN[i,j].Canvas.Brush.Color:=clMaroon;  //Siehe oben
        ImSN[i,j].Canvas.Rectangle(1,1,50,50);  //Siehe oben
        if i > 3 then  //Am Start sollen nur die Steine in den Reihen 4 und 5 leer seien.
         begin
          if i < 6 then
           begin
{}{}          ImSN[i,j].Visible:=true;  //Siehe Zeile X
{}{}          ImSN[i,j].Enabled:=true;  //Siehe Zeile X
              ImSN[i,j].BringToFront;   //Siehe Zeile X
           end;
         end;
{}{}        ImSN[i,j].OnClick:=ClickHandlerElse;  //Auswahlprozess, siehe Zeile X

{}{}       end;  //Bezogen auf: Spielsteine erstellen, Start bei Zeile X

      //Spielfeld erstellen 2
      if k = -1 then //Bestimmt wann das Spielfeld mit weißer/brauner Farbe erstellt wird, siehe Zeile 48.
       begin
{}{}        ImH[i,j].Canvas.Brush.Color:=clMaroon;  //Farbe, siehe oben, Zeile X.
       end
{}{}      else  //Bezug auf Zeile X.
       begin
{}{}        ImH[i,j].Canvas.Brush.Color:=clCream;  //Farbe, siehe oben, Zeile X.
       end;
      ImH[i,j].Canvas.Rectangle(1,1,50,50);  //Erstellen
      ImH[i,j].SendToBack;  //Damit das Spielfeld im Hintergrund ist.

      //Korrekter Zustand k Variable (bestimmt Farben, und wo/wann die Spielsteine erstellt werden).
      k:=k*-1;  //Siehe oben
     end;
    k:=k*-1;  //Siehe oben
   end;


  //Highlights zum feld auswählen erstellen
  ImP:=TImage.Create(Self);  //Erstellen
  ImP.Parent:=Self;  //Erstellen
  ImP.Width:=51;  //Größe
  ImP.Height:=51;  //Größe
  ImP.AutoSize:=False;  //Größe
  ImP.Left:=-100;  //Start-Position
  ImP.Top:=100;  //Start-Position
  ImP.Transparent:=True;  //Sorgt dafür, dass man weiterhin das Spielfeld sehen kann.
  //Bitmap erstellen
  ImP.Picture.Bitmap:=TBitmap.Create;  //Erstellen
  ImP.Picture.Bitmap.PixelFormat:=pf32bit;  //Format 32 damit man trasnsparente Pixel erstellen kann. --> Gefunden durch Recherche
{}{}  ImP.Picture.Bitmap.SetSize(ImP.Width,ImP.Height);  //Bitmap Größe der Image Größe (Zeile X-X) gleichsetzen.
  ImP.Picture.Bitmap.Canvas.FillRect(Rect(0,0,ImP.Width,ImP.Height)); //Rechteck auf der Bitmap erstellen.
  ImP.Picture.Bitmap.Transparent := True;  //Sorgt dafür, dass man weiterhin das Spielfeld sehen
  with ImP.Picture.Bitmap.Canvas do  //Eigenschaften der Bitmap deklarieren
   begin
    Pen.Color := clBlue; //Farbe
    Pen.Width := 2; //Wie breit die Umrandung ist, 2 sieht schön aus.
    Brush.Style := bsClear; //Nur Umrandung (des Rechtecks), bei "bssolid" wäre das ganze Feld bedeckt.
    Rectangle(1, 1, ImP.Width - 1, ImP.Height - 1); //Rechteck erstellen. "ImP.Widtht - 1"/"ImP.Height - 1" sorgen dafür, dass die Ecke des Rechtecks auf dem letzten sichtbaren Pixel ist.
   end;
  ImP.BringToFront;  //Sorgt dafür, dass man die Umrandung auch sehen kann (bringt die Umrandung in den Vordergrund).

  //Zweites Highlight
  ImP2:=TImage.Create(Self);  //Erstellen
  ImP2.Parent:=Self;  //Erstellen
  ImP2.Width:=51;  //Größe
  ImP2.Height:=51;  //Größe
  ImP2.AutoSize:=False;  //Größe
  ImP2.Left:=-100;  //Start-Position
  ImP2.Top:=100;  //Start-Position
  ImP2.Transparent:=True;  //Sorgt dafür, dass man weiterhin das Spielfeld sehen kann.
  //Bitmap erstellen
  ImP2.Picture.Bitmap:=TBitmap.Create;  //Erstellen
  ImP2.Picture.Bitmap.PixelFormat:=pf32bit;  //Format 32 damit man trasnsparente Pixel erstellen kann. --> Gefunden durch Recherche
  ImP2.Picture.Bitmap.SetSize(ImP2.Width,ImP2.Height);  //Bitmap Größe der Image Größe gleichsetzen.
  ImP2.Picture.Bitmap.Canvas.FillRect(Rect(0,0,ImP2.Width,ImP2.Height)); //Rechteck auf der Bitmap erstellen.
  ImP2.Picture.Bitmap.Transparent := True;  //Sorgt dafür, dass man weiterhin das Spielfeld sehen
  with ImP2.Picture.Bitmap.Canvas do  //Eigenschaften der Bitmap deklarieren
   begin
    Pen.Color := clgreen; //Farbe
    Pen.Width := 2; //Wie breit die Umrandung ist, 2 sieht schön aus.
    Brush.Style := bsClear; //Nur Umrandung (des Rechtecks), bei "bssolid" wäre das ganze Feld bedeckt.
    Rectangle(1, 1, ImP2.Width - 1, ImP2.Height - 1); //Rechteck erstellen. "ImP.Widtht - 1"/"ImP.Height - 1" sorgen dafür, dass die Ecke des Rechtecks auf dem letzten sichtbaren Pixel ist.
   end;
  ImP2.BringToFront;  //Sorgt dafür, dass man die Umrandung auch sehen kann (bringt die Umrandung in den Vordergrund).

 end;  //Ende der Prozedur. Start in Zeile X.



procedure TForm1.KnZurücksetzenClick(Sender: TObject);
 begin

  if MessageDlg('Willst du das Feld Zurücksetzen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Zurücksetzen(Self);
  end;
 end;



procedure TForm1.Feldauswahl1(Sender: TObject);  //Ändert Zustand der Variablen PosXStart und PosYStart je nach Situation.
 begin
  GetCursorPos(MPos);  //Speichert die aktuelle Mausposition.
  MPos := Form1.ScreenToClient(MPos);  //Sorgt dafür, das die Position realativ zum Fenster (also im selben "Koordinatensystem" wie die Komponenten) gespeichert wird.
  MPosX := MPos.X - ImP.Width div 2;  //Nicht benötigt. Sorgt halt einfach dafür, dass die angegebene Position etwas verschoben ist. Wenn man jetzt in die Mitte klickt kommen ca. die Koordinaten von .Left und .Top des angeklickten Feldes raus. "div 2" = "/2", aber das Ergebnis ist automatisch gerundet.
  MPosY  := MPos.Y - ImP.Height div 2;  //Siehe oben.

  //Setze PosXStart
  i:=0;  //Reset für Schleife
  PosXStart:=-1;  //Darf nicht i seien, muss unter 0 oder über 7 seien.
  k:=475;  //StartPosition1 zum Überprüfen - 50
  l:=525;  //StartPosition2 zum Überprüfen - 50
  while PosXStart <> i do
   begin
    k:=k+50;  //zu überprüfende Position
    l:=l+50;  //zu überprüfende Position
    i:=i+1;   //Aktuelle Reihe
    if MPosX > k then  //PositionTest1
     begin
      if MPosX < l then  //PositionTest1
       begin
        PosXStart:=i;  //Beendet Schleife und setzt Position.
        ImP.Left:=k+25;  //Setzt die Position vom Pointer.
       end;
     end;
   end;

  //Setze PosYStart
  i:=0;  //Reset für Schleife
  PosYStart:=-1;  //Darf nicht i seien, muss unter 0 oder über 7 seien.
  k:=25;  //StartPosition1 zum Überprüfen - 50
  l:=75;  //StartPosition2 zum Überprüfen - 50
  while PosYStart <> i do
   begin
    k:=k+50;  //zu überprüfende Position
    l:=l+50;  //zu überprüfende Position
    i:=i+1;   //Aktuelle Reihe
    if MPosY > k then  //PositionTest1
     begin
      if MPosY < l then  //PositionTest1
       begin
        PosYStart:=i;  //Beendet Schleife und setzt Position.
        ImP.Top:=k+25;  //Setzt die Position vom Pointer.
       end;
     end;
   end;
  ImP2.Left:=-100;  //Wir brauchen den zweiten Pointer gerade nicht.
 end;



{}{}procedure TForm1.ClickHandlerRot(Sender: TObject);  //Genutzt in Zeile X
 begin
  if WaZ = 1 then  //Wird nur ausgeführt wenn Rot auch am Zug ist.
   begin
    if AZA = 1 then  //Wird nur ausgefüht, wenn zuvor noch kein Stein ausgewählt wurde.
     begin
{}{}      Feldauswahl1(Self);  //Wählt Feld aus. Siehe Zeile X.
      DZ:=-1;  //Es zieht keine Dame
     end
    else
     begin
      ShowMessage('Da kannst du nicht hinziehen!');  //Wenn bereits ein Stein ausgewählt wurde, kann kein neuer ausgewählt werden. Wenn dieser Fall eintritt, versucht der Nutzer einen Stein auf einen anderen Stein zu ziehen, was nicht geht.
      ImP.Left:=-100;  //In dem oben genannten Fall werden Pointer weggenommen.
      ImP2.Left:=-100;  //
     end;
{}{}    AZA:=AZA*-1;  //Stein wurde ausgewählt. Jetzt darf die Prozedur "Feldauswahl2" in Zeile X ausgeführt werden.
   end
  else
   begin
{}{}    ShowMessage('Illegaler Zug!');  //"else" bezieht sich auf Zeile X. Wird ausgeführt wenn Rot nicht am Zug ist.
    AZA:=1;  //Fehlervorbeugung.
    ImP.Left:=-100;  //Da der Zug abgebrochen wurde, werden die Pointer "entfernt".
    ImP2.Left:=-100;
   end;
 end;



{}{}procedure TForm1.ClickHandlerGelb(Sender: TObject);  //Genutzt in Zeile X. Nahezu gleich "ClickHandlerRot", Zeile X.
 begin
  if WaZ = -1 then
   begin
    if AZA = 1 then
     begin
      Feldauswahl1(Self);
      DZ:=-1;
     end
    else
     begin
      ShowMessage('Da kannst du nicht hinziehen!');
      ImP.Left:=-100;
      ImP2.Left:=-100;
     end;
    AZA:=AZA*-1;
   end
  else
   begin
    ShowMessage('Illegaler Zug!');
    AZA:=1;
    ImP.Left:=-100;
    ImP2.Left:=-100;
   end;
 end;



{}{}procedure TForm1.ClickHandlerRotDame(Sender: TObject);  //Genutzt in Zeile X. Nahezu gleich "ClickHandlerRot", Zeile X.
 begin
  if WaZ = 1 then
   begin
    if AZA = 1 then
     begin
      Feldauswahl1(Self);
      DZ:=1;
     end
    else
     begin
      ShowMessage('Da kannst du nicht hinziehen!');
      ImP.Left:=-100;
      ImP2.Left:=-100;
     end;
    AZA:=AZA*-1;
   end
  else
   begin
    ShowMessage('Illegaler Zug!');
    AZA:=1;
    ImP.Left:=-100;
    ImP2.Left:=-100;
   end;
 end;



{}{}procedure TForm1.ClickHandlerGelbDame(Sender: TObject);  //Genutzt in Zeile X. Nahezu gleich "ClickHandlerRot", Zeile X.
 begin
  if WaZ = -1 then
   begin
    if AZA = 1 then
     begin
      Feldauswahl1(Self);
      DZ:=1;
     end
    else
     begin
      ShowMessage('Da kannst du nicht hinziehen!');
      ImP.Left:=-100;
      ImP2.Left:=-100;
     end;
    AZA:=AZA*-1;
   end
  else
   begin
    ShowMessage('Illegaler Zug!');
    AZA:=1;
    ImP.Left:=-100;
    ImP2.Left:=-100;
   end;
 end;



procedure TForm1.ClickHandlerElse(Sender: TObject);  //Wird im zweiten Schritt eines Zuges ausgeführt, d.h. wenn man ein leeres Feld anklickt, nachdem man einen Stein ausgewählt hat.
 begin
  if AZA = -1 then  //Bedingung, siehe oben
   begin
    GetCursorPos(MPos);  //Speichert die aktuelle Mausposition.
    MPos := Form1.ScreenToClient(MPos);  //Sorgt dafür, das die Position realativ zum Fenster (also im selben "Koordinatensystem" wie die Komponenten) gespeichert wird.
    MPosX := MPos.X - ImP2.Width div 2;  //Nicht benötigt. Sorgt halt einfach dafür, dass die angegebene Position etwas verschoben ist. Wenn man jetzt in die Mitte klickt kommen ca. die Koordinaten von .Left und .Top des angeklickten Feldes raus. "div 2" = "/2", aber das Ergebnis ist automatisch gerundet.
    MPosY  := MPos.Y - ImP2.Height div 2;  //Siehe oben.

    //Setze PosXZiel
    i:=0;  //Reset für Schleife
    PosXZiel:=-1;  //Darf nicht i seien, muss unter 0 oder über 7 seien.
    k:=475;  //StartPosition1 zum Überprüfen - 50
    l:=525;  //StartPosition2 zum Überprüfen - 50
    while PosXZiel <> i do
     begin
      k:=k+50;  //zu überprüfende Position
      l:=l+50;  //zu überprüfende Position
      i:=i+1;   //Aktuelle Reihe
      if MPosX > k then  //PositionTest1
       begin
        if MPosX < l then  //PositionTest1
         begin
          PosXZiel:=i;  //Beendet Schleife und setzt Position.
          ImP2.Left:=k+25;  //Setzt die Position vom Pointer.
         end;
       end;
     end;

    //Setze PosYZiel
    i:=0;  //Reset für Schleife
    PosYZiel:=-1;  //Darf nicht i seien, muss unter 0 oder über 7 seien.
    k:=25;  //StartPosition1 zum Überprüfen - 50
    l:=75;  //StartPosition2 zum Überprüfen - 50
    while PosYZiel <> i do
     begin
      k:=k+50;  //zu überprüfende Position
      l:=l+50;  //zu überprüfende Position
      i:=i+1;   //Aktuelle Reihe
      if MPosY > k then  //PositionTest1
       begin
        if MPosY < l then  //PositionTest1
         begin
          PosYZiel:=i;  //Beendet Schleife und setzt Position.
          ImP2.Top:=k+25;  //Setzt die Position vom Pointer.
         end;
       end;
     end;


    //Überprüfung ob Zug legal (Normaler Zug, schlagen, Kette, Zug als Dame, Kette-Dame/Schlage-Dame)
    SZ:=0;  //Korrekter Start-Zustand. Hier: SZ wird genutzt um festzulegen, ob der Zug legal ist (0=Illegal, 1=legal)
    k:=0;  //Fehlerprevention. Nur existierende Felder können bearbeitet werden.
    //Wenn;
    if WaZ = 1 then  //rot,
     begin
      if DZ = -1 then  //keine Dame,
       begin
        if PosYZiel = (PosYStart - 1) then  //einen normaler Zug
         begin
          if (PosXZiel - PosXStart)*(-(PosXZiel - PosXStart)) = -1 then  //Nach rechts oder links (Wenn z.B. von X6 nach X5, dann (6-5)*-(6-5)=1*-1=-1, wenn z.B. von X5 nach X6 dann (5-6)*-(5-6)=-1*-(-1)=-1*1=-1)
           begin
            SZ:=1;  //Zug ist legal

            //Konnte schlagen?
           



           end;
         end
        else
         begin //einen Stein schlägt
          if PosYZiel = (PosYStart - 2) then  //Überprüfen, ob Zug legal seien könnte
           begin
            if PosXZiel = (PosXStart + 2) then  //Schlagen rechts
             begin
              if ImSG[(PosYZiel + 1),(PosXStart + 1)].Enabled = true then  //Überprüfung, ob da auch ein Schlagbarer Stein war.
               begin
                SZ:=1;  //Zug legal
                ImSG[(PosYZiel + 1),(PosXStart + 1)].Enabled:=false;  //Leeren des Feldes, wo der geschlagene Stein ist
                ImSG[(PosYZiel + 1),(PosXStart + 1)].Visible:=false;  //Siehe oben
                ImSG[(PosYZiel + 1),(PosXStart + 1)].SendToBack;  //Siehe oben
                ImSN[(PosYZiel + 1),(PosXStart + 1)].Enabled:=true;  //Siehe oben
                ImSN[(PosYZiel + 1),(PosXStart + 1)].Visible:=true;  //Siehe oben
                ImSN[(PosYZiel + 1),(PosXStart + 1)].BringToFront;  //Siehe oben
               end
              else if ImSGD[(PosYZiel + 1),(PosXStart + 1)].Enabled = true then  //Es kann auch seien, dass eine Dame geschlagen wird.
               begin
                SZ:=1;
                ImSGD[(PosYZiel + 1),(PosXStart + 1)].Enabled:=false;
                ImSGD[(PosYZiel + 1),(PosXStart + 1)].Visible:=false;
                ImSGD[(PosYZiel + 1),(PosXStart + 1)].SendToBack;
                ImSN[(PosYZiel + 1),(PosXStart + 1)].Enabled:=true;
                ImSN[(PosYZiel + 1),(PosXStart + 1)].Visible:=true;
                ImSN[(PosYZiel + 1),(PosXStart + 1)].BringToFront;
               end;
             end
            else if PosXZiel = (PosXStart - 2) then  //Siehe oben (Schlagen links, gleich wie schlagen rechts nur Vorzeichen anders)
             begin
              if ImSG[(PosYZiel + 1),(PosXStart - 1)].Enabled = true then
               begin
                SZ:=1;
                ImSG[(PosYZiel + 1),(PosXStart - 1)].Enabled:=false;
                ImSG[(PosYZiel + 1),(PosXStart - 1)].Visible:=false;
                ImSG[(PosYZiel + 1),(PosXStart - 1)].SendToBack;
                ImSN[(PosYZiel + 1),(PosXStart - 1)].Enabled:=true;
                ImSN[(PosYZiel + 1),(PosXStart - 1)].Visible:=true;
                ImSN[(PosYZiel + 1),(PosXStart - 1)].BringToFront;
               end
              else if ImSGD[(PosYZiel + 1),(PosXStart - 1)].Enabled = true then
               begin
                SZ:=1;
                ImSGD[(PosYZiel + 1),(PosXStart - 1)].Enabled:=false;
                ImSGD[(PosYZiel + 1),(PosXStart - 1)].Visible:=false;
                ImSGD[(PosYZiel + 1),(PosXStart - 1)].SendToBack;
                ImSN[(PosYZiel + 1),(PosXStart - 1)].Enabled:=true;
                ImSN[(PosYZiel + 1),(PosXStart - 1)].Visible:=true;
                ImSN[(PosYZiel + 1),(PosXStart - 1)].BringToFront;
               end;
             end;
           end;
         end;
       end
      else
       begin  //Wenn eine (rote) Dame zieht
        if (PosYZiel - PosYStart)*(-(PosYZiel - PosYStart)) = -1 then
         begin  //Zug Normal (Dame, also Zug Logik vom normale ziehen + rückwärts, was nur eine Vorzeichen Änderung ist.)
          if (PosXZiel - PosXStart)*(-(PosXZiel - PosXStart)) = -1 then
           begin
            SZ:=1;
           end;
         end  //Schlagen dame rot
        else if PosYZiel - PosYStart = 2 then
         begin
          if PosXZiel - PosXStart = 2 then
           begin  //case unten rechts (Dame schlägt nach unten rechts), eigentlich sowie schlagen bei einem normalen Stein mit geänderten Vorzeichen
            if ImSG[(PosYZiel - 1),(PosXZiel - 1)].Enabled = true then
             begin
              SZ:=1;
              ImSG[(PosYZiel - 1),(PosXZiel - 1)].Enabled:=false;
              ImSG[(PosYZiel - 1),(PosXZiel - 1)].Visible:=false;
              ImSG[(PosYZiel - 1),(PosXZiel - 1)].SendToBack;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].Enabled:=true;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].Visible:=true;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].BringToFront;
             end
            else if ImSGD[(PosYZiel - 1),(PosXZiel - 1)].Enabled = true then
             begin
              SZ:=1;
              ImSGD[(PosYZiel - 1),(PosXZiel - 1)].Enabled:=false;
              ImSGD[(PosYZiel - 1),(PosXZiel - 1)].Visible:=false;
              ImSGD[(PosYZiel - 1),(PosXZiel - 1)].SendToBack;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].Enabled:=true;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].Visible:=true;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].BringToFront;
             end;
           end
          else if PosXZiel - PosXStart = -2 then
           begin  //case unten links (Dame schlägt nach unten links)
            if ImSG[(PosYZiel - 1),(PosXZiel + 1)].Enabled = true then
             begin
              SZ:=1;
              ImSG[(PosYZiel - 1),(PosXZiel + 1)].Enabled:=false;
              ImSG[(PosYZiel - 1),(PosXZiel + 1)].Visible:=false;
              ImSG[(PosYZiel - 1),(PosXZiel + 1)].SendToBack;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].Enabled:=true;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].Visible:=true;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].BringToFront;
             end
            else if ImSGD[(PosYZiel - 1),(PosXZiel + 1)].Enabled = true then
             begin
              SZ:=1;
              ImSGD[(PosYZiel - 1),(PosXZiel + 1)].Enabled:=false;
              ImSGD[(PosYZiel - 1),(PosXZiel + 1)].Visible:=false;
              ImSGD[(PosYZiel - 1),(PosXZiel + 1)].SendToBack;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].Enabled:=true;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].Visible:=true;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].BringToFront;
             end;
           end;
         end
        else if PosYZiel - PosYStart = -2 then
         begin
          if PosXZiel - PosXStart = 2 then
           begin  //case oben rechts (Dame schlägt nach oben rechts)
            if ImSG[(PosYZiel + 1),(PosXZiel - 1)].Enabled = true then
             begin
              SZ:=1;
              ImSG[(PosYZiel + 1),(PosXZiel - 1)].Enabled:=false;
              ImSG[(PosYZiel + 1),(PosXZiel - 1)].Visible:=false;
              ImSG[(PosYZiel + 1),(PosXZiel - 1)].SendToBack;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].Enabled:=true;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].Visible:=true;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].BringToFront;
             end
            else if ImSGD[(PosYZiel + 1),(PosXZiel - 1)].Enabled = true then
             begin
              SZ:=1;
              ImSGD[(PosYZiel + 1),(PosXZiel - 1)].Enabled:=false;
              ImSGD[(PosYZiel + 1),(PosXZiel - 1)].Visible:=false;
              ImSGD[(PosYZiel + 1),(PosXZiel - 1)].SendToBack;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].Enabled:=true;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].Visible:=true;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].BringToFront;
             end;
           end
          else if PosXZiel - PosXStart = -2 then
           begin  //case oben links (Dame schlägt nach oben links)
            if ImSG[(PosYZiel + 1),(PosXZiel + 1)].Enabled = true then
             begin
              SZ:=1;
              ImSG[(PosYZiel + 1),(PosXZiel + 1)].Enabled:=false;
              ImSG[(PosYZiel + 1),(PosXZiel + 1)].Visible:=false;
              ImSG[(PosYZiel + 1),(PosXZiel + 1)].SendToBack;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].Enabled:=true;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].Visible:=true;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].BringToFront;
             end
            else if ImSGD[(PosYZiel + 1),(PosXZiel + 1)].Enabled = true then
             begin
              SZ:=1;
              ImSGD[(PosYZiel + 1),(PosXZiel + 1)].Enabled:=false;
              ImSGD[(PosYZiel + 1),(PosXZiel + 1)].Visible:=false;
              ImSGD[(PosYZiel + 1),(PosXZiel + 1)].SendToBack;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].Enabled:=true;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].Visible:=true;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].BringToFront;
             end;
           end;
         end;
       end;
     end
    else  //Gleiche Logik wie oben bei rot, nur nochmal für Gelb. (Bei dem Normalen Stein wurden lediglich die Vorzeichen umgedreht.)
     begin
      if DZ = -1 then //(nicht dame)
       begin
        if PosYZiel = (PosYStart + 1) then  //normal
         begin
          if (PosXZiel - PosXStart)*(-(PosXZiel - PosXStart)) = -1 then
           begin
            SZ:=1;
            //Es sei den ein stein kan schlagen
           end;
         end
        else
         begin //schlagen
          if PosYZiel = (PosYStart + 2) then
           begin
            if PosXZiel = (PosXStart + 2) then
             begin
              if ImSR[(PosYZiel - 1),(PosXStart + 1)].Enabled = true then
               begin
                SZ:=1;
                ImSR[(PosYZiel - 1),(PosXStart + 1)].Enabled:=false;
                ImSR[(PosYZiel - 1),(PosXStart + 1)].Visible:=false;
                ImSR[(PosYZiel - 1),(PosXStart + 1)].SendToBack;
                ImSN[(PosYZiel - 1),(PosXStart + 1)].Enabled:=true;
                ImSN[(PosYZiel - 1),(PosXStart + 1)].Visible:=true;
                ImSN[(PosYZiel - 1),(PosXStart + 1)].BringToFront;
               end
              else if ImSRD[(PosYZiel - 1),(PosXStart + 1)].Enabled = true then
               begin
                SZ:=1;
                ImSRD[(PosYZiel - 1),(PosXStart + 1)].Enabled:=false;
                ImSRD[(PosYZiel - 1),(PosXStart + 1)].Visible:=false;
                ImSRD[(PosYZiel - 1),(PosXStart + 1)].SendToBack;
                ImSN[(PosYZiel - 1),(PosXStart + 1)].Enabled:=true;
                ImSN[(PosYZiel - 1),(PosXStart + 1)].Visible:=true;
                ImSN[(PosYZiel - 1),(PosXStart + 1)].BringToFront;
               end;
             end
            else if PosXZiel = (PosXStart - 2) then
             begin
              if ImSR[(PosYZiel - 1),(PosXStart - 1)].Enabled = true then
               begin
                SZ:=1;
                ImSR[(PosYZiel - 1),(PosXStart - 1)].Enabled:=false;
                ImSR[(PosYZiel - 1),(PosXStart - 1)].Visible:=false;
                ImSR[(PosYZiel - 1),(PosXStart - 1)].SendToBack;
                ImSN[(PosYZiel - 1),(PosXStart - 1)].Enabled:=true;
                ImSN[(PosYZiel - 1),(PosXStart - 1)].Visible:=true;
                ImSN[(PosYZiel - 1),(PosXStart - 1)].BringToFront;
               end
              else if ImSRD[(PosYZiel - 1),(PosXStart - 1)].Enabled = true then
               begin
                SZ:=1;
                ImSRD[(PosYZiel - 1),(PosXStart - 1)].Enabled:=false;
                ImSRD[(PosYZiel - 1),(PosXStart - 1)].Visible:=false;
                ImSRD[(PosYZiel - 1),(PosXStart - 1)].SendToBack;
                ImSN[(PosYZiel - 1),(PosXStart - 1)].Enabled:=true;
                ImSN[(PosYZiel - 1),(PosXStart - 1)].Visible:=true;
                ImSN[(PosYZiel - 1),(PosXStart - 1)].BringToFront;
               end;
             end;
           end;
         end;
         //wenn geschlagen (SZ1), dann S = 1.
       end
      else
       begin  //dame
        if (PosYZiel - PosYStart)*(-(PosYZiel - PosYStart)) = -1 then
         begin  //Zug normal dame gelb
          if (PosXZiel - PosXStart)*(-(PosXZiel - PosXStart)) = -1 then
           begin
            SZ:=1;
           end;
         end  //Schlagen dame gelb
        else if PosYZiel - PosYStart = 2 then
         begin
          if PosXZiel - PosXStart = 2 then
           begin  //case unten rechts
            if ImSR[(PosYZiel - 1),(PosXZiel - 1)].Enabled = true then
             begin
              SZ:=1;
              ImSR[(PosYZiel - 1),(PosXZiel - 1)].Enabled:=false;
              ImSR[(PosYZiel - 1),(PosXZiel - 1)].Visible:=false;
              ImSR[(PosYZiel - 1),(PosXZiel - 1)].SendToBack;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].Enabled:=true;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].Visible:=true;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].BringToFront;
             end
            else if ImSRD[(PosYZiel - 1),(PosXZiel - 1)].Enabled = true then
             begin
              SZ:=1;
              ImSRD[(PosYZiel - 1),(PosXZiel - 1)].Enabled:=false;
              ImSRD[(PosYZiel - 1),(PosXZiel - 1)].Visible:=false;
              ImSRD[(PosYZiel - 1),(PosXZiel - 1)].SendToBack;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].Enabled:=true;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].Visible:=true;
              ImSN[(PosYZiel - 1),(PosXZiel - 1)].BringToFront;
             end;
           end
          else if PosXZiel - PosXStart = -2 then
           begin  //case unten links
            if ImSR[(PosYZiel - 1),(PosXZiel + 1)].Enabled = true then
             begin
              SZ:=1;
              ImSR[(PosYZiel - 1),(PosXZiel + 1)].Enabled:=false;
              ImSR[(PosYZiel - 1),(PosXZiel + 1)].Visible:=false;
              ImSR[(PosYZiel - 1),(PosXZiel + 1)].SendToBack;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].Enabled:=true;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].Visible:=true;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].BringToFront;
             end
            else if ImSRD[(PosYZiel - 1),(PosXZiel + 1)].Enabled = true then
             begin
              SZ:=1;
              ImSRD[(PosYZiel - 1),(PosXZiel + 1)].Enabled:=false;
              ImSRD[(PosYZiel - 1),(PosXZiel + 1)].Visible:=false;
              ImSRD[(PosYZiel - 1),(PosXZiel + 1)].SendToBack;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].Enabled:=true;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].Visible:=true;
              ImSN[(PosYZiel - 1),(PosXZiel + 1)].BringToFront;
             end;
           end;
         end
        else if PosYZiel - PosYStart = -2 then
         begin
          if PosXZiel - PosXStart = 2 then
           begin  //case oben rechts
            if ImSR[(PosYZiel + 1),(PosXZiel - 1)].Enabled = true then
             begin
              SZ:=1;
              ImSR[(PosYZiel + 1),(PosXZiel - 1)].Enabled:=false;
              ImSR[(PosYZiel + 1),(PosXZiel - 1)].Visible:=false;
              ImSR[(PosYZiel + 1),(PosXZiel - 1)].SendToBack;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].Enabled:=true;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].Visible:=true;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].BringToFront;
             end
            else if ImSRD[(PosYZiel + 1),(PosXZiel - 1)].Enabled = true then
             begin
              SZ:=1;
              ImSRD[(PosYZiel + 1),(PosXZiel - 1)].Enabled:=false;
              ImSRD[(PosYZiel + 1),(PosXZiel - 1)].Visible:=false;
              ImSRD[(PosYZiel + 1),(PosXZiel - 1)].SendToBack;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].Enabled:=true;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].Visible:=true;
              ImSN[(PosYZiel + 1),(PosXZiel - 1)].BringToFront;
             end;
           end
          else if PosXZiel - PosXStart = -2 then
           begin  //case oben links
            if ImSR[(PosYZiel + 1),(PosXZiel + 1)].Enabled = true then
             begin
              SZ:=1;
              ImSR[(PosYZiel + 1),(PosXZiel + 1)].Enabled:=false;
              ImSR[(PosYZiel + 1),(PosXZiel + 1)].Visible:=false;
              ImSR[(PosYZiel + 1),(PosXZiel + 1)].SendToBack;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].Enabled:=true;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].Visible:=true;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].BringToFront;
             end
            else if ImSRD[(PosYZiel + 1),(PosXZiel + 1)].Enabled = true then
             begin
              SZ:=1;
              ImSRD[(PosYZiel + 1),(PosXZiel + 1)].Enabled:=false;
              ImSRD[(PosYZiel + 1),(PosXZiel + 1)].Visible:=false;
              ImSRD[(PosYZiel + 1),(PosXZiel + 1)].SendToBack;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].Enabled:=true;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].Visible:=true;
              ImSN[(PosYZiel + 1),(PosXZiel + 1)].BringToFront;
             end;
           end;
         end;
       end;
     end;

   //Zug Ausführen, wenn SZ (Szenario) = 1, also wenn der Zug legal ist.
    if SZ = 1 then
     begin
      if DZ = -1 then  //Wenn ein normaler Stein zieht
       begin
        if WaZ = 1 then  //Wenn Rot zieht.
         begin  //Wenn ein normaler Stein zieht
          //Alten Stein unsichtbar machen. Oberfläche vorbereiten, falls in der Zukunft ein anderer Stein auf das selbe Feld gezogen wird.
          ImSR[PosYStart,PosXStart].Visible:=false;
          ImSR[PosYStart,PosXStart].Enabled:=false;
          ImSR[PosYStart,PosXStart].SendToBack;
          ImSN[PosYStart,PosXStart].Visible:=true;
          ImSN[PosYStart,PosXStart].Enabled:=true;
          ImSN[PosYStart,PosXStart].BringToFront;

          //Neuen Stein schtbar machen.
          if PosYZiel <> 1 then  //normaler Zug
           begin
            ImSR[PosYZiel,PosXZiel].Visible:=true;
            ImSR[PosYZiel,PosXZiel].Enabled:=true;
            ImSR[PosYZiel,PosXZiel].BringToFront;
           end
          else  //Bei Umwandlung zu einer Dame
           begin
            ImSRD[PosYZiel,PosXZiel].Visible:=true;
            ImSRD[PosYZiel,PosXZiel].Enabled:=true;
            ImSRD[PosYZiel,PosXZiel].BringToFront;
           end;
          ImSN[PosYZiel,PosXZiel].Visible:=false;
          ImSN[PosYZiel,PosXZiel].Enabled:=false;
          ImSN[PosYZiel,PosXZiel].SendToBack;
         end
        else  //Wenn Gelb zieht. Gleich wie oben.
         begin
          ImSG[PosYStart,PosXStart].Visible:=false;
          ImSG[PosYStart,PosXStart].Enabled:=false;
          ImSG[PosYStart,PosXStart].SendToBack;
          ImSN[PosYStart,PosXStart].Visible:=true;
          ImSN[PosYStart,PosXStart].Enabled:=true;
          ImSN[PosYStart,PosXStart].BringToFront;

          if PosYZiel <> 8 then
           begin
            ImSG[PosYZiel,PosXZiel].Visible:=true;
            ImSG[PosYZiel,PosXZiel].Enabled:=true;
            ImSG[PosYZiel,PosXZiel].BringToFront;
           end
          else
           begin
            ImSGD[PosYZiel,PosXZiel].Visible:=true;
            ImSGD[PosYZiel,PosXZiel].Enabled:=true;
            ImSGD[PosYZiel,PosXZiel].BringToFront
           end;
          ImSN[PosYZiel,PosXZiel].Visible:=false;
          ImSN[PosYZiel,PosXZiel].Enabled:=false;
          ImSN[PosYZiel,PosXZiel].SendToBack;
         end;
       end
      else  //Wenn Dame zieht
       begin
        if WaZ = 1 then  //Wenn Rot zieht.
         begin
          ImSRD[PosYStart,PosXStart].Visible:=false;
          ImSRD[PosYStart,PosXStart].Enabled:=false;
          ImSRD[PosYStart,PosXStart].SendToBack;
          ImSN[PosYStart,PosXStart].Visible:=true;
          ImSN[PosYStart,PosXStart].Enabled:=true;
          ImSN[PosYStart,PosXStart].BringToFront;

          ImSRD[PosYZiel,PosXZiel].Visible:=true;
          ImSRD[PosYZiel,PosXZiel].Enabled:=true;
          ImSRD[PosYZiel,PosXZiel].BringToFront;
          ImSN[PosYZiel,PosXZiel].Visible:=false;
          ImSN[PosYZiel,PosXZiel].Enabled:=false;
          ImSN[PosYZiel,PosXZiel].SendToBack;
         end
        else  //Wenn Gelb zieht
         begin
          ImSGD[PosYStart,PosXStart].Visible:=false;
          ImSGD[PosYStart,PosXStart].Enabled:=false;
          ImSGD[PosYStart,PosXStart].SendToBack;
          ImSN[PosYStart,PosXStart].Visible:=true;
          ImSN[PosYStart,PosXStart].Enabled:=true;
          ImSN[PosYStart,PosXStart].BringToFront;

          ImSGD[PosYZiel,PosXZiel].Visible:=true;
          ImSGD[PosYZiel,PosXZiel].Enabled:=true;
          ImSGD[PosYZiel,PosXZiel].BringToFront;
          ImSN[PosYZiel,PosXZiel].Visible:=false;
          ImSN[PosYZiel,PosXZiel].Enabled:=false;
          ImSN[PosYZiel,PosXZiel].SendToBack;
         end;
       end;

      //Sieg Überprüfung
{}{}  k := 1;  //k bestimmt in der folgenden Sequenz, wann ein Spielstein überprüft wird, da nicht auf allen Feldern (nicht auf den weisen) ein Spielstein generiert wurde (Siehe Zeile X)
      l:=12;
      m:=12;
      for i := 1 to 8 do
       begin
        for j := 1 to 8 do
         begin
          if k = -1 then  //Spielsteine werden nur auf jedem zweiten Feld erstellt.
           begin
            if ImSR[i,j].Visible or ImSRD[i,j].Visible then
             begin
              l:=l-1;
             end;
            if ImSG[i,j].Visible or ImSGD[i,j].Visible then
             begin
              m:=m-1;
             end;
           end;
          //Korrekter Zustand k Variable (bestimmt wo/wann die Spielsteine erstellt werden).
          k:=k*-1;  //Siehe oben
         end;
        k:=k*-1;  //Siehe oben
       end;
      if l = 12 then  //Sieg Gelb
       begin
        ShowMessage('Gelb hat gewonnen!');
        Sleep(800);
        Zurücksetzen(Self);
       end
      else if m = 12 then  //Sieg Rot
       begin
        ShowMessage('Rot hat gewonnen!');
        Sleep(800);
        Zurücksetzen(Self);
       end;

      //Korrektur; Sichtbarkeit der Umrandungen.
      ImP.BringToFront;
      ImP2.BringToFront;

      WaZ:=WaZ*-1;  //Wer auch immer dran war, jetzt ist der andere dran. Wer dran ist wird über die Variable "WaZ"(WerAmZug) bestimmt. Deswegen wird sie hier umgekehrt.
      AZA:=1;  //Korrektur Zustandsvariable.


     end
    else //Wenn illegaler Zug
     begin
      ShowMessage('Illegaler Zug');
      AZA:=1;  //Korrektur Zustandsvariable, Fehlerprevention
      ImP.Left:=-100;  //Umrandungen werden "entfernt".
      ImP2.Left:=-100;  //Siehe oben
     end;
   end;
  if WaZ = 1 then
   begin
    WaZLabel.Caption:=('Rot ist am Zug');
   end
  else
   begin
    WaZLabel.Caption:=('Gelb ist am Zug');
   end;


 end;



{}{}procedure TForm1.Zurücksetzen(Sender: TObject);  //Zurücksetzen des Feldes. genutzt entweder manuell durch das drücken eines Knopfes, (oder ggf. in der Vollversion automatisch nach einem Sieg)
 begin
  WaZLabel.Caption:='Rot ist am Zug';
  ImP.Left:=-100;  //Umrandungen werden "entfernt".
  ImP2.Left:=-100;  //Siehe oben
{}{}  k := 1;  //k bestimmt in der folgenden Sequenz, wann ein Spielstein "entfernt" wird, da nicht auf allen Feldern (nicht auf den weisen) ein Spielstein generiert wurde (Siehe Zeile X)
  for i := 1 to 8 do
   begin
    for j := 1 to 8 do
     begin
      if k = -1 then  //Spielsteine werden nur auf jedem zweiten Feld erstellt. Siehe Zeile X.
       begin
        ImSR[i,j].Visible:=false;  //Spielsteine werden zurück gesetzt...
        ImSR[i,j].Enabled:=false;
        ImSR[i,j].SendToBack;
        if i >= 6 then  //Sichtbar in den Reihen 6, 7 und 8.
         begin
          ImSR[i,j].Visible:=true;
          ImSR[i,j].Enabled:=true;
          ImSR[i,j].BringToFront;
         end;

{}{}        ImSG[i,j].Visible:=false;  //Siehe oben (Zeile X)
        ImSG[i,j].Enabled:=false;
        ImSG[i,j].SendToBack;
        if i <= 3 then
         begin
          ImSG[i,j].Visible:=true;
          ImSG[i,j].Enabled:=true;
          ImSG[i,j].BringToFront;
         end;

        //Alle Damen werden "entfernt"
        ImSRD[i,j].Visible:=false;
        ImSRD[i,j].Enabled:=false;
        ImSRD[i,j].SendToBack;
        ImSGD[i,j].Visible:=false;
        ImSGD[i,j].Enabled:=false;
        ImSGD[i,j].SendToBack;

        //Zurücksetzen der Clickbaren leeren Felder
        ImSN[i,j].Visible:=false;
        ImSN[i,j].Enabled:=false;
        ImSN[i,j].SendToBack;
        if i > 3 then
         begin
          if i < 6 then
           begin
            ImSN[i,j].Visible:=true;
            ImSN[i,j].Enabled:=true;
            ImSN[i,j].BringToFront;
           end;
         end;
       end;

      ImH[i,j].SendToBack;  //Damit das Spielfeld im Hintergrund ist.

      //Korrekter Zustand k Variable (bestimmt wo/wann die Spielsteine erstellt werden).
      k:=k*-1;  //Siehe oben
     end;
    k:=k*-1;  //Siehe oben
   end;
  AzA:=1;  //Der erste Zug beginnt mit dem auswählen eines Steines
  WaZ:=1;  //Rot ist am Anfang am Zug
  ImP.BringToFront;  //Damit die Pointer im Vordergrund sind.
  ImP2.BringToFront;  //Siehe oben
 end;



end.  //Ende. (-:[>

