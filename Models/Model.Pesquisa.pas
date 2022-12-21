unit Model.Pesquisa;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  System.StrUtils,

  Data.DB,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TModelPesquisa = class(TDataModule)
    qryProdutos: TFDQuery;
    qryPessoas: TFDQuery;
    qryPessoascodigo: TFDAutoIncField;
    qryPessoasnome: TStringField;
    qryPessoascidade: TStringField;
    qryPessoasuf: TStringField;
    qryProdutoscodigo: TFDAutoIncField;
    qryProdutosdescricao: TStringField;
    qryProdutosval_venda: TFMTBCDField;
  private
    { Private declarations }
    function Operador(aSQL: string): string;
  public
    { Public declarations }
    gSQLOri: String;

    function PesquisarCliente(ACampo, ACampoAlias, AValor, AViewCad: String): Boolean;
    function PesquisarProduto(ACampo, ACampoAlias, AValor, AViewCad: String): Boolean;
 end;

var
  ModelPesquisa: TModelPesquisa;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  Model.Dados,
  View.Pesquisa;

{$R *.dfm}

{ TModelPesquisa }

function TModelPesquisa.Operador(aSQL: string): string;
begin
  if Pos('WHERE', UpperCase(aSQL)) > 0 then
    Result := ' AND '
  else
    Result := ' WHERE ';
end;

function TModelPesquisa.PesquisarCliente(ACampo, ACampoAlias, AValor, AViewCad: String): Boolean;
begin
  try
    qryPessoas.Close;
    gSQLOri := qryPessoas.SQL.Text;

    if not (AValor.Trim.IsEmpty) then
    begin
      if (pfInKey in qryPessoas.FieldByName(ACampoAlias).ProviderFlags) then
        qryPessoas.SQL.Text := gSQLOri +Operador(gSQLOri)+ACampo+' = '+AValor
      else
        qryPessoas.SQL.Text := gSQLOri +Operador(gSQLOri)+ACampo+' LIKE ''%'+AValor+'%''';
    end;

    qryPessoas.Open();

    if qryPessoas.RecordCount > 1 then
    begin
      ViewPesquisa := TViewPesquisa.Create(Self, ModelDados.conWK, qryPessoas, AViewCad, gSQLOri);
      ViewPesquisa.ShowModal;
    end;

    Result := not qryPessoas.IsEmpty;
  finally
    if Assigned(ViewPesquisa) then
      FreeAndNil(ViewPesquisa);
  end;
end;

function TModelPesquisa.PesquisarProduto(ACampo, ACampoAlias, AValor,
  AViewCad: String): Boolean;
begin
   try
    qryProdutos.Close;
    gSQLOri := qryProdutos.SQL.Text;

    if not (AValor.Trim.IsEmpty) then
    begin
      if (pfInKey in qryProdutos.FieldByName(ACampoAlias).ProviderFlags) then
        qryProdutos.SQL.Text := gSQLOri +Operador(gSQLOri)+ACampo+' = '+AValor
      else
        qryProdutos.SQL.Text := gSQLOri +Operador(gSQLOri)+ACampo+' LIKE ''%'+AValor+'%''';
    end;

    qryProdutos.Open();

    if qryProdutos.RecordCount > 1 then
    begin
      ViewPesquisa := TViewPesquisa.Create(Self, ModelDados.conWK, qryProdutos, AViewCad, gSQLOri);
      ViewPesquisa.ShowModal;
    end;

    Result := not qryProdutos.IsEmpty;
  finally
    if Assigned(ViewPesquisa) then
      FreeAndNil(ViewPesquisa);
  end;
end;


end.
