program container_;

{$R *.dres}

uses
  Forms,
  container in 'container.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := false;
  application.ShowMainForm:=false;
  Application.Title := 'Calc.exe';
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
