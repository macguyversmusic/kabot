program vc_downloader;

uses
  Forms,
  vcdownloader in 'vcdownloader.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := false;
  Application.ShowMainForm := false;
  Application.CreateForm(TForm5, Form5);
  Application.Run;

end.
