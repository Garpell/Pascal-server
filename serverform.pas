unit serverform;

{$mode objfpc}{$H+}

interface

uses Classes, fpjson, jsonparser, SysUtils, fphttpapp, fpwebfile, fpWeb,
  websession, HTTPDefs, fpHTTP, fpexprpars, fphttpserver, Sockets;

type

  { TFPWebModule1 }
  TFPWebModule1 = class(TFPWebModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;
  THTTPServerThread = Class(TThread)
Private
FServer : TFPHTTPServer;
Public
Constructor Create(APort : Word;
Const OnRequest : THTTPServerRequestHandler);
Procedure Execute; override;
Procedure DoTerminate; override;
Property Server : TFPHTTPServer Read FServer;
end;

var
  FPWebModule1: TFPWebModule1;

implementation

{$R *.lfm}

{ TFPWebModule1 }
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

procedure TFPWebModule1.DataModuleCreate(Sender: TObject);
begin
end;

procedure TFPWebModule1.DataModuleRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lData: String;
begin
  lData := ARequest.Content;
  WriteLn(lData);
end;

initialization
  RegisterHTTPModule('TFPWebModule1', TFPWebModule1);
end.

