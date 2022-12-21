unit Model.Dados;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  System.JSON,
  System.UITypes,
  System.JSON.Writers,
  System.JSON.Readers,
  System.JSON.Types,
  System.NetEncoding,
  System.Variants,
  System.StrUtils,
  System.Math,
  System.Generics.Collections,

  Data.DB,
  Vcl.Forms,

  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TModelDados = class(TDataModule)
    conWK: TFDConnection;
    linWK: TFDPhysMySQLDriverLink;
    qryInc: TFDQuery;
    qryAux: TFDQuery;
    qryExec: TFDQuery;
    qryPedidos: TFDQuery;
    qryItensPedido: TFDQuery;
    qryItensPedidocodigo: TFDAutoIncField;
    qryItensPedidocodigo_ped: TIntegerField;
    qryItensPedidocodigo_prod: TIntegerField;
    qryItensPedidoqtd_produto: TIntegerField;
    qryItensPedidoval_produto: TFMTBCDField;
    qryItensPedidoval_total: TFMTBCDField;
    qryItensPedidodescricao: TStringField;
    qryPedidoscodigo: TIntegerField;
    qryPedidoscodigo_cli: TIntegerField;
    qryPedidosdat_pedido: TDateField;
    qryPedidosval_pedido: TFMTBCDField;
    qryPedidosnome: TStringField;
    qryPedidoscidade: TStringField;
    qryPedidosuf: TStringField;
    usqlPedidos: TFDUpdateSQL;
    usqlItensPedido: TFDUpdateSQL;
    qryAux2: TFDQuery;
    procedure conWKBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetNextIDFromTable(ATabela, ACampo, ACondicao: String): Integer;
    function GetNextIDFromTableSTR(ATabela, ACampo, ACondicao: String; AQtdZeros: Integer): String;

    function GerarJSONPedido(AdtPedido: TFDMemTable; AdtItensPedido: TFDMemTable): TJSONObject;
    function InserirPedido(AJSON: TJSONObject): Boolean;
  end;

var
  ModelDados: TModelDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TModelDados.conWKBeforeConnect(Sender: TObject);
var
  Arq: TIniFile;
  Path: string;
begin
  Path  := ExtractFilePath(Application.ExeName)+'Config.ini';
  Arq   := TIniFile.Create(Path);
  try
    conWK.Params.Values['Server'   ] := Arq.ReadString('Banco', 'Server', 'localhost');
    conWK.Params.Values['Database' ] := Arq.ReadString('Banco', 'Database', 'wk_teste');
    conWK.Params.Values['user_name'] := Arq.ReadString('Banco', 'UserName', 'wk');
    conWK.Params.Values['password' ] := Arq.ReadString('Banco', 'Password', 'wk@1q2w3e');
    conWK.Params.Values['port'     ] := Arq.ReadString('Banco', 'Port', '3306');

    linWK.VendorLib := Arq.ReadString('Banco', 'Lib', '');
  finally
    Arq.DisposeOf;
  end;
end;

function TModelDados.GerarJSONPedido(AdtPedido: TFDMemTable; AdtItensPedido: TFDMemTable): TJSONObject;
var
  StrAux  : TStringWriter;
  TxtJSON : TJSONTextWriter;
begin
  StrAux  := TStringWriter.Create;
  TxtJSON := TJsonTextWriter.Create(StrAux);

  try
    try
      TxtJSON.Formatting := TJsonFormatting.Indented;

      //Cabeçalho do Pedido
      TxtJSON.WriteStartObject;
      TxtJSON.WritePropertyName('codigo');
      TxtJSON.WriteValue(AdtPedido.FieldByName('codigo').AsInteger);

      TxtJSON.WritePropertyName('codigo_cli');
      TxtJSON.WriteValue(AdtPedido.FieldByName('codigo_cli').AsInteger);

      TxtJSON.WritePropertyName('dat_pedido');
      TxtJSON.WriteValue(FormatDateTime('DD/MM/YYYY', AdtPedido.FieldByName('dat_pedido').AsDateTime));

      TxtJSON.WritePropertyName('val_pedido');
      TxtJSON.WriteValue(AdtPedido.FieldByName('val_pedido').AsFloat);

      TxtJSON.WritePropertyName('nome');
      TxtJSON.WriteValue(AdtPedido.FieldByName('nome').AsString);

      TxtJSON.WritePropertyName('cidade');
      TxtJSON.WriteValue(AdtPedido.FieldByName('cidade').AsString);

      TxtJSON.WritePropertyName('uf');
      TxtJSON.WriteValue(AdtPedido.FieldByName('uf').AsString);

      //Itens
      TxtJSON.WritePropertyName('itens');
      TxtJSON.WriteStartArray; //Array Itens

      AdtItensPedido.First;

      while not AdtItensPedido.Eof do
      begin
        TxtJSON.WriteStartObject; //Objeto Item

        TxtJSON.WritePropertyName('codigo');
        TxtJSON.WriteValue(AdtItensPedido.FieldByName('codigo').AsInteger);

        TxtJSON.WritePropertyName('codigo_ped');
        TxtJSON.WriteValue(AdtItensPedido.FieldByName('codigo_ped').AsInteger);

        TxtJSON.WritePropertyName('codigo_prod');
        TxtJSON.WriteValue(AdtItensPedido.FieldByName('codigo_prod').AsInteger);

        TxtJSON.WritePropertyName('qtd_produto');
        TxtJSON.WriteValue(AdtItensPedido.FieldByName('qtd_produto').AsFloat);

        TxtJSON.WritePropertyName('val_produto');
        TxtJSON.WriteValue(AdtItensPedido.FieldByName('val_produto').AsFloat);

        TxtJSON.WritePropertyName('val_total');
        TxtJSON.WriteValue(AdtItensPedido.FieldByName('val_total').AsFloat);

        AdtItensPedido.Next;
        TxtJSON.WriteEndObject; //Objeto item
      end;

      TxtJSON.WriteEndArray;  //Array Pedido / Itens
      TxtJSON.WriteEndObject; //Objeto Pedido

      Result := TJSONObject.ParseJSONValue(StrAux.ToString) as TJSONObject;
    except
      Result := nil;
    end;
  finally
    StrAux.DisposeOf;
    TxtJSON.DisposeOf;
  end;
end;

function TModelDados.GetNextIDFromTable(ATabela, ACampo, ACondicao: String): Integer;
const
  cSQL = 'SELECT COALESCE(MAX(%s), 0) +1 AS NEW_ID FROM %s %s ';
begin
  try
    qryInc.Close;
    qryInc.SQL.Clear;
    qryInc.SQL.Text := Format(cSQL, [ACampo, ATabela, ACondicao]);
    qryInc.Open();
    Result := qryInc.FieldByName('NEW_ID').AsInteger;
  finally
    qryInc.Close;
  end;
end;

function TModelDados.GetNextIDFromTableSTR(ATabela, ACampo, ACondicao: String; AQtdZeros: Integer): String;
const
  cSQL = 'SELECT LPAD(COALESCE(MAX(CAST(%s AS UNSIGNED)),0) +1, %d, ''0'') AS NEW_CODE FROM %s %s';
begin
  try
    qryInc.Close;
    qryInc.SQL.Clear;
    qryInc.SQL.Text := Format(cSQL, [ACampo, AQtdZeros, ATabela, ACondicao]);
    qryInc.Open();
    Result := qryInc.FieldByName('NEW_CODE').AsString;
  finally
    qryInc.Close;
  end;
end;


function TModelDados.InserirPedido(AJSON: TJSONObject): Boolean;
const
  INS_PEDIDO = 'INSERT INTO pedidos ( '+
               '   codigo,            '+
               '   codigo_cli,        '+
               '   dat_pedido,        '+
               '   val_pedido)        '+
               ' VALUES (             '+
               '   :codigo,           '+
               '   :codigo_cli,       '+
               '   :dat_pedido,       '+
               '   :val_pedido)       ';

  UPD_PEDIDO = 'UPDATE pedidos SET            '+
               '  codigo_cli = :codigo_cli ,  '+
               '  dat_pedido = :dat_pedido ,  '+
               '  val_pedido = :val_pedido    '+
               'WHERE codigo = :codigo        ';

  INS_ITENS = 'INSERT INTO pedidositens ( '+
              '  codigo_ped,              '+
              '  codigo_prod,             '+
              '  qtd_produto,             '+
              '  val_produto,             '+
              '  val_total)               '+
              'VALUES (                   '+
              '  :codigo_ped,             '+
              '  :codigo_prod,            '+
              '  :qtd_produto,            '+
              '  :val_produto,            '+
              '  :val_total)              ';
var
  lPedidoObj: TJSONObject;
  lItem: TJSONArray;
  lIdPedido: Integer;
  I: Integer;
  lDataPedido: TDateTime;
  lqtdItens: Integer;
begin
  try
    {Pegar o JSON}
    lPedidoObj := AJSON;

    try
      conWK.StartTransaction;

      qryAux.Active := False;
      qryAux.SQL.Clear;

      if lPedidoObj.GetValue<Integer>('codigo') = 0 then
      begin
        qryAux.SQL.Text := INS_PEDIDO;
        lIdPedido       := GetNextIDFromTable('pedidos', 'codigo', '');
      end
      else
      begin
        qryAux.SQL.Text := UPD_PEDIDO;
        lIdPedido       := lPedidoObj.GetValue<Integer>('codigo');
      end;

      qryAux.ParamByName('codigo').AsInteger        := lIdPedido;
      qryAux.ParamByName('codigo_cli').AsInteger    := lPedidoObj.GetValue<Integer>('codigo_cli');
      qryAux.ParamByName('dat_pedido').AsDateTime   := StrToDateTime(lPedidoObj.GetValue<string>('dat_pedido'));
      qryAux.ParamByName('val_pedido').AsFloat      := lPedidoObj.GetValue<double>('val_pedido');
      qryAux.ExecSQL;

      lItem := (lPedidoObj.GetValue<TJSONArray>('itens'));

      if lPedidoObj.GetValue<Integer>('codigo') > 0 then
      begin
        qryExec.ExecSQL(Format('DELETE FROM pedidositens WHERE codigo_ped = %d ', [lPedidoObj.GetValue<Integer>('codigo')]));
      end;

      qryAux.Active := False;
      qryAux.SQL.Clear;
      qryAux.SQL.Text := INS_ITENS;

      for I := 0 to lItem.Count - 1 do
      begin
        qryAux.ParamByName('codigo_ped').AsInteger  := lIdPedido;
        qryAux.ParamByName('codigo_prod').AsInteger := (lItem.Items[I] as TJSONObject).GetValue<integer>('codigo_prod');
        qryAux.ParamByName('qtd_produto').AsFloat   := (lItem.Items[I] as TJSONObject).GetValue<Double>('qtd_produto');
        qryAux.ParamByName('val_produto').AsFloat   := (lItem.Items[I] as TJSONObject).GetValue<Double>('val_produto');
        qryAux.ParamByName('val_total').AsFloat     := (lItem.Items[I] as TJSONObject).GetValue<Double>('val_total');
        qryAux.ExecSQL;
      end;

      conWK.Commit
    except
      on E: Exception do
      begin
        conWK.Rollback
      end;
    end;
  finally

  end;
end;

end.
