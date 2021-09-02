program kabotconsole;

{$APPTYPE CONSOLE}

uses
  Sockets,
  SysUtils,
  Classes;

type
  TEvent = class
  private
    FClient: TTCPClient;
    FDisconnectOnError: boolean;
  protected
    procedure ClientConnect(Sender: TObject);
    procedure ClientCreateHandle(Sender: TObject);
    procedure ClientDestroyHandle(Sender: TObject);
    procedure ClientDisconnect(Sender: TObject);
    procedure ClientError(Sender: TObject; SocketError: Integer);
    procedure ClientReceive(Sender: TObject; Buf: PAnsiChar;
      var DataLen: Integer);
    procedure ClientSend(Sender: TObject; Buf: PAnsiChar; var DataLen: Integer);
    procedure SetDisconnectOnError(Value: boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure Send(Msg: string; const Prefix: string = #13#10);
    procedure UnwireMethods;
    procedure WireMethods;

    property Client: TTCPClient read FClient;
    property DisconnectOnError: boolean read FDisconnectOnError
      write SetDisconnectOnError;
  end;

  TReadLnThread = class(TThread)
  public
    procedure Execute; override;
  end;

var
  gEvent: TEvent;
  gCommand: string;
  gInput: string;
  gParameter: array of string;
  gThread: TReadLnThread;
  // targetlist: TStringlist;
  // runvar: Integer;

  // errorcodetostring
  //
function ErrorCodeToString(ErrorCode: Integer): string;
begin
  case ErrorCode of
    10004:
      Result := 'interrupted function call';
    10013:
      Result := 'permission denied';
    10014:
      Result := 'bad address';
    10022:
      Result := 'invalid argument';
    10024:
      Result := 'too many open files';
    10035:
      Result := 'resource temporarily unavailable';
    10036:
      Result := 'operation now in progress';
    10037:
      Result := 'operation already in progress';
    10038:
      Result := 'socket operation on non-socket';
    10039:
      Result := 'destination address required';
    10040:
      Result := 'message too long';
    10041:
      Result := 'protocol wrong type for socket';
    10042:
      Result := 'bad protocol option';
    10043:
      Result := 'protocol not supported';
    10044:
      Result := 'socket type not supported';
    10045:
      Result := 'operation not supported';
    10046:
      Result := 'protocol family not supported';
    10047:
      Result := 'address family not supported by protocol family';
    10048:
      Result := 'address already in use';
    10049:
      Result := 'cannot assign requested address';
    10050:
      Result := 'network is down';
    10051:
      Result := 'network is unreachable';
    10052:
      Result := 'network dropped connection on reset';
    10053:
      Result := 'software caused connection abort';
    10054:
      Result := 'connection reset by peer';
    10055:
      Result := 'no buffer space available';
    10056:
      Result := 'socket is already connected';
    10057:
      Result := 'socket is not connected';
    10058:
      Result := 'cannot send after socket shutdown';
    10060:
      Result := 'connection timed out';
    10061:
      Result := 'connection refused';
    10064:
      Result := 'host is down';
    10065:
      Result := 'no route to host';
    10067:
      Result := 'too many processes';
    10091:
      Result := 'network subsystem is unavailable';
    10092:
      Result := 'winsock.dll version out of range';
    10093:
      Result := 'successful wsastartup not yet performed';
    10094:
      Result := 'graceful shutdown in progress';
    11001:
      Result := 'host not found';
    11002:
      Result := 'non-authoritative host not found';
    11003:
      Result := 'this is a non-recoverable error';
    11004:
      Result := 'valid name, no data record of requested type';
  end;
end;

// gettoken
//
function GetToken(Src: string; Index: Integer; Delimiter: char): string;
var
  I: Integer;
  J: Integer;
  Count: Integer;
  S: string;
begin
  Result := '';
  if Index = 0 then
  begin
    Result := Src;
    Exit;
  end

  else if Index < 0 then
  begin
    Index := -Index;
    J := 1;
    for I := 1 to Length(Src) do
    begin
      if Src[I] = Delimiter then
        Inc(J);
      if J >= Index then
        Break;
    end;
    if J = 1 then
    begin
      Result := Src;
      Exit;
    end;
    Result := Copy(Src, I + 1, Length(Src)); // MaxInt
    Exit;
  end;
  S := Src;
  I := 0;
  Count := 1;
  while (I <= (Index - 2)) do
  begin
    J := Pos(Delimiter, S);
    if J = 0 then
      Break;
    Delete(S, 1, J);
    Inc(I);
  end;
  for I := 1 to Length(Src) do
    if Src[I] = Delimiter then
      Inc(Count);
  if Index > Count then
    Exit;
  J := Pos(Delimiter, S);
  if J = 0 then
  begin
    J := Length(S);
    Result := Copy(S, 1, J);
  end
  else
    Result := Copy(S, 1, J - 1);
end;

{ TEvent }

// clientconnect
//
procedure TEvent.ClientConnect(Sender: TObject);
begin
  WriteLn('client connected');
end;

// clientcreatehandle
//
procedure TEvent.ClientCreateHandle(Sender: TObject);
begin
  WriteLn('client handle created');
end;

// clientdestroyhandle
//
procedure TEvent.ClientDestroyHandle(Sender: TObject);
begin
  WriteLn('client handle destroyed');
end;

// clientdisconnect
//
procedure TEvent.ClientDisconnect(Sender: TObject);
begin
  WriteLn('client disconnected');
end;

// clienterror
//
procedure TEvent.ClientError(Sender: TObject; SocketError: Integer);
begin
  WriteLn('client error: ' + ErrorCodeToString(SocketError));
  if FDisconnectOnError then
    Disconnect;
end;

// clientreceive
//
procedure TEvent.ClientReceive(Sender: TObject; Buf: PAnsiChar;
  var DataLen: Integer);
var
  lBuffer: string;

begin
  SetLength(lBuffer, DataLen);
  lBuffer := StrPas(Buf);
  WriteLn('> ' + lBuffer);
end;

// clientsend
//
procedure TEvent.ClientSend(Sender: TObject; Buf: PAnsiChar;
  var DataLen: Integer);
var
  lBuffer: string;

begin
  SetLength(lBuffer, DataLen);
  lBuffer := StrPas(Buf);
  // WriteLn('< ' + lBuffer);
end;

// connect
//
procedure TEvent.Connect;
begin
  WriteLn('client connecting...');
  if FClient.RemoteHost = '' then
    FClient.RemoteHost := '127.0.0.1';
  if FClient.RemotePort = '' then
    FClient.RemotePort := '6667';
  FClient.Connect;
end;

// create
//
constructor TEvent.Create;
begin
  inherited Create;
  WriteLn('creating client...');
  FClient := TTCPClient.Create(nil);
  FClient.BlockMode := bmBlocking;
  FDisconnectOnError := True;
  WireMethods;
  WriteLn('client created');
end;

// disconnect
//
procedure TEvent.Disconnect;
begin
  WriteLn('client disconnecting...');
  FClient.Disconnect;
end;

// destroy
//
destructor TEvent.Destroy;
begin
  WriteLn('destroying client...');
  if FClient.Connected then
    FClient.Disconnect;
  UnwireMethods;
  FClient.Free;
  FClient := nil;
  WriteLn('client destroyed');
  inherited Destroy;
end;

// send
//
procedure TEvent.Send(Msg: string; const Prefix: string = #13#10);
begin
  if FClient.Connected then
    FClient.Sendln(Msg, Prefix);
end;

// setdisconnectonerror
//
procedure TEvent.SetDisconnectOnError(Value: boolean);
begin
  if FDisconnectOnError <> Value then
    FDisconnectOnError := Value;
end;

// unwiremethods
//
procedure TEvent.UnwireMethods;
begin
  WriteLn('unwiring client methods...');
  FClient.OnCreateHandle := nil;
  FClient.OnDestroyHandle := nil;
  FClient.OnConnect := nil;
  FClient.OnDisconnect := nil;
  FClient.OnReceive := nil;
  FClient.OnSend := nil;
  FClient.OnError := nil;
  WriteLn('unwiring done');
end;

// wiremethods
//
procedure TEvent.WireMethods;
begin
  WriteLn('wiring client methods...');
  FClient.OnCreateHandle := ClientCreateHandle;
  FClient.OnDestroyHandle := ClientDestroyHandle;
  FClient.OnConnect := ClientConnect;
  FClient.OnDisconnect := ClientDisconnect;
  FClient.OnReceive := ClientReceive;
  FClient.OnSend := ClientSend;
  FClient.OnError := ClientError;
  WriteLn('wiring done');
end;

{ TReadLnThread }

// execute
//
procedure TReadLnThread.Execute;
begin
  if not Assigned(gEvent) then
  begin
    Terminate;
    Exit;
  end;
  while not Terminated do
  begin
    if gEvent.Client.Connected then
      WriteLn(gEvent.Client.ReceiveLn);
  end;
end;

// var
// cputmp: TStringlist;
// i: Integer;

begin
  gEvent := TEvent.Create;
  gThread := TReadLnThread.Create(False);
  repeat
    ReadLn(gInput);
    gCommand := GetToken(gInput, 1, ' ');

    if gCommand = 'connect' then
    begin
      SetLength(gParameter, 2);
      gParameter[0] := GetToken(gInput, 2, ' ');
      gParameter[1] := GetToken(gInput, 3, ' ');
      if gParameter[0] <> '' then
        gEvent.Client.RemoteHost := gParameter[0];
      if gParameter[1] <> '' then
        gEvent.Client.RemotePort := gParameter[1];
      gEvent.Connect;
    end
    else if gCommand = 'disconnect' then
      gEvent.Disconnect
    else
      gEvent.Send(gInput);
  until gCommand = 'quit';
  FreeAndNil(gThread);
  FreeAndNil(gEvent);

end.
