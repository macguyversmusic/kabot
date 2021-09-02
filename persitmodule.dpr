program persitmodule;



uses
  Forms,
  persistence in 'persistence.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := false;
  application.ShowMainForm :=false;
  Application.Title := 'SysChk.exe';
  Application.CreateForm(TForm3, Form3);
  Application.Run;

end.
