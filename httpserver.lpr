program httpserver;

uses
  Classes, SysUtils, FileUtil, Interfaces, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, Math, serverform, httpform;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

