program client_transl;











uses
  Forms,
  irctranslate in 'irctranslate.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
