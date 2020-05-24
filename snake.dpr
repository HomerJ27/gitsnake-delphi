program snake;

uses
  Forms,
  main in 'main.pas' {Form1},
  game in 'game.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
