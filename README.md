# DameDelphi
Das Spiel "Dame" von Jonas Klein und Valerii Zayko

## Benutzeranweisungen

<img width="417" height="417" alt="image" src="https://github.com/user-attachments/assets/f98b355b-da7f-421c-aa60-355d97541248" />

Das hier ist das Spielfeld. Die rote Steine fangen an. Durch da Anclicken des Steins wird der ausgewählt (man erkennt das an den Blauen Rahmen) und durch das Ancklicken eines Feldes wird der Stein da hingezogen.

<img width="418" height="418" alt="Recording 2026-05-08 at 20 27 48" src="https://github.com/user-attachments/assets/7288d794-bd27-4f54-9156-a5abd3d05a8c" />

So sieht das aus.Danach sind die Gelbe Steine dran.


<img width="426" height="422" alt="Recording 2026-05-08 at 20 35 42" src="https://github.com/user-attachments/assets/afba2657-8eeb-4cf0-b235-5403e6401ed9" />

Wenn man versucht ein ilegaler Zug zu machen, bekommt man eine Warnung.

<img width="434" height="426" alt="Recording 2026-05-08 at 20 44 03" src="https://github.com/user-attachments/assets/35d37012-ce3c-4a5e-a168-adfd185d1203" />

## Implementation

### Erklärung der Abkürzungen

ImH(ImageHintergrund) ist das Spielfeld.

ImSR(ImageSpielsteinRot) und ImSG(ImageSpielsteinGelb) sind die Spielsteine.

ImSN(ImageSpielsteinNichts) wird als klickbare Oberfläche zum ziehen von Spielsteinen verwendet.

ImP(ImagePointer) ist das blaue Rechteck, was wir als Umrandung benutzen.

i,jk und l werden als flexible Variablen für Schleifen, oder als kurzzeitiger Speicher genutzt.

 MPosX(MausPositionX) und MPosY(MausPositionY) werden zum zwischenspeichern der Mausposition auf der X und Y Achse genutzt (X=.Left,Y=.Top).

  Die Variablen PosXStart(PositionXStart), PosYStart(PositionYStart), PosXZiel(PositionXZiel) und PosYZiel(PositionYZiel) werden beim bewegen der Steine als Speicher genutzt, sie bestimmen welcher Stein (PosXStart und PosYStart) wohin (PosXZiel,PosYZiel) gezogen werden soll.

 WaZ(WerAmZug) hat nur die zwei Zustände 1 und -1, und wird als Zwischensspeicher im Auswahl-Prozess verwendet.

  AZA(AuswahlZugAuswahl) bestimmt den Zeitpunkt des Zugprozesses, beim ersten Klick ist AZA = 1, beim zweiten ist AZA = -1.

  MPos(MausPosition) wird genutzt um die Mausposition zwischen zu speichern.

### Code

#### Felder und Steine

Zu erst bekommen die Felder ihre Eigenschaften.

```pascal
ImH[i,j]:=TImage.Create(Self);  //Erstellen
ImH[i,j].Parent := Self;  
ImH[i,j].Left:=500+50*j;  //Position auf der X-Achse, abhängig von j
ImH[i,j].Top:=50+50*i;  //Position auf der Y-Achse, abhängig von i
ImH[i,j].Width:=50;  //Größe
ImH[i,j].Height:=50;  //Größe
ImH[i,j].AutoSize:=false;  //Größe (Korrektur)
ImH[i,j].Visible:=true;  //Hintergrund ist am Anfang sichtbar
ImH[i,j].Enabled:=false;  //Hintergrund hat keine Funktion außer das Aussehen
ImH[i,j].Canvas.Brush.Style := bssolid;
```

Danach bekommen die Spielsteine ihre Eigenschaften. Da der Code für die gelbe und rote Steine gleich ist, zeige ich erkläre ich nur die rote.

```pascal
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
```
Dann bekommen die Steine ihre Farbe.
```pascal
//Spielsteine Rot erstellen: Generell 1
ImSR[i,j].Canvas.Brush.Style := bssolid;  //"Stil"
//Spielsteine Rot: Hintergrund
ImSR[i,j].Canvas.Brush.Color := clMaroon;  //Farbe Hintergrund
ImSR[i,j].Canvas.Rectangle(1,1,50,50);  //Erstellen des Hintergrunds
//Spielsteine Rot erstellen: Steine
ImSR[i,j].Canvas.Brush.Color := clRed;  //Farbe Steine
if i >= 6 then  //Am Start sollen nur die Steine in den Reihen 6, 7 und 8 sichtbar/bewegbar seien.
  begin
    ImSR[i,j].Visible:=true;  //Siehe Zeile X
    ImSR[i,j].Enabled:=true;  //Siehe Zeile X
  end;
//Spielsteine Rot erstellen: Generell 2
ImSR[i,j].Canvas.Ellipse(5,5,46,46);  //Erstellen der Steine
ImSR[i,j].BringToFront;  //Damit die Spielsteine im Vordergrund sind.
ImSR[i,j].OnClick:=ClickHandlerRot;  //Auswahlprozess, siehe Zeile X.
```
#### Bewegung

Jetzt kommen zur der Logik für die Bewegung.

Erst erstellen wir die beiden Pointer einen grünen und einen blauen (weil der code dafür gleich ist, erwähne ich es nur ein Mal)

```pascal
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
ImP.Picture.Bitmap.SetSize(ImP.Width,ImP.Height);  //Bitmap Größe der Image Größe (Zeile X-X) gleichsetzen.
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


```
Nach der erstellund des Pointers, kommt die Logik für den.

```pascal
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


```
Nach den Beiden Pointers kommt der Code für die Bewegung der Steine ( Code für Gelb und Blau ist gleich).

```pascal
procedure TForm1.ClickHandlerRot(Sender: TObject);  //Genutzt in Zeile X
begin
if WaZ = 1 then  //Wird nur ausgeführt wenn Rot auch am Zug ist.
 begin
  if AZA = 1 then  //Wird nur ausgefüht, wenn zuvor noch kein Stein ausgewählt wurde.
   begin
Feldauswahl1(Self);  //Wählt Feld aus. Siehe Zeile X.
   end
  else
   begin
    ShowMessage('Da kannst du nicht hinziehen!');  //Wenn bereits ein Stein ausgewählt wurde, kann kein neuer ausgewählt werden. Wenn dieser Fall eintritt, versucht der Nutzer einen Stein auf einen anderen Stein zu ziehen, was nicht geht.
    ImP.Left:=-100;  //In dem oben genannten Fall werden Pointer weggenommen.
    ImP2.Left:=-100;  //
   end;
    AZA:=AZA*-1;  //Stein wurde ausgewählt. Jetzt darf die Prozedur "Feldauswahl2" in Zeile X ausgeführt werden.
 end
else
 begin
    ShowMessage('Illagaler Zug!');  //"else" bezieht sich auf Zeile X. Wird ausgeführt wenn Rot nicht am Zug ist.
  AZA:=1;  //Fehlervorbeugung.
  ImP.Left:=-100;  //Da der Zug abgebrochen wurde, werden die Pointer "entfernt".
  ImP2.Left:=-100;
 end;
end;

```

Nach dem man ein Stein ausgewählt hat, wählt man ein leeres Feld. Die Bewegung selbst ist implementiert da durch, dass wir das ausgewählte Stein unsichtbar machen und auf den gewählten Feld den Stein sichtbar machen.

```pascal
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
   end;

  if WaZ = 1 then  //Wenn Rot zieht.
   begin
    //Alten Stein unsichtbar machen. Oberfläche vorbereiten, falls in der Zukunft ein anderer Stein auf das selbe Feld gezogen wird.
    ImSR[PosYStart,PosXStart].Visible:=false;
    ImSR[PosYStart,PosXStart].Enabled:=false;
    ImSR[PosYStart,PosXStart].SendToBack;
    ImSN[PosYStart,PosXStart].Visible:=true;
    ImSN[PosYStart,PosXStart].Enabled:=true;
    ImSN[PosYStart,PosXStart].BringToFront;

    //Neuen Stein schtbar machen.
    ImSR[PosYZiel,PosXZiel].Visible:=true;
    ImSR[PosYZiel,PosXZiel].Enabled:=true;
    ImSR[PosYZiel,PosXZiel].BringToFront;
    ImSN[PosYZiel,PosXZiel].Visible:=false;
    ImSN[PosYZiel,PosXZiel].Enabled:=false;
    ImSN[PosYZiel,PosXZiel].SendToBack;
   end

  else  //Wenn Gelb zieht. Gleich wie oben.
  ...
//Korrektur Sichtbarkeit der Umrandungen.
  ImP.BringToFront;
  ImP2.BringToFront;

  WaZ:=WaZ*-1;  //Wer auch immer dran war, jetzt ist der andere dran. Wer dran ist wird über die Variable "WaZ"(WerAmZug) bestimmt. Deswegen wird sie hier umgekehrt.
  AZA:=1;  //Korrektur Zustandsvariable.
 end;

end.  //Ende. (-:
```
