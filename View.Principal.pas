unit View.Principal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.StdCtrls,

  Data.DB,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Buttons, Vcl.Mask, Vcl.DBCtrls;

type
  TfPrincipal = class(TForm)
    grdProdutos: TDBGrid;
    pnlCabecalho: TPanel;
    pnlRodape: TPanel;
    pnlDados: TPanel;
    lblCliente: TLabel;
    edtCodigoCliente: TEdit;
    edtNomeCliente: TEdit;
    lblProduto: TLabel;
    mtPedidos: TFDMemTable;
    mtItensPedidos: TFDMemTable;
    dsPedidos: TDataSource;
    dsItensPedidos: TDataSource;
    btnGravarItem: TBitBtn;
    mtItensPedidoscodigo: TFDAutoIncField;
    mtItensPedidoscodigo_ped: TIntegerField;
    mtItensPedidoscodigo_prod: TIntegerField;
    mtItensPedidosqtd_produto: TIntegerField;
    mtItensPedidosval_produto: TFMTBCDField;
    mtItensPedidosval_total: TFMTBCDField;
    mtItensPedidosdescricao: TStringField;
    mtPedidoscodigo: TIntegerField;
    mtPedidoscodigo_cli: TIntegerField;
    mtPedidosdat_pedido: TDateField;
    mtPedidosval_pedido: TFMTBCDField;
    mtPedidosnome: TStringField;
    mtPedidoscidade: TStringField;
    mtPedidosuf: TStringField;
    edtCodProduto: TEdit;
    edtNomeProduto: TEdit;
    edtQtd: TEdit;
    edtValUnitario: TEdit;
    edtValTotal: TEdit;
    lblQtd: TLabel;
    lblValUnitario: TLabel;
    lblValTotal: TLabel;
    btnSair: TBitBtn;
    btnGravarPedido: TBitBtn;
    btnPesquisar: TBitBtn;
    btnCancelar: TBitBtn;
    pnlTotal: TPanel;
    lblTotalPedido: TLabel;
    procedure edtCodigoClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCodigoClienteChange(Sender: TObject);
    procedure edtNomeClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCodProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtQtdExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtQtdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGravarItemClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
    procedure PesquisarProduto;
    procedure PesquisarCliente(ACampo: String);

    procedure GravarPedido;
    procedure GravarItens;

    procedure LimparItens;
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation

{$R *.dfm}

uses Model.Pesquisa, Model.Dados;

procedure TfPrincipal.btnGravarPedidoClick(Sender: TObject);
begin
  ModelDados.InserirPedido(ModelDados.GerarJSONPedido(mtPedidos, mtItensPedidos));
  mtPedidos.EmptyDataSet;
  mtItensPedidos.EmptyDataSet;

  edtCodigoCliente.Clear;
  edtNomeCliente.Clear;
  edtCodigoCliente.SetFocus;
  lblTotalPedido.Caption := 'Total: R$ 0,00';
end;

procedure TfPrincipal.btnPesquisarClick(Sender: TObject);
var
  Pedido: String;
begin
  if InputQuery('Localizar Pedido', 'Nº Pedido', Pedido) then
  begin
    if StrToIntDef(Pedido, 0) > 0 then
    begin
      edtCodigoCliente.Clear;
      edtNomeCliente.Clear;

      mtPedidos.EmptyDataSet;
      mtItensPedidos.EmptyDataSet;

      ModelDados.qryPedidos.Close;
      ModelDados.qryPedidos.ParamByName('codigo').AsInteger := StrToInt(Pedido);
      ModelDados.qryPedidos.Open;

      ModelDados.qryItensPedido.Close;
      ModelDados.qryItensPedido.ParamByName('codigo_ped').AsInteger := StrToInt(Pedido);
      ModelDados.qryItensPedido.Open;

      if ModelDados.qryPedidos.IsEmpty then
      begin
        ShowMessage('Pedido não localizado!');
        Exit;
      end;

      if mtPedidos.Active then
      begin
        mtPedidos.Active := False;
        mtItensPedidos.Active := False;
      end;

      mtPedidos.Data      := ModelDados.qryPedidos.Data;
      mtItensPedidos.Data := ModelDados.qryItensPedido.Data;

      edtCodigoCliente.Text := mtPedidoscodigo_cli.AsString;
      edtNomeCliente.Text   := mtPedidosnome.AsString;

      pnlDados.Enabled := True;
      edtCodProduto.SetFocus;
    end;

  end;
end;

procedure TfPrincipal.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfPrincipal.btnCancelarClick(Sender: TObject);
var
  Pedido: String;
begin
  if InputQuery('Cancelar Pedido', 'Nº Pedido', Pedido) then
  begin
    if StrToIntDef(Pedido, 0) > 0 then
    begin
      edtCodigoCliente.Clear;
      edtNomeCliente.Clear;

      mtPedidos.EmptyDataSet;
      mtItensPedidos.EmptyDataSet;

      ModelDados.qryPedidos.Close;
      ModelDados.qryPedidos.ParamByName('codigo').AsInteger := StrToInt(Pedido);
      ModelDados.qryPedidos.Open;

      if ModelDados.qryPedidos.IsEmpty then
      begin
        ShowMessage('Pedido não localizado!');
        Exit;
      end;

      if mtPedidos.Active then
      begin
        mtPedidos.Active := False;
        mtItensPedidos.Active := False;
      end;

      try
        ModelDados.qryPedidos.Delete;
        ShowMessage('Pedido excluído com sucesso !');
      except
        on E: Exception do
          ShowMessage('Erro ao excluir o pedido. Favor chamar o suporte. '+E.Message);
      end;

      pnlDados.Enabled := False;
      edtCodigoCliente.SetFocus;
    end;
  end;
end;

procedure TfPrincipal.btnGravarItemClick(Sender: TObject);
begin
  GravarItens;
end;

procedure TfPrincipal.edtCodigoClienteChange(Sender: TObject);
begin
  if (Trim(edtCodigoCliente.Text) = '') then
    edtNomeCliente.Clear;
end;

procedure TfPrincipal.edtCodigoClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F3) or (Key = VK_RETURN) then
  begin
    PesquisarCliente('codigo');
  end
  else
  if Key = VK_F4 then
  begin
    edtCodigoCliente.Clear;
    edtNomeCliente.Clear;
    pnlDados.Enabled := False;
  end;
end;

procedure TfPrincipal.edtCodProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F3) or (Key = VK_RETURN) then
  begin
    PesquisarProduto;
  end
  else
  if Key = VK_F4 then
  begin
    edtCodProduto.Clear;
    edtNomeProduto.Clear;
    edtQtd.Clear;
    edtValUnitario.Clear;
    edtValTotal.Clear;
  end;
end;

procedure TfPrincipal.edtNomeClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F3) or (Key = VK_RETURN) then
  begin
    PesquisarCliente('nome');
  end
  else
  if Key = VK_F4 then
  begin
    edtCodigoCliente.Clear;
    edtNomeCliente.Clear;
    pnlDados.Enabled := False;
  end;
end;

procedure TfPrincipal.edtQtdExit(Sender: TObject);
begin
  edtValTotal.Text := FormatCurr('0.00', StrToCurr(edtValUnitario.Text) * StrToIntDef(edtQtd.Text, 1));
end;

procedure TfPrincipal.edtQtdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    edtValTotal.Text := FormatCurr('0.00', StrToCurr(edtValUnitario.Text) * StrToIntDef(edtQtd.Text, 1));
    btnGravarItem.SetFocus;
  end;
end;

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  mtPedidos.CreateDataSet;
  mtItensPedidos.CreateDataSet;
end;

procedure TfPrincipal.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F6 then
    btnGravarPedidoClick(Sender)
  else
  if Key = VK_F7 then
    btnPesquisarClick(Sender)
  else
  if Key = VK_F8 then
    btnCancelarClick(Sender);
end;

procedure TfPrincipal.GravarItens;
begin
  mtItensPedidoscodigo_prod.AsString    := edtCodProduto.Text;
  mtItensPedidosdescricao.AsString      := edtNomeProduto.Text;
  mtItensPedidosqtd_produto.AsInteger   := StrToIntDef(edtQtd.Text, 0);
  mtItensPedidosval_produto.AsCurrency  := StrToCurr(edtValUnitario.Text);
  mtItensPedidosval_total.AsCurrency    := StrToCurr(edtValTotal.Text);
  mtItensPedidos.Post;

  mtPedidos.Edit;
  mtPedidosval_pedido.AsCurrency :=  mtPedidosval_pedido.AsCurrency + mtItensPedidosval_total.AsCurrency;
  mtPedidos.Post;

  lblTotalPedido.Caption := 'Total : '+FormatCurr('R$ ,#0.00', mtPedidosval_pedido.AsCurrency);

  LimparItens;
end;

procedure TfPrincipal.GravarPedido;
begin
  mtPedidos.Append;
  mtPedidoscodigo.AsInteger      := 0;
  mtPedidoscodigo_cli.AsInteger  := StrToIntDef(edtCodigoCliente.Text, 0);
  mtPedidosdat_pedido.AsDateTime := Date;
  mtPedidosnome.AsString         := edtNomeCliente.Text;
  mtPedidoscidade.AsString       := ModelPesquisa.qryPessoascidade.AsString;
  mtPedidosuf.AsString           := ModelPesquisa.qryPessoasuf.AsString;
  mtPedidos.Post;
end;

procedure TfPrincipal.grdProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  ConfExclusao : Integer;
begin
  try
    if Key = VK_DELETE then
    begin
      ConfExclusao := Application.MessageBox('Confirma a exclusão deste produto?', 'Atenção', MB_YesNo+mb_DefButton2+mb_IconQuestion);
      if ConfExclusao = IDYes then
        mtItensPedidos.Delete;
    end
    else
    if Key = VK_RETURN then
    begin
      mtItensPedidos.Edit;
      edtCodProduto.Text  := mtItensPedidoscodigo_prod.AsString;
      edtNomeProduto.Text := mtItensPedidosdescricao.AsString;
      edtQtd.Text         := mtItensPedidosqtd_produto.AsString;
      edtValUnitario.Text := FormatCurr('0.00', mtItensPedidosval_produto.AsCurrency);
      edtValTotal.Text    := FormatCurr('0.00', mtItensPedidosval_total.AsCurrency);
      edtQtd.SetFocus;
    end;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TfPrincipal.LimparItens;
begin
  edtCodProduto.Clear;
  edtNomeProduto.Clear;
  edtQtd.Clear;
  edtValUnitario.Clear;
  edtValTotal.Clear;
  edtCodProduto.SetFocus;
end;

procedure TfPrincipal.PesquisarCliente(ACampo: String);
begin
  try
    if (ModelPesquisa.PesquisarCliente(ACampo, ACampo, edtCodigoCliente.Text, 'ViewClientes')) then
    begin
       edtCodigoCliente.Text := ModelPesquisa.qryPessoascodigo.AsString;
       edtNomeCliente.Text   := ModelPesquisa.qryPessoasnome.AsString;
       pnlDados.Enabled      := True;
       edtCodProduto.SetFocus;

       GravarPedido;
    end
    else
    begin
      ShowMessage('Cliente não localizado !!!!');
      edtCodigoCliente.Clear;
      edtNomeCliente.Clear;
      edtCodigoCliente.SetFocus;
      pnlDados.Enabled := False;
    end;
  finally
    ModelPesquisa.qryPessoas.Close;
    ModelPesquisa.qryPessoas.SQL.Text := ModelPesquisa.gSQLOri;
  end;
end;

procedure TfPrincipal.PesquisarProduto;
begin
  try
    if (ModelPesquisa.PesquisarProduto('codigo', 'codigo', edtCodProduto.Text, 'ViewProdutos')) then
    begin
      edtCodProduto.Text    := ModelPesquisa.qryProdutoscodigo.AsString;
      edtNomeProduto.Text   := ModelPesquisa.qryProdutosdescricao.AsString;
      edtValUnitario.Text   := FormatCurr('0.00', ModelPesquisa.qryProdutosval_venda.AsCurrency);
      edtQtd.Text           := '1';
      edtQtd.SetFocus;

      mtItensPedidos.Append;
    end
    else
    begin
      ShowMessage('Produto não localizado !!!!');
      edtCodProduto.Clear;
      edtNomeProduto.Clear;
      edtQtd.Clear;
      edtValUnitario.Clear;
      edtValTotal.Clear;
      edtCodProduto.SetFocus;
    end;
  finally
    ModelPesquisa.qryProdutos.Close;
    ModelPesquisa.qryProdutos.SQL.Text := ModelPesquisa.gSQLOri;
  end;

end;

end.
