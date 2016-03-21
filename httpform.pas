unit httpform;


interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, fpjson, jsonparser, fphttpapp, fpwebfile, fpWeb,
  websession, HTTPDefs, fpHTTP, fpexprpars, fphttpserver, Sockets;

type

  { TForm1 }

  THTTPServerThread = Class(TThread)
Private
    FServer : TFPHTTPServer;
Public
Constructor Create(APort : Word;
Const OnRequest : THTTPServerRequestHandler);
Procedure Execute; override;
Procedure DoTerminate; override;
//Property Server : TFPHTTPServer Read FServer;
end;

    TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    MLog: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DoHandleRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest; var AResponse: TFPHTTPConnectionResponse);
    procedure FormCreate(Sender: TObject);
    procedure ShowURL;
  end;

var
  Form1: TForm1;
  FServer : THTTPServerThread;
  FHandler : TFPCustomFileModule;
      FURL: string;

implementation
function JSONCount(json : string) : real;
var
   jData : TJSONData;
   jObject : TJSONObject;
   expr : string;
   s : string;
   FParser: TFPExpressionParser;
begin
     FParser := TFPExpressionParser.Create(nil);
     jData := GetJSON(json);
     jObject := TJSONObject(jData);
     expr := jObject.Get('expr');
     FParser.BuiltIns := [bcMath];
     FParser.Expression := expr;
     JSONCount := ArgToFloat(FParser.Evaluate);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
RegisterFileLocation('files','/home/michael/public_html');
MimeTypesFile:='/etc/mime.types';
FHandler:=TFPCustomFileModule.CreateNew(Self);
FHandler.BaseURL:='files/';
end;
constructor THTTPServerThread.Create(APort: Word;
const OnRequest: THTTPServerRequestHandler);
begin
FServer:=TFPHTTPServer.Create(Nil);
FServer.Port:=APort;
FServer.OnRequest:=OnRequest;
Inherited Create(False);
end;
procedure THTTPServerThread.Execute;
begin
try
FServer.Active:=True;
Finally
FreeAndNil(FServer);
end;
end;
procedure THTTPServerThread.DoTerminate;
begin
inherited DoTerminate;
FServer.Active:=False;
end;
procedure TForm1.Button1Click(Sender: TObject);
begin
MLog.Lines.Add('Starting server');
FServer:=THTTPServerThread.Create(8080,@DoHandleRequest);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
MLog.Lines.Add('Stopping server');
FServer.Terminate;
end;

procedure TForm1.DoHandleRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest; var AResponse: TFPHTTPConnectionResponse);
var
   result : real;
   s : string;
begin
FURL:=Arequest.URL;
FServer.Synchronize(@ShowURL);
//WriteLn(AResponse.Content);
s := ARequest.Content;
WriteLn(s);
result := JSONCount(s);
MLog.Lines.Add('Result: ' + FloatToStr(result));
Sleep(30000);
end;
procedure TForm1.ShowURL;
begin
MLog.Lines.Add('Handling request : '+FURL);
end;
{$R *.lfm}

end.
