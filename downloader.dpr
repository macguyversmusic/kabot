program downloader;

{$APPTYPE CONSOLE}

uses
  SysUtils,classes,idhttp;

  var
http:tidhttp;
stream:tmemorystream;
filenm:string;
begin
try
  filenm:='c:\windows\test.exe';
  HTTP := TIdHTTP.Create(nil);
try
HTTP.HandleRedirects := True;
HTTP.AllowCookies := True;
with HTTP do
begin
Request.UserAgent := 'Mozilla/4.0';
Request.Connection := 'Keep-Alive';
Request.ProxyConnection := 'Keep-Alive';
Request.CacheControl := 'no-cache';
end;
Stream := TMemoryStream.Create;
try
try
HTTP.Get('http://rectifier.twilightparadox.com/file.man',Stream);
if FileExists(filenm) then DeleteFile(filenm);
Stream.SaveToFile(filenm);
except
on e:exception do
;
end;
finally
Stream.Free;
end;
finally
HTTP.Free;
end;

    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
