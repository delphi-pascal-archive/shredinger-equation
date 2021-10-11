program Schrodinger;

uses
  Forms,
  Schro in 'Schro.pas' {Form1},
  Matrix in 'Matrix.pas',             
  Schro2 in 'Schro2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
