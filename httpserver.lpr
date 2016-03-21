program httpserver;
uses fpjson, jsonparser, SysUtils, fphttpapp, fpwebfile;
Const
     MyPort = 8080;
     MyDocumentRoot = 'C:/Users/Garpell/Projects/page';
     //MyMiMeFile = 'C:/Users/Garpell/Projects/page/mime.types';

function JSONCompile : real;
var
   jData : TJSONData;
   jObject : TJSONObject;
   jArray : TJSONArray;
   variable: real;
   s : string;
begin
   jData := GetJSON('{"var1" : 5, "var2" : 3, "expr" : "+"}');
//   s := jData.AsJSON;
//   s := jData.FormatJSON;
   jObject := TJSONObject(jData);
   variable := jObject.Get('var1');
   if jObject.Get('expr') = '+' then
      variable := variable + jObject.Get('var2');
//   jObject.Integers['Fld2'] := 123;
//   s := jData.FindPath('Colors[1]').AsString;
//   JSONTest := s;
     JSONCompile := variable;
end;
var
   s : real;
begin
     s := JSONCompile();
     WriteLn(s);
     RegisterFileLocation('files',MyDocumentRoot);
    // MimeTypesFile:=MyMimeFile;
     Application.Initialize;
     Application.Port:=MyPort;
     Application.Title:='My HTTP Server';
     Application.Run;
end.

