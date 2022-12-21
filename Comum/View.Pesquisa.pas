unit View.Pesquisa;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,
  System.StrUtils,
  System.Math,

  FireDAC.Comp.Client,

  Data.DB,

  Vcl.Menus,
  Vcl.StdCtrls,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.Grids,
  Vcl.DBGrids;


type
  TViewPesquisa = class(TForm)
    pnlAcoes: TPanel;
    dsoPesquisa: TDataSource;
    grbPesquisa: TGroupBox;
    lblPesquisa: TLabel;
    sbutFiltrar: TSpeedButton;
    sbutLimparFiltro: TSpeedButton;
    combCampos: TComboBox;
    combCondicao: TComboBox;
    editFiltro: TEdit;
    grdPesquisa: TDBGrid;
    btnOk: TBitBtn;
    btnCancelar: TBitBtn;
    btnCadastro: TBitBtn;
    procedure sbutFiltrarClick(Sender: TObject);
    procedure sbutLimparFiltroClick(Sender: TObject);
    procedure combCamposPropertiesEditValueChanged(Sender: TObject);
    procedure editFiltroKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdPesquisaDblClick(Sender: TObject);
    procedure grdPesquisaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FconModel: TFDConnection;
    FPesquisa: TFDQuery;
    FField: TField;
    FFormName: String;
    FSQLOri: String;

    procedure ListFields;
    procedure Filter;
    procedure SearchFields;

    procedure FilterClear;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AFDConnection: TFDConnection; AFDQuery: TFDQuery; AFormName: String; ASQLPadrao: String = '');reintroduce;overload;

  end;

var
  ViewPesquisa: TViewPesquisa;

implementation

{$R *.dfm}

procedure TViewPesquisa.combCamposPropertiesEditValueChanged(Sender: TObject);
begin
  SearchFields;
end;

constructor TViewPesquisa.Create(AOwner: TComponent; AFDConnection: TFDConnection; AFDQuery: TFDQuery; AFormName: String; ASQLPadrao: String = '');
begin
  inherited Create(AOwner);

  FconModel := AFDConnection;
  FPesquisa := AFDQuery;
  FFormName := AFormName;
  FSQLOri   := IfThen(ASQLPadrao.Trim.IsEmpty, FPesquisa.SQL.Text, ASQLPadrao);

  dsoPesquisa.DataSet := FPesquisa;
  ListFields;
  SearchFields;
  Filter;
end;

procedure TViewPesquisa.FilterClear;
begin
  editFiltro.Clear;
  FPesquisa.Open(FSQLOri);
end;

procedure TViewPesquisa.grdPesquisaDblClick(Sender: TObject);
begin
  Close;
end;

procedure TViewPesquisa.grdPesquisaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Close;
end;

procedure TViewPesquisa.SearchFields;
var
  Cont : Integer;
begin
  try
    for Cont := 0 to FPesquisa.FieldCount -1 do
      if FPesquisa.Fields[Cont].DisplayLabel = combCampos.Text then
      begin
        FField := FPesquisa.Fields[Cont];
      end;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TViewPesquisa.editFiltroKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if editFiltro.Text = '' then
    FilterClear
  else
    Filter;
end;

procedure TViewPesquisa.ListFields;
var
  Cont : Integer;
begin
  try
    combCampos.Items.Clear;
    for Cont := 0 to FPesquisa.FieldCount -1 do
    begin
      if FPesquisa.Fields[Cont].Tag = 1 then
        combCampos.Items.Add(FPesquisa.Fields[Cont].DisplayName);
    end;

    if combCampos.Items.Count = 0 then
      combCampos.Items.Add(FPesquisa.Fields[0].DisplayName)
    else
      combCampos.ItemIndex := 0;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TViewPesquisa.sbutFiltrarClick(Sender: TObject);
begin
  Filter;
end;

procedure TViewPesquisa.sbutLimparFiltroClick(Sender: TObject);
begin
  FilterClear;
end;

procedure TViewPesquisa.Filter;
var
  SQL,
  Condicao,
  Valor: String;
begin
  sbutFiltrar.Enabled      := False;
  sbutLimparFiltro.Enabled := False;

  try
    case combCondicao.ItemIndex of
      0: Condicao := ' LIKE ';
      1: Condicao := ' = ';
      2: Condicao := ' >= ';
      3: Condicao := ' <= ';
      4: Condicao := ' > ';
      5: Condicao := ' < ';
      6: Condicao := ' <> ';
    end;
    if editFiltro.Text <> '' then
    begin
      SQL := FSQLOri;
      SQL := SQL + IfThen(Pos('WHERE', SQL) > 0, ' AND ', ' WHERE ');

      if FField.DataType in [ftTimeStamp, ftDateTime, ftDate] then
      begin
        Valor := editFiltro.Text;
        try
          StrToDate(Valor);
          Valor := FormatDateTime('yyyy-mm-dd', StrToDate(Valor)).QuotedString;
        except
          ShowMessage('Data inválida. Favor verifique');
          editFiltro.SetFocus;
          editFiltro.Clear;
          Exit;
        end;
      end
      else if FField.DataType in [ftString, ftWideString, ftMemo] then
      begin
        if combCondicao.ItemIndex = 0 then
          Valor := QuotedStr(editFiltro.Text+'%')
        else
          Valor := QuotedStr(editFiltro.Text);
      end
      else if FField.DataType in [ftFloat, ftCurrency, ftSmallint, ftInteger, ftFMTBcd] then
      begin
        try
          if combCondicao.ItemIndex = 0 then
            Valor := QuotedStr(editFiltro.Text+'%')
          else
            Valor := QuotedStr(editFiltro.Text);

          Valor := StringReplace(Valor, '.', '', [rfReplaceAll]);
          Valor := StringReplace(Valor, ',', '.', [rfReplaceAll]);

          StrToFloat(Valor);
        except
          ShowMessage('Valor inválido. Favor verifique');
          editFiltro.SetFocus;
          editFiltro.Clear;
          Exit;
        end;
      end;

      SQL := SQL + FField.Origin +' '+ Condicao +' '+ Valor;
      FPesquisa.Close;
      FPesquisa.Open(SQL);
    end
    else
      FPesquisa.Open(FSQLOri);
  finally
    sbutFiltrar.Enabled      := True;
    sbutLimparFiltro.Enabled := True;
  end;

end;

end.
