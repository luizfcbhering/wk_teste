program WkTeste;

uses
  Vcl.Forms,
  View.Principal in 'View.Principal.pas' {fPrincipal},
  View.Pesquisa in 'Comum\View.Pesquisa.pas' {ViewPesquisa},
  Model.Dados in 'Models\Model.Dados.pas' {ModelDados: TDataModule},
  Model.Pesquisa in 'Models\Model.Pesquisa.pas' {ModelPesquisa: TDataModule},
  Comum.Funcoes in 'Comum\Comum.Funcoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TModelDados, ModelDados);
  Application.CreateForm(TModelPesquisa, ModelPesquisa);
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
