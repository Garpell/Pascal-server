program httpserver;
uses
    SysUtils, fphttpapp, fpwebfile;
Const
     MyPort = 8080;
     MyDocumentRoot = 'C:/Users/Garpell/Projects/page';
     //MyMiMeFile = 'C:/Users/Garpell/Projects/page/mime.types';
begin
     RegisterFileLocation('files',MyDocumentRoot);
    // MimeTypesFile:=MyMimeFile;
     Application.Initialize;
     Application.Port:=MyPort;
     Application.Title:='My HTTP Server';
     Application.Run;
end.

