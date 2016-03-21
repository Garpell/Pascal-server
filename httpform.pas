unit httpform;


interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, fpjson, jsonparser, fphttpapp, fpwebfile, fpWeb,
  websession, HTTPDefs, fpHTTP, fpexprpars, fphttpserver, Sockets;

type

  { TSForm }

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

    TSForm = class(TForm)
    StartButton: TButton;
    StopButton: TButton;
    LogField: TMemo;
    procedure StartButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure DoHandleRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest; var AResponse: TFPHTTPConnectionResponse);
    procedure FormCreate(Sender: TObject);
    procedure ShowURL;
  end;

var
  SForm: TSForm;
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

procedure TSForm.FormCreate(Sender: TObject);
begin
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
procedure TSForm.StartButtonClick(Sender: TObject);
begin
LogField.Lines.Add('---------------');
LogField.Lines.Add('Starting server');
FServer:=THTTPServerThread.Create(8080,@DoHandleRequest);
end;

procedure TSForm.StopButtonClick(Sender: TObject);
begin
LogField.Lines.Add('---------------');
LogField.Lines.Add('Stopping server');
FServer.Terminate;
end;

function CreateHtml(res: real) : string;
begin
     CreateHtml := '<html><head><title>Equation result</title></head> <body><h1>Result is ' + FloatToStr(res) + '</h1></body> </html>';
end;

procedure TSForm.DoHandleRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest; var AResponse: TFPHTTPConnectionResponse);
var
   result : real;
   s : string;
begin
FURL:=Arequest.URL;
FServer.Synchronize(@ShowURL);
s := ARequest.Content;
result := JSONCount(s);
LogField.Lines.Add('Result: ' + FloatToStr(result));
  AResponse.ContentType := 'html';
  //AResponse.Contents.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'mainpage.html');
  //s:= '{"Answer:" ' + FloatToStr(result) + '}';
  AResponse.Contents.Text := CreateHtml(result);
end;

procedure TSForm.ShowURL;
begin
LogField.Lines.Add('Handling request : '+FURL);
end;
{$R *.lfm}

end.

