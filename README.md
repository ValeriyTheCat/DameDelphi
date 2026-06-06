# Dame

Das Spiel Dame von Valerii und Jonas.

## Benutzeranweisungen
> [!NOTE]
> Die Version verfolgt das "English Standart Ruleset", und nicht für das "English Tournament Ruleset" ausgelegt. Das heißt, dass Damen nur jeweils ein Feld rückwärts gehen können (Schlagen ausgenommen), und dass wenn ein Stein am Ende des Brettes zu einer Dame wird, der Zug beendet ist, auch wenn man die Möglichkeit zum "Ketten-Fangen" hätte.

### Züge

Beim Starten des Programms sieht man dieses Fenster

<img width="1034" height="723" alt="image" src="https://github.com/user-attachments/assets/f6aea697-d526-48a3-91a2-8a3b30334535" />

Die Benutzeroberfläche ist ziemlich selbsterklärend.
Beim Ancliken einer von den roten Steinen, wird dieses mit einem blauen Ramen gekennzeichnet. Um ein Zug zumachen, muss man ein zweites Feld ancliken. Dies wird mit Grün umgezeichnet. Danach wird der Stein auf das ausgewähltes Feld plaziert.

<img width="462" height="451" alt="Recording 2026-06-06 at 00 03 11" src="https://github.com/user-attachments/assets/415d688c-87e4-44f8-a823-ed05fcba2fef" />


Jetzt ist Gelb dran. Der Prozes dafür ist gleich. Man wählt ein Stein aus, wählt das Ziel aus und clikt die an.

<img width="411" height="412" alt="Recording 2026-06-06 at 00 12 12" src="https://github.com/user-attachments/assets/7168b327-6078-4434-a031-44509424233b" />

Wenn man versucht über mehr als ein Feld zugehen oder zu ein ilegales Zug zumachen, bekommt man eine Warnung.

<img width="402" height="401" alt="Recording 2026-06-06 at 00 16 39 (1)" src="https://github.com/user-attachments/assets/fe1e7185-f16c-4425-9afd-e8bc29750821" />

Wenn man über ein Stein des Gegners überspringt, wird dieser weggeschlagen. 

<img width="431" height="444" alt="Recording 2026-06-06 at 00 22 16" src="https://github.com/user-attachments/assets/032bde31-a437-4925-879e-8d55659a30f3" />

### Dame

Jetzt spingen wir in die Zukunft, wo Rot fast am Rand des Spielfelds ist. Wenn man den erreicht, kriegt man eine Dame. Diese wird mit einem Rechteck auf dem Stein symbolisiert.

<img width="433" height="423" alt="Recording 2026-06-06 at 00 25 24" src="https://github.com/user-attachments/assets/f281f94e-56e7-42df-8568-d950ab6a414b" />

Dame kann, anstatt nur nach vorne Züge zumachen, auch sich nach hinten ziehen.

### Kettenschlag

<a name="Kettenschlag"></a>

Wenn man in einer Position ist, wo man ein oder mehrere Kettenschläge ausgeführen werden können, wird man dazu gezwungen diese zumachen.

<img width="443" height="458" alt="Recording 2026-06-06 at 00 34 22" src="https://github.com/user-attachments/assets/79e67fdf-8800-4ace-8902-c7828723aea1" />

### Ende des Spiels

Wenn einer von den Spieler keine Steine übrige Steine hat, bekommt man eine Nachrcht, dass man gewonnen hat. Danach wird das Feld zurückgesetzt. 

<img width="427" height="435" alt="Recording 2026-06-06 at 00 41 02 (1)" src="https://github.com/user-attachments/assets/bd20e7a2-3930-4b21-ac82-0bd27a8dedfa" />

Wenn man das Spiel nicht zu Ende spielen kann/will, kann man das Feld zurücksetzen. Dafür clikt man das Knopf, wo drauf "Zurücksetzen" steht. Dann wird gefragt, ob man sicher ist, dass man zurücksetzen will. Falls ja, wird das Spielfeld zurücksetzt. Falls nein, geht das Fenster einfach weg.

<img width="1009" height="774" alt="Recording 2026-06-06 at 00 50 30" src="https://github.com/user-attachments/assets/d5ddf9a8-9b9a-4893-8223-b694e3280f95" />

## Code

### Abkürzungen

Es werden viel Abkürzungen genutzt, deshalb werden diese hier erklärt.

ImH(ImageHintergrund) ist das Spielfeld.

ImSR(ImageSpielsteinRot) und ImSG(ImageSpielsteinGelb) sind die standard Spielsteine.

ImSRD/ImSGD(ImageSpielstein[Farbe]Dame) sind die umgewandelten Spielsteine.

ImSN(ImageSpielsteinNichts) wird als klickbare Oberfläche zum ziehen von Spielsteinen verwendet.

ImP(ImagePointer) ist das blaue bzw. grüne Rechteck, was wir als Umrandung benutzen.

i,j,k,l und m werden als flexible Variablen für Schleifen, oder als kurzzeitiger Speicher genutzt.

MPosX(MausPositionX) und MPosY(MausPositionY) werden zum zwischenspeichern der Mausposition auf der X und Y Achse genutzt (X=.Left,Y=.Top).

Die Variablen PosXStart(PositionXStart), PosYStart(PositionYStart), PosXZiel(PositionXZiel) und PosYZiel(PositionYZiel) werden beim bewegen der Steine als Speicher genutzt, sie bestimmen welcher Stein (PosXStart und PosYStart) wohin (PosXZiel,PosYZiel) gezogen werden soll.

WaZ(WerAmZug) hat nur die zwei Zustände 1 und -1, und wird als Zwischensspeicher im Auswahl-Prozess verwendet. 

AZA(AuswahlZugAuswahl) bestimmt den Zeitpunkt des Zugprozesses, beim ersten Klick ist AZA = 1, beim zweiten ist AZA = -1. 

Sz(Szenario) wird ab und zu als flexible Variable genutzt.

DZ(DamenZug)wird genutz, um zu bestimmen welche Art von Spielstein Am Zug ist

Schlag ist dann eins, wenn ein Stein geschlagen wurde und wird die Überprüfung für das Ketten-Schlagen aktivieren. 

KettenSchlag ist dann 1, wenn eine Möglichkeiten eines Ketten-Schlages besteht.

MPos(MausPosition) wird genutzt um die Mausposition zwischen zu speichern.

### Erzeugen des Feldes und der Steine
> [!NOTE]
> Um diese Dokumentation kurz zuhalten, werden Teile des Codes, die sich ähnlich sind, weggelassen.

Diese Procedure wird ausgeführt wenn das Programm gestartet ist.

Zu erst werden alle Zustands auf 0 gesetzt. Und das Layout der Nutzeroberfläche wird gesetzt.
```pascal

WaZLabel.Left:=5;         //Startposition der Benutzer Oberfläche
WaZLabel.Top:=500;        //Startposition der Benutzer Oberfläche
KnZurücksetzen.Left:=50;  //Startposition der Benutzer Oberfläche
KnZurücksetzen.Top:=550;  //Startposition der Benutzer Oberfläche
AZA:=1;  //Wichtig für später.
WaZ:=1;  //Rot wird zuerst ziehen.
KettenSchlag:=0;  //Das Spiel hat noch nicht begonnen, es kann noch gar keine Möglichkeit zum "Ketten-Fangen" geben.
k := 1;  //Hier: k bestimmt, wann Spielsteine gneriert werden und wann ein Hintergrund-Feld Braun bzw. Weiss ist.

```

Danach werden alle Steine, Pointers und Spielfelder dynamisch in einer Schleife erzeugt.

Zuerst bekommt das Spielfeld seine Eingenschaften.

```pascal

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

```

Dann werden die rote Steine erzeugt. Dabei werden die aber, nur auf jedem zweiten Feld erzeugt.

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

//Spielsteine Rot erstellen: Generell 1
ImSR[i,j].Canvas.Brush.Style := bssolid;  //"Stil"
//Spielsteine Rot erstellen: Hintergrund
ImSR[i,j].Canvas.Brush.Color := clMaroon;  //Farbe Hintergrund
ImSR[i,j].Canvas.Rectangle(1,1,50,50);  //Erstellen des Hintergrunds
//Spielsteine Rot erstellen: Steine
ImSR[i,j].Canvas.Brush.Color := clRed;  //Farbe Steine
if i >= 6 then  //Am Start sollen nur die Steine in den Reihen 6, 7 und 8 sichtbar/bewegbar seien.
 begin
  ImSR[i,j].Visible:=true;  //Siehe Zeile 94
  ImSR[i,j].Enabled:=true;  //Siehe Zeile 94
 end;
ImSR[i,j].Canvas.Ellipse(5,5,46,46);  //Erstellen der Steine
ImSR[i,j].BringToFront;  //Damit die Spielsteine im Vordergrund sind.
ImSR[i,j].OnClick:=ClickHandlerRot;  //Auswahlprozess, siehe Zeile 333.

```

Das Gleiche passiert für Ggelbe Steine und für Damen von beiden Farben.

Weiter haben wir die Eigenschaften der Oberfläche zum Ziehen.

```pascal

ImSN[i,j]:=TImage.Create(Self);
ImSN[i,j].Parent := Self;
ImSN[i,j].Left:=500+50*j;
ImSN[i,j].Top:=50+50*i;
ImSN[i,j].Width:=50;
ImSN[i,j].Height:=50;
ImSN[i,j].AutoSize:=false;
ImSN[i,j].Visible:=false;
ImSN[i,j].Enabled:=false;
ImSN[i,j].Transparent:=true;
ImSN[i,j].Canvas.Brush.Style:=bssolid;  //Sieht aus wie ein leeres Feld.
ImSN[i,j].Canvas.Brush.Color:=clMaroon;  //Siehe oben
ImSN[i,j].Canvas.Rectangle(1,1,50,50);  //Siehe oben


```

Danach kommen noch andere Eigenschaften von anderen Objekten.

```pascal

if i > 3 then  //Am Start sollen nur die Steine in den Reihen 4 und 5 leer seien.
         begin
          if i < 6 then
           begin
            ImSN[i,j].Visible:=true;  //Siehe Zeile 188
            ImSN[i,j].Enabled:=true;  //Siehe Zeile 188
            ImSN[i,j].BringToFront;   //Siehe Zeile 188
           end;
         end;
        ImSN[i,j].OnClick:=ClickHandlerElse;  //Auswahlprozess, siehe Zeile 473.

       end;  //Bezogen auf: Spielsteine erstellen, Start bei Zeile 72.

      //Spielfeld erstellen 2
      if k = -1 then //Bestimmt wann das Spielfeld mit weißer/brauner Farbe erstellt wird, siehe Zeile 48.
       begin
        ImH[i,j].Canvas.Brush.Color:=clMaroon;  //Farbe, siehe oben, Zeile 202.
       end
      else
       begin
        ImH[i,j].Canvas.Brush.Color:=clCream;  //Farbe, siehe oben, Zeile 202.
       end;
      ImH[i,j].Canvas.Rectangle(1,1,50,50);  //Erstellen
      ImH[i,j].SendToBack;  //Damit das Spielfeld im Hintergrund ist.

      //Korrekter Zustand k Variable (bestimmt Farben, und wo/wann die Spielsteine erstellt werden).
      k:=k*-1;  //Siehe oben
     end;
    k:=k*-1;  //Siehe oben
   end;

```

Dann wird die Umrandung erstellt 

```pascal

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
  ImP.Picture.Bitmap.SetSize(ImP.Width,ImP.Height);  //Bitmap Größe der Image Größe (Zeile 226-227) gleichsetzen.
  ImP.Picture.Bitmap.Canvas.FillRect(Rect(0,0,ImP.Width,ImP.Height)); //Rechteck auf der Bitmap erstellen.
  ImP.Picture.Bitmap.Transparent := True;  //Sorgt dafür, dass man weiterhin das Spielfeld sehen
  with ImP.Picture.Bitmap.Canvas do  //Eigenschaften der Bitmap deklarieren
   begin
    Pen.Color := clBlue;  //Farbe
    Pen.Width := 2;  //Wie breit die Umrandung ist, 2 sieht schön aus.
    Brush.Style := bsClear;  //Nur Umrandung (des Rechtecks), bei "bssolid" wäre das ganze Feld bedeckt.
    Rectangle(1, 1, ImP.Width - 1, ImP.Height - 1);  //Rechteck erstellen. "ImP.Widtht - 1"/"ImP.Height - 1" sorgen dafür, dass die Ecke des Rechtecks auf dem letzten sichtbaren Pixel ist.
   end;
  ImP.BringToFront;  //Sorgt dafür, dass man die Umrandung auch sehen kann (bringt die Umrandung in den Vordergrund).

  //Zweite Umrandung, wie oben. Nur diesmal in grün :)
  ImP2:=TImage.Create(Self);
  ImP2.Parent:=Self;
  ImP2.Width:=51;
  ImP2.Height:=51;
  ImP2.AutoSize:=False;
  ImP2.Left:=-100;
  ImP2.Top:=100;
  ImP2.Transparent:=True;
  //Bitmap erstellen
  ImP2.Picture.Bitmap:=TBitmap.Create;
  ImP2.Picture.Bitmap.PixelFormat:=pf32bit;
  ImP2.Picture.Bitmap.SetSize(ImP2.Width,ImP2.Height);
  ImP2.Picture.Bitmap.Canvas.FillRect(Rect(0,0,ImP2.Width,ImP2.Height));
  ImP2.Picture.Bitmap.Transparent := True;
  with ImP2.Picture.Bitmap.Canvas do
   begin
    Pen.Color := clgreen; //Farbe ist jetzt grün.
    Pen.Width := 2;
    Brush.Style := bsClear;
    Rectangle(1, 1, ImP2.Width - 1, ImP2.Height - 1);
   end;
  ImP2.BringToFront;

```

Jetzt sind alle Steine erstellt und wir kommen zum Zurücksetzen

```pascal

procedure TForm1.KnZurücksetzenClick(Sender: TObject);  //Fragt ab, und führt ggf. die Prozedur "Zurücksetzen" aus.
 begin
  if MessageDlg('Willst du das Feld Zurücksetzen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then  //Fragt ab, ob das Spiel wirklich zurückgesetzt werden soll.
   begin
    Zurücksetzen(Self);  //Setzt das Feld, sowie manche Variablen zurück. Siehe Zeile 1806.
   end;
 end;

```

Bei der Procedure "Zurücksetzen" werden alle Steine unsichtbar gemacht und die Damen werden "entfernt"(Das ist das Gegenteil von der Procedure, wo die alle erzeugt werden, deshalb wird hier nicht erwähnt)

Danach kommt die Procedure von Auswahl eines Felds

```pascal

procedure TForm1.Feldauswahl1(Sender: TObject);  //Ändert Zustand der Variablen PosXStart und PosYStart je nach Situation.
 begin
  GetCursorPos(MPos);  //Speichert die aktuelle Mausposition.
  MPos := Form1.ScreenToClient(MPos);  //Sorgt dafür, das die Position realativ zum Fenster (also im selben "Koordinatensystem" wie die Komponenten) gespeichert wird.
  MPosX := MPos.X - ImP.Width div 2;  //Nicht unbedingt benötigt, macht es aber einfacher für später. Sorgt dafür, dass die angegebene Position etwas verschoben ist. Wenn man jetzt in die Mitte klickt kommen ca. die Koordinaten von .Left und .Top des angeklickten Feldes raus. "div 2" = "/2", aber das Ergebnis ist automatisch gerundet.
  MPosY  := MPos.Y - ImP.Height div 2;  //Siehe oben.

  //Setze PosXStart
  i:=0;  //Reset für Schleife.
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

  //Setze PosYStart. Nahezu gleich wie oben.
  i:=0;
  PosYStart:=-1;
  k:=25;
  l:=75;
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

Jetzt kommen wir zu unserem Click Handlers[^1]. 

```pascal

procedure TForm1.ClickHandlerRot(Sender: TObject);  //Genutzt in Zeile 102.
 begin
  if KettenSchlag = 0 then  //Wenn es kein Kettenschlag ist.
   begin
    if WaZ = 1 then  //Wird nur ausgeführt wenn Rot auch am Zug ist.
     begin
      if AZA = 1 then  //Wird nur ausgefüht, wenn zuvor noch kein Stein ausgewählt wurde.
       begin
        Feldauswahl1(Self);  //Wählt Feld aus. Siehe Zeile 282.
        DZ:=-1;  //Es zieht keine Dame
       end
      else
       begin
        ShowMessage('Da kannst du nicht hinziehen!');  //Wenn bereits ein Stein ausgewählt wurde, kann kein neuer ausgewählt werden. Wenn dieser Fall eintritt, versucht der Nutzer einen Stein auf einen anderen Stein zu ziehen, was nicht geht.
        ImP.Left:=-100;  //In dem oben genannten Fall werden Pointer weggenommen.
        ImP2.Left:=-100;  //S.o.
       end;
      AZA:=AZA*-1;  //Zustandsvariable wird korrigiert.
     end
    else
     begin
      ShowMessage('Illegaler Zug!');  //"else" bezieht sich auf Zeile 337. Wird ausgeführt wenn Rot nicht am Zug ist.
      AZA:=1;  //Fehlervorbeugung.
      ImP.Left:=-100;  //Da der Zug abgebrochen wurde, werden die Pointer "entfernt".
      ImP2.Left:=-100;  //S.o.
     end;
   end
  else
   begin
    ShowMessage('Du musst schlagen');  //Wird bei zwingendem Ketten-Schlagen angezeigt.
   end;
 end;

```
Die sehen +/- gleich, deshalb werden die nicht mehr erwähnt.

Außer das ClickHandlerElse, da wird auch überprüft ob der Zug legal ist. Da es viel zu lang, wird es hier nur beschrieben und nicht zitiert. Es funktioniert in dem, man guck ob das Ausgewähle fel gleiche X bzw. Y Koordinate hat oder ob das Ziel zwei oder mehr Felder entfern ist. Wenn der Zug Illegal ist, wird es den Nutzer gemeldet und der kann noch mal Versuchen ein Zug zu machen.

Am Ende des ClickHandlers kommt die Logik für Gewinnen bzw. Verlieren, es funktioniert so, dass es wird geguckt wie viel Steine jede Seite[^2] hat und wenn einer davon gar keine hat, heißt andere Seite hat gewonnen.

Zum Schluß haben wir das Kettenschlagen. Hier wird äberpräft ob man schlagen kann. Falls ja, wird das den Nutzer gemeldet und der muss schon es selber machen. Falls nein, das Spiel geht weiter. [Siehe Kettenschlag](#Kettenschlag)



> [!NOTE]
> Obwohl dieses Spiel schon alle Basis Funktionen hat, fehlt es noch ein paar sachen. Und immerhin gibts es Bugs die wir becheben wollen, also melden Sie diese unter [Issues](https://github.com/ValeriyTheCat/DameDelphi/issues). Danke :heart:



## TODO

1. - [ ]  Zwingschlagen
2. - [ ]  Andere Variante/Regel
3. - [ ]  KI
4. - [ ]  ...










[^1]:Click Handler heißt hier eine Procedure die beim Ancliken etwas macht z.B. setzt den Pointer auf das ausgewählte Feld. 
[^2]: Mit "Seite" wird einer von den Spieler gemeint.

  

