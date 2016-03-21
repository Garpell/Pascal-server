program httpserver;

uses
  Classes, SysUtils, FileUtil, Interfaces, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, Math, serverform, httpform;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TSForm, SForm);
  Application.Run;
end.

