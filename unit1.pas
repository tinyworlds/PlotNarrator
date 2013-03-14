{License: zLib}

{Copyright (c) 2013 Rick Hoppmann

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

   1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

   2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.

   3. This notice may not be removed or altered from any source
   distribution.
}


unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  story : TStringList;
  title : string;

implementation

{$R *.lfm}

//get article of word
function Article (wrd:string) : string;
Var hlp : string;
begin

if (wrd[1] = 'a') or (wrd[1] = 'e') or (wrd[1] = 'i') or (wrd[1] = 'o') or (wrd[1] = 'u') then hlp := 'an' else hlp := 'a';
Article := hlp + ' ';

end;

//load element out of txt file
function LoadWords (name:string) : string;
Var initialdir : string; listsize : integer; list: Tstringlist;
begin

 list := TStringList.create;
 InitialDir:=ExtractFilePath(Application.ExeName);
 list.LoadFromFile(InitialDir+ 'txt/' + name + '.txt');

 listsize := list.count;
 Randomize;
 LoadWords := list[Random(listsize)];
end;

{ TForm1 }

//Save story
procedure TForm1.Button2Click(Sender: TObject);
 begin
  if title = '' then SaveDialog1.FileName := 'Unamed Story' else SaveDialog1.FileName := title;
  SaveDialog1.InitialDir := ExtractFilePath(Application.ExeName);
   if SaveDialog1.Execute then begin
    Memo1.Lines.SaveToFile(SaveDialog1.FileName + '.txt');
   end;
 end;

//Generate Story
procedure TForm1.Button1Click(Sender: TObject);
VAR strplot, pnames, pgender : TStringlist; confl,hlp : string; i : integer;
begin

 Randomize;

 //Generate the plot
 strplot := TStringList.create;
 confl := LoadWords('conflict');

  if (confl = 'kidnap') or (confl = 'destroy') then begin
   strplot.add(confl);
   if random(2) = 1 then strplot.add('cheat');
  end;

  if confl = 'witch' then begin
   strplot.add(confl);
   strplot.add('cheat');
   strplot.add('entwitch');
  end;

  strplot.add(LoadWords('conflict_end'));

 //generate persons
 pnames := TStringList.create;
 pgender := TStringList.create;

   //names of persons
   pnames.add(LoadWords('person_good'));
   pnames.add(LoadWords('person_evil'));

   //gender of persons
   for i := 1 to 2 do begin
    if random(2) = 1 then pgender.add('he') else pgender.add('she');
   end;

 //narrate story
 story := TStringList.create;

 hlp := LoadWords('adjective_good');
 if random(2) = 1 then story.add(LoadWords('onceupon') + ' there lived ' + Article(pnames[0]) + pnames[0] + '.') else  story.add(LoadWords('onceupon') + ' there lived ' + Article(hlp) + hlp + ' ' + pnames[0] + '.');

 For i := 0 to (strplot.count-1) do begin
   if strplot[i] = 'kidnap' then begin
    if random(2) = 1 then story.add (LoadWords('oneday') + ' ' + pgender[0] + ' was ' + LoadWords('kidnap') + ' by ' + Article(pnames[1]) + pnames[1] + '.') else story.add ('One day the ' + pnames[0] + ' was ' + LoadWords('kidnap') + ' by ' + Article(pnames[1]) + pnames[1] + '.')
   end;

   if strplot[i] = 'destroy' then begin
    if random(2) = 1 then story.add (LoadWords('oneday') + ' ' + Article(pnames[1]) + pnames[1] + ' ' + LoadWords('destroy') + ' the ' + LoadWords('destroyobject') + ' of the ' + pnames[0] + '.') else story.add ('One day ' + Article(pnames[1]) + pnames[1] + ' ' + LoadWords('kill') + ' the ' + LoadWords('relative') + ' of the ' + pnames[0] + '.');
   end;

   if strplot[i] = 'cheat' then begin
    hlp := pgender[0];
    if random(2) = 1 then story.add (UpCase(hlp[1]) + Copy(hlp, 2 , length(hlp)) + ' ' + LoadWords('cheat') + ' the ' + pnames[1] + '.') else story.add ('The ' + pnames[0] + ' ' + LoadWords('cheat') + ' the ' + pnames[1] + '.')
   end;

   if strplot[i] = 'kill' then begin
    if random(2) = 0 then story.add (LoadWords('then') + ' ' + pgender[0] + ' ' + LoadWords('kill') + ' the ' + pnames[1] + '.') else story.add ('Then the ' + pnames[0] + ' ' + LoadWords('kill') + ' the ' + pnames[1] + '.')
   end;

   if strplot[i] = 'flee' then begin
    if random(2) = 0 then story.add (LoadWords('then') + ' ' + pgender[0] + ' ' + LoadWords('flee') + '.') else story.add ('Then the ' + pnames[0] + ' ' + LoadWords('flee') + '.')
   end;

   if strplot[i] = 'witch' then begin
    if random(2) = 1 then story.add (LoadWords('oneday') + ' ' + pgender[0] + ' was ' + LoadWords('witch') + ' by ' + Article(pnames[1]) + pnames[1] + '.') else story.add ('One day the ' + pnames[0] + ' was ' + LoadWords('witch') + ' by ' + Article(pnames[1]) + pnames[1] + '.')
   end;

   if strplot[i] = 'entwitch' then begin
    story.add ('The ' + pnames[1] + ' ' + LoadWords('entwitch') + ' the ' + pnames[0]  + '.')
   end;

   if strplot[i] = 'imprison' then begin
    if random(2) = 0 then story.add (LoadWords('then') + ' ' + pgender[0] + ' ' + LoadWords('imprison') + ' the ' + pnames[1] + '.') else story.add ('Then the ' + pnames[0] + ' ' + LoadWords('imprison') + ' the ' + pnames[1] + '.')
   end;

  end;

 //titel
 hlp := LoadWords('adjective_good');
 if (random(2) = 1) then title := 'The ' + UpCase(pnames[1][1]) + Copy(pnames[1], 2 , length(pnames[1])) else if (random(2) = 1) then title := 'The ' + UpCase(pnames[0][1]) + Copy(pnames[0], 2 , length(pnames[0])) + ' and The ' + UpCase(pnames[1][1]) + Copy(pnames[1], 2 , length(pnames[1])) else title := 'The ' + UpCase(hlp[1]) + Copy(hlp, 2 , length(hlp)) + ' ' + UpCase(pnames[0][1]) + Copy(pnames[0], 2 , length(pnames[0])) ;
 Form1.Caption := title;

 Memo1.lines := story;


 end;





end.

