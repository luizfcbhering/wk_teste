unit Comum.Funcoes;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Win.Registry,
  System.IniFiles,
  System.Win.ComObj,
  System.Json,
  System.StrUtils,
  System.Generics.Collections,

  pngimage,

  Data.DB,
  Data.SqlExpr,
  Datasnap.Win.MConnect,
  Datasnap.Win.SConnect,
  Datasnap.DBClient,
  Data.Win.ADODB,

  Vcl.StdCtrls,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Samples.Spin,
  Vcl.Mask,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.Graphics,

  Winapi.Windows,
  Web.dbWeb,

  Xml.XMLDoc,
  Xml.XMLIntf,

  IdHashMessageDigest,
  cxTreeView;

type
  TConsisteInscricaoEstadual  = function (const Insc, UF: String): Integer; stdcall;
  TVersaoDLL                  = function : Integer; stdcall;


//Constantes globais
const
      str                 = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
      gstMascCNPJ         = '99.999.999/9999-99;1;_';        // Máscara para CNPJ
      gstCPF              = '999.999.999-99;1;_';            // Máscara para CPF
      gstMunicipal        = '999.999/999-9;1;_';             // Máscara para Inscrição Municipal
      gstEstadual         = '999.999.999.999;1;_';           // Máscara para Inscrição Estadual
      gstPIS              = '';                              // Máscara Código PIS
      gstData             = '00/00/0099';                    // Máscara para Data
      gstCTPS             = '9999999';                       // Máscara Número CTPS
      gstSerieCTPS        = '99999';                         // Máscara Número de Série CTPS
      gstTituloEleitoral  = '9999-9999-9999';                // Máscara Título de Eleitor
      gstDataFormato      = 'dd/mm/yyyy';
      gstMesAno           = '99/99';
      gstHora             = '00:00';
      gstHoraFormato      = 'hh:mm';
      gstMascCBO          = '9999-99';
      gstMascCNAE         = '9999-9';
      gstMascQuant        = '###0';
      gstMascQuant1       = '###,##0.00';
      gstMascPerc         = '##0.00';
      gstMascTel          = '(##)####-####';
      gstMascValor        = '###,###,###,##0.00';            // Máscara para valor
      gstMascCEP          = '#####-###;1;_';                 // Mascara do CEP
      gstCodigoCid        = '00-00000;1;_';                  // Mascara Codigo Cidade
      gstFatorConv        = '03/07/2000';                    // Data padrão para fator de conversão Boleto Bancário
      gstDirectory        = 'Software\Printers\Licence';     // Diretório do Registro do sistema
      gstDirectory2       = 'Software\Printers\Licence';     // Diretório do Registro do sistema
      gcCor1              = $00F4FFFF;                       // Amarelo claro
      gcCor2              = $00F4FFF0;                       // Verde Claro
      gcCor3              = $00F8F3F1;                       // Azul Claro
      gcCor4              = $00EEEDD9;                       // Azul Grid
      gcCor5              = $00BC8F67;                       // Azul Intermediario
      gcCor6              = $00C9A585;                       // Azul Antigo
      Chave               = 16854;
      Cripto_1            = 33598;
      Cripto_2            = 24219;

      //Lista de caracteres especiais
      xCarExt: array[1..50] of string = ('<','>','!','@','#','$','%','¨','&','*',
                                         '(',')','_','+','=','{','}','[',']','?',
                                         ';',':',',','|','*','"','~','^','´','`',
                                         '¨','æ','Æ','ø','£','Ø','ƒ','ª','º','¿',
                                         '®','½','¼','ß','µ','þ','ý','Ý','-','.');
      //Lista de caracteres acentuados
      xCarEsp: array[1..38] of String = ('á', 'à', 'ã', 'â', 'ä','Á', 'À', 'Ã', 'Â', 'Ä',
                                         'é', 'è','É', 'È','í', 'ì','Í', 'Ì',
                                         'ó', 'ò', 'ö','õ', 'ô','Ó', 'Ò', 'Ö', 'Õ', 'Ô',
                                         'ú', 'ù', 'ü','Ú','Ù', 'Ü','ç','Ç','ñ','Ñ');
      //Lista de caracteres para troca
      xCarTro: array[1..38] of String = ('a', 'a', 'a', 'a', 'a','A', 'A', 'A', 'A', 'A',
                                         'e', 'e','E', 'E','i', 'i', 'I', 'I',
                                         'o', 'o', 'o','o', 'o','O', 'O', 'O', 'O','O',
                                         'u', 'u', 'u','U','U', 'U','c','C','n','N');

var
  vgliNumUsuario,
  vgliEmpresa,
  vgliNumGrupo: Largeint;

  vgstUsuario,
  vgstEmpresa,
  vgstCodigo,
  vgstPessoa,
  vgstDistribuidor,
  vgstCaminhoArqs,
  vgstImagem,
  vgstImagemRel,
  vgstRodape,
  vgstSistema,
  vgstSkinName,
  vgstEstruturaPlano,
  vgstHost : String;

  vgblMultiTela : Boolean;

  vgimLogoRel: TPngImage;

  vginTabelaPDV,
  vginPorta,
  vginTabs,
  vginTabsCount,
  ValorConvX,
  ValorConvY : Integer;//Código de barras

function MessageDlgCheck(Msg :String; AType: TMsgDlgType; AButtons : TMsgDlgButtons;
                         IndiceHelp : LongInt; DefButton : TModalResult; Portugues: Boolean;
                         Checar : Boolean; MsgCheck : String; Funcao : TProcedure) : Word;

function ZerosEsquerda(sTexto: string; nTamanho: byte): String;
function TirarMascaras(const sValor :String):String;
function RetirarMascaras(const Texto: String): String;
function AtribuirMascaras(DataSet :TClientDataSet): Boolean;
function AtribuirCaixaAlta(Form : TForm): Boolean;
function AjustarTexto(aTexto: String):String;
function RetiraAcento(var sTexto : String):String;
function MontarString(aTexto, aSubStr: string): string;
function ProcuraExata(aTexto, aSubStr: string): Integer;
function TrocaCaracterEspecial(aTexto : string; aLimExt : Boolean) : string;
//Função para substituir caracteres especiais.
function RetirarCaracterEspecial(aTexto : string): string;

function ValidarInscEstadual(NumInscricao, UF : String) : Boolean;
function Verifica_CGC(const Cgc: string): boolean;
function Verifica_CPF(NumCPF: string): boolean;
function Verifica_PIS(pis: String): Boolean;
function SomenteNumeros(Const sValor :String):String;

function TemDiscoNoDrive(const drive : char): boolean;
function Arredondamento(Numero, Arredondamento: Double): Double;
function Arredonda(Numero, Decimais: Double): Double;
function PreencheDecimal(sTexto : string):string;

function Replicate(sTexto: string; nTamanho: integer): String;
function Incrementa(aNomeTabela, aCampo, aCondicao : String ;aConnect : TADOConnection): Double;overload;
function Incrementa(aNomeTabela, aCampo, aCondicao : String ;aConnect : TSQLConnection): Largeint;overload;
function Incrementa(aNomeTabela, aCampo, aCondicao : String; aTamanho: Integer; aConnect : TSQLConnection): String;overload;
function IncrementaII(aNomeTabela, aCampo : String ;aConnect : TADOConnection): Double;
function IncrementaIII(aNomeTabela, aCampo : String ;aConnect : TSQLConnection): Double;
function Extenso(Valor: Double; Singular, Plural: string): string;
function ExtNum(Str_Valor: string): string;

//Código de Barras
function ConvX(Medida : Double) : Integer;
function ConvY(Medida : Double) : Integer;
procedure Interleaved2of5(Canvas: TCanvas; Numero: String; PosX,PosY: Integer;Altura: Double);
procedure Code39(Canvas: TCanvas; Numero:String; PosX, PosY : Integer; Altura : Double);
function CalculaDigito(Numero : String): Char;
procedure EAN13(Canvas: TCanvas; Numero:String; PosX, PosY : Integer; Altura : Double);
//Fim do código de barras

function GetLogin(): String;
function GetMachine(): String;
function GetVersaoArq(aModoVisualizacao : Integer): string;

// Retorna o nº do mes da data informada.
function Month(Data : TDateTime) : Word;
// Retorna o ano de uma data informada.
function Year(Data : TDateTime) : Word;
// Retorna o Dia de uma data informada.
function Day(Data : TDateTime) : Word;
// Retorna o número de meses entre duas datas, considerando a fração de 15 dias
// como 1 (um) mês para efeito de cálculos da folha de pagamento
function Func_nMes(dataInicial,dataFinal:TDateTime):integer;
// Retorna o número de meses entre duas datas
function Func_numMeses(dataInicial,dataFinal:TDateTime):integer;
// Retorna o número de meses entre duas datas, considerando a fração de 15 dias corridos
// como 1 (um) mês para efeito de cálculos da folha de pagamento
function Func_nMesCorridos(dataInicial,dataFinal:TDateTime; DiasMes :Integer):integer;
{Retorna a maior data anterior a uma data inválida}
function MenorDataValida (Ano, Mes, Dia : Word) : TDateTime;
{Retorna uma data no Mês seguinte a uma data informada}
function NextMonth (Data : TDateTime) : TDateTime;
{Retorna data do primeiro dia do mês, ou primeiro dia útil, de uma data informada}
function FirstDayOfMonth (Data : TDateTime; lSabDom : Boolean) : TDateTime;
{Retorna data do último dia do mês, ou último dia útil, de uma data informada}
function LastDayOfMonth (Data : TDateTime; lSabDom : Boolean) : TDateTime;
{Retorna data do último dia do mês de uma data informada}
function LastDayOfMonth2 (Data : TDateTime) : TDateTime;
{Retorna o dia da semana por extenso}
function DiaExtenso (dData : TDateTime) : string;
{Retorna o extenso do mes passado por parametro}
function MesExtenso(xMes : Variant) : string;
{Retorna o extenso de uma data informada}
function DataExtenso (dData : TDateTime) : string;
{Verifica se uma data informada cai em um final de semana}
function IsWeekEnd (dData : TDateTime) : boolean;
{Verifica se string informada é uma data válida}
function IsDate(dData : String) : Boolean;
{Verifica se uma data informada cai em um Domingo}
function IsSunday (dData : TDateTime) : boolean;
{Retorna o próximo dia útil caso a data informada caia em um fim de semana}
function ProximoDiaUtil (dData : TDateTime) : TDateTime;
{Retorna o último dia útil caso a data informada caia em um fim de semana}
function DiaUtilAnterior (dData : TDateTime) : TDateTime;
{Retorna uma data acrescida de "xMeses" meses, podendo ser corrido ou não}
function SomaMes (dData : TDateTime; xMeses : Integer; lCorrido : boolean) : TDateTime;
{Retorna uma data reduzida de "xMeses" meses, podendo ser corrido ou não}
function DiminuiMes (dData : TDateTime; xMeses : Integer; lCorrido : Boolean) : TDateTime;
// Retorna o número de dias úteis entre duas datas
function nDiasUteis(dDataInicial, dDataFinal : TDateTime):Byte;
// Retorna o número de dias úteis entre duas datas - Desconsidera o Domingo
function nDiasUteis2(dDataInicial, dDataFinal : TDateTime):Byte;
// Se as datas são da mesma semana
function MesmaSemana(dDataInicial, dDataFinal : TDateTime):Boolean;
// Retorna o número de  Domingos
function nDiasInuteis(dDataInicial, dDataFinal : TDateTime):Byte;
// Retorna o número de dias úteis entre duas datas
function nDiasCorridos(dDataInicial, dDataFinal : TDateTime):Byte;
// extrai os valores(número e valor) dos eventos Bases de uma lista de strings
function ExtractBaseLista(Linha: String; var nEvento,Valor,nFolha,nFunc :Double) :Integer;
// retorna True se atualiza a lista de Bases
function AtualizaBasesLista(ListaBasesIn,ListaBasesOut :TStringList;nFolha,nFunc:Double) :Boolean;

procedure GeraCodigoBarra(sBanco, sCodConvBco, sDataVenc, sValor : String; var sCodigoBarra:String);
procedure GeraLinhaDigitada(sBanco, sCodConvBco, sDataVenc, sValor : String; var sLinhaDigitada:String);

procedure SaveRegistry(NameForm: TObject);
procedure LoadRegistry(NameForm: TObject);
procedure SaveRegisterApplication(aStatus : Double);
function  VerifyRegisterApplication(aDate : Double; aNovaData : Boolean): Boolean;
function  LoadRegisterApplication : Double;
function  GetRegisterApplication : Double;

procedure MapadeTroco(Valor: Double; var Num100, Num50, Num20, Num10, Num5,
                      Num2, Num1, Num050, Num025, Num010, Num005, Num001: Integer);

procedure CalculaDigitoVerificador(vlstCodigo :String; var vlinDV :Integer);
procedure CalculaDigitoMod11(vlstCodigo :String; var vlinDV :Integer);
procedure CalculaDigitoCodBarra(vlstCodigo :String; var vlinDV :Integer);

procedure ExpDOC(DataSet: TDataSet; Arq: string);
procedure ExpXLS(DataSet: TDataSet; Arq: string);
procedure ExpXML(DataSet : TDataSet; Arq : string);
procedure ExpTXT(DataSet: TDataSet; Arq: string);
procedure ExpHTML(DataSet: TDataSet; Arq: string);

function GetModuleFullName: string;
function GetModuleFileName: string;
function GetModuleIniFileName: string;
function GetModulePath: string;

function VerificaNivelSupConta(CodConta : String): String;
function VerificaMascara(var Codigo: String; const Mascara: String): Boolean;

function BuscaTrocaFuncoes(aStr : String; aStrBusca : Array of String;
                           aStrTroca : Array of String) : String;
function AbreArqWord(aPathArq : String) : Boolean;
procedure GerarContrato(const aCodContrato : String; aDataSet : TClientDataSet);

function GerarSenha(aDate : Double): String;
function ValidarSenha(aSenha : String; var aData : String): Boolean;

function Criptografar(aTexto: String): String;
function Descriptografar(aTexto: String): String;

procedure StreamToOleVariant(aStream: TMemoryStream; var aResult: OleVariant);
procedure OleVariantToStream(const aVariant: OleVariant; const Result: TMemoryStream);

function SendFileStream(aPath: String): OleVariant;
procedure ReceiveFileStream(aPath: String; aFile: OleVariant);

procedure CarregarConfiguracores;
procedure SalvarConfiguracores;
function Operador(aSQL: string): string;

function MD5String(const Value: string): string;

procedure MontarArvoreUsuario(aTree: TcxTreeView; aNumPai: Integer;
  aNode: TTreeNode; aDataSet: TClientDataSet);

procedure MontarArvoreAcesso(aTree: TcxTreeView; aNumPai: Integer;
  aNode: TTreeNode; aDataSet: TClientDataSet);

function ParseJSonArray(aJSonArray: TJSONArray; aFull: Boolean = False):TStringList;

function RetornarElementoJSON(aJSonArray: TJSONArray; aCampo: string): string;

procedure MontarJSonArray(aValueType, aOperator, aValue: String; aJSonArray: TJSONArray;
  aEmpty: Boolean = False);

procedure LimparJSonArray(aJSonArray: TJSONArray);

procedure ClonarJSON(aJSONOrigem, aJSONDestino: TJSONArray; aClear: Boolean = True);

//function VerificaConta(CodConta : String): String;

implementation

function Replicate(sTexto: string; nTamanho: integer): String;
var
  i : integer;
begin
  if (sTexto = '') or (nTamanho < 1) then
    begin
      result := '';
      exit;
    end;
  sTexto := copy(sTexto,1,1);
  i := 1;
  While i < nTamanho do
    begin
      sTexto := sTexto + copy(sTexto,1,1);
      inc(i);
    end;
  result := sTexto;
end;

function PreencheDecimal(sTexto : string):string;
var aux : integer;
begin
  result := sTexto;
  aux  := pos(',',sTexto);
  if aux <> 0 then
    begin
      if sTexto[aux + 2] = '' then
        result := sTexto + '0';
    end
  else
    result := sTexto + '00';
end;

function TemDiscoNoDrive(const drive : char): boolean;
var
  DriveNumero : byte;
  EMode : word;
begin
  result := false;
  DriveNumero := ord(Drive);
  if DriveNumero >= ord('a') then
    dec(DriveNumero,$20);
    EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    if DiskSize(DriveNumero-$40) <> -1 then
      Result := true
    else messagebeep(0);
  finally
    SetErrorMode(EMode);
  end;
end;

procedure LoadRegistry(NameForm: TObject);
var
  X: Integer;
  vurtRgstry :TRegistry;
  vlstDir: String;
begin
  vurtRgstry         := TRegistry.Create;
  vlstDir            := gstDirectory+'\'+vgstSistema+TForm(NameForm).Name;
  vurtRgstry.RootKey := HKEY_CURRENT_USER;
  vurtRgstry.OpenKey(vlstDir, True);
  try
     for X:= 0 To TForm(NameForm).ComponentCount -1 do
       begin
         if vurtRgstry.ValueExists(TForm(NameForm).Components[X].Name) then
            begin
               if TForm(NameForm).Components[X] is TRadioGroup then
                  TRadioGroup(TForm(NameForm).Components[X]).ItemIndex:= StrToInt(vurtRgstry.ReadString(TForm(NameForm).Components[X].Name));
               if TForm(NameForm).Components[X] is TEdit then
                  TEdit(TForm(NameForm).Components[X]).Text:= vurtRgstry.ReadString(TForm(NameForm).Components[X].Name);
               if TForm(NameForm).Components[X] is TComboBox then
                  TComboBox(TForm(NameForm).Components[X]).Text:=  vurtRgstry.ReadString(TForm(NameForm).Components[X].Name);
               if TForm(NameForm).Components[X] is TDateTimePicker then
                  TDateTimePicker(TForm(NameForm).Components[X]).DateTime:= StrToDate(vurtRgstry.ReadString(TForm(NameForm).Components[X].Name));
               if TForm(NameForm).Components[X] is TSpinEdit then
                  TSpinEdit(TForm(NameForm).Components[X]).Value:= StrToInt(vurtRgstry.ReadString(TForm(NameForm).Components[X].Name));
               if TForm(NameForm).Components[X] is TMemo then
                  TMemo(TForm(NameForm).Components[X]).Text:= vurtRgstry.ReadString(TForm(NameForm).Components[X].Name);
               if TForm(NameForm).Components[X] is TMaskEdit then
                  TMaskEdit(TForm(NameForm).Components[X]).Text:= vurtRgstry.ReadString(TForm(NameForm).Components[X].Name);
               if TForm(NameForm).Components[X] is TCheckBox then
                  TCheckBox(TForm(NameForm).Components[X]).Checked:= vurtRgstry.ReadString(TForm(NameForm).Components[X].Name) = 'TRUE';
               if TForm(NameForm).Components[X] is TRadioButton then
                  TRadioButton(TForm(NameForm).Components[X]).Checked:= vurtRgstry.ReadString(TForm(NameForm).Components[X].Name) = 'TRUE';
            end;
       end;
  except
    {Nao retirar o try, pois caso tenha data em branco ou valores integers em branco nao trava dando erros}
  end;
  vurtRgstry.Free;
end;

procedure SaveRegisterApplication(aStatus : Double);
var
  vurtRgstry :TRegistry;
begin
  vurtRgstry         := TRegistry.Create;
  vurtRgstry.RootKey := HKEY_CURRENT_USER;
  vurtRgstry.OpenKey(gstDirectory, True);
  try
    vurtRgstry.WriteFloat('ActiveSession', aStatus);
  finally
    vurtRgstry.Free;
  end;
end;

function LoadRegisterApplication : Double;
var
  vurtRgstry : TRegistry;
begin
  Result := 0;

  vurtRgstry         := TRegistry.Create;
  vurtRgstry.RootKey := HKEY_CURRENT_USER;
  vurtRgstry.OpenKey(gstDirectory, True);

  try
    if vurtRgstry.ValueExists('ActiveSession') then
      Result := vurtRgstry.ReadFloat('ActiveSession');

    if Result <> -155 then
    begin
      Result := 0;
      Exit;
    end;

    if vurtRgstry.ValueExists('FloatActiveSession') then
      Result := vurtRgstry.ReadFloat('FloatActiveSession')
    else
    begin
      Result := 0;
      Exit;
    end;

    if Result <= Date then
    begin
      vurtRgstry.WriteFloat('ActiveSession', Trunc(Date));
      Result := 0;
    end;

  finally
    vurtRgstry.Free;
  end;
end;

function GetRegisterApplication : Double;
var
  vurtRgstry : TRegistry;
begin
  vurtRgstry         := TRegistry.Create;
  vurtRgstry.RootKey := HKEY_CURRENT_USER;
  vurtRgstry.OpenKey(gstDirectory, True);

  try
    if vurtRgstry.ValueExists('FloatActiveSession') then
      Result := vurtRgstry.ReadFloat('FloatActiveSession')
    else
    begin
      Result := 0;
      Exit;
    end;
  finally
    vurtRgstry.Free;
  end;
end;

function VerifyRegisterApplication(aDate : Double; aNovaData : Boolean): Boolean;
var
  vurtRgstry :TRegistry;
begin
  vurtRgstry         := TRegistry.Create;
  vurtRgstry.RootKey := HKEY_CURRENT_USER;
  vurtRgstry.OpenKey(gstDirectory, True);
  try
    if aNovaData then
    begin
      vurtRgstry.WriteFloat('ActiveSession', -155);
      vurtRgstry.WriteFloat('FloatActiveSession', aDate);
    end
    else
    begin
      if not vurtRgstry.ValueExists('ActiveSession') then
        vurtRgstry.WriteFloat('ActiveSession', -155);

      if not vurtRgstry.ValueExists('FloatActiveSession') then
        vurtRgstry.WriteFloat('FloatActiveSession', aDate);
    end;
  finally
    vurtRgstry.Free;
    Result := False;
  end;
end;

procedure SaveRegistry(NameForm: TObject);
var
  X: Integer;
  vlstDir: String;
  vurtRgstry :TRegistry;
begin
  vurtRgstry         := TRegistry.Create;
  vlstDir            := gstDirectory+'\'+vgstSistema+TForm(NameForm).Name;
  vurtRgstry.RootKey := HKEY_CURRENT_USER;
  vurtRgstry.OpenKey(vlstDir, True);

  for X:= 0 to TForm(NameForm).ComponentCount -1 do
    begin
       if TForm(NameForm).Components[X] is TRadioGroup then
          vurtRgstry.WriteString(Trim(TRadioGroup(TForm(NameForm).Components[X]).Name), IntToStr(TRadioGroup(TForm(NameForm).Components[X]).ItemIndex));
       if TForm(NameForm).Components[X] is TEdit then
          vurtRgstry.WriteString(Trim(TEdit(TForm(NameForm).Components[X]).Name), TEdit(TForm(NameForm).Components[X]).Text);
       if TForm(NameForm).Components[X] is TComboBox then
          vurtRgstry.WriteString(Trim(TComboBox(TForm(NameForm).Components[X]).Name), TComboBox(TForm(NameForm).Components[X]).Text);
       if TForm(NameForm).Components[X] is TDateTimePicker then
          vurtRgstry.WriteString(Trim(TDateTimePicker(TForm(NameForm).Components[X]).Name), DateToStr(TDateTimePicker(TForm(NameForm).Components[X]).DateTime));
       if TForm(NameForm).Components[X] is TSpinEdit then
          vurtRgstry.WriteString(Trim(TSpinEdit(TForm(NameForm).Components[X]).Name), IntToStr(TSpinEdit(TForm(NameForm).Components[X]).Value));
       if TForm(NameForm).Components[X] is TMemo then
          vurtRgstry.WriteString(Trim(TMemo(TForm(NameForm).Components[X]).Name), TMemo(TForm(NameForm).Components[X]).Text);
       if TForm(NameForm).Components[X] is TMaskEdit then
          vurtRgstry.WriteString(Trim(TMaskEdit(TForm(NameForm).Components[X]).Name), TMaskEdit(TForm(NameForm).Components[X]).Text);
       if TForm(NameForm).Components[X] is TCheckBox then
          if TCheckBox(TForm(NameForm).Components[X]).Checked then
             vurtRgstry.WriteString(Trim(TCheckBox(TForm(NameForm).Components[X]).Name), 'TRUE')
          Else
             vurtRgstry.WriteString(Trim(TCheckBox(TForm(NameForm).Components[X]).Name), 'FALSE');
       if TForm(NameForm).Components[X] is TRadioButton then
          if TRadioButton(TForm(NameForm).Components[X]).Checked then
             vurtRgstry.WriteString(Trim(TRadioButton(TForm(NameForm).Components[X]).Name), 'TRUE')
          Else
             vurtRgstry.WriteString(Trim(TRadioButton(TForm(NameForm).Components[X]).Name), 'FALSE');
    end;
  vurtRgstry.Free;
end;

//Procedimento responsável pelo cálculo do dígito verificador
//Para qualquer tamanho de vldoCodigo
procedure CalculaDigitoMod11(vlstCodigo :String; var vlinDV :Integer);
var vlstaux, vlstaux1, vlinresto, vlinsoma, vliny, vlina, vlini :Integer;
    vlstcod :String;
begin
  vlstaux1  := 0;
  vlinsoma  := 0;
  vliny     := 9;
  vlstcod   := vlstCodigo;
  vlina     := length(vlstcod);
  for vlini := length(vlstcod) downto 1 do
    begin
      vlstaux  := StrToInt(vlstcod[vlina])*vliny;
      vlstaux1 := vlstaux1 + vlstaux;
      vlinsoma := vlinsoma + vlstaux1;
      vliny    := vliny - 1;
      if vliny = 2 then
        vliny  := 9;
    end;
  vlinresto  := vlinsoma mod 11; //Obter o resto
  vlinDV     := vlinresto;       //Retornar resultado
end;

procedure CalculaDigitoCodBarra(vlstCodigo :String; var vlinDV :Integer);
var vlstaux, vlstaux1, vlinresto, vlinsoma, vliny, vlina, vlini :Integer;
    vlstcod               :String;
begin
  vlstaux1  := 0;
  vlinsoma  := 0;
  vliny     := 2;
  vlstcod   := vlstCodigo;
  vlina     := length(vlstcod);
  for vlini := length(vlstcod) downto 1 do
    begin
      vlstaux  := StrToInt(vlstcod[vlina])*vliny;
      vlstaux1 := vlstaux1 + vlstaux;
      vlinsoma := vlinsoma + vlstaux1;
      vliny    := vliny + 1;
      if vliny = 9 then
        vliny  := 2;
    end;
  vlinresto  := vlinsoma mod 11; //Obter o resto
  vlinDV     := vlinresto;       //Retornar resultado
end;

procedure CalculaDigitoVerificador(vlstCodigo :String; var vlinDV :Integer);
var vlinresto, vlinsoma, vliny, vlina, vlini       :Integer;
    vlstaux, vlstaux1, vlstcod, vlstcodigosemponto :String;
begin
  for vlini := 1 to length(vlstCodigo) do
  begin
    if ( (vlstCodigo[vlini] >= '0') and (vlstCodigo[vlini] <= '9') ) then
      vlstcodigosemponto := vlstcodigosemponto + vlstCodigo[vlini];
  end;
  vlinsoma := 0;
  vliny    := 2;
  vlstcod  := vlstcodigosemponto;
  vlina    := length(vlstcod);
  for vlini := 1 to length(vlstcod) do
    begin
      vlstaux := IntToStr(StrToInt(vlstcod[vlina])*vliny);
      if length(vlstaux) = 1 then
        vlstaux1 := vlstaux
      else
        vlstaux1 := IntToStr(StrToInt(vlstaux[1]) + StrToInt(vlstaux[2]) );
      vlinsoma := vlinsoma + StrToInt(vlstaux1);
      vliny := vliny + 1;
      vlina := vlina - 1;
    end;
    vlinresto := vlinsoma mod 10;  //Obter o resto
    if vlinresto = 0 then
      vlinresto := 10;
    vlinDV := 10 - vlinresto;      //Retornar resultado
end;

function Verifica_CGC(const Cgc: string): boolean;
var bDig: array[1..12] of byte;
    bCont, bDig1, bDig2, bResto,
    bCon1, bCon2, bCon3: Word;
    sCGC :String;
begin
  Result := False;
  sCgc   := TirarMascaras(Cgc);

  if Length(sCgc) = 14 then
  begin
    for bCont:=1 to 12 do
      if CharInSet(sCgc[bCont], ['0'..'9']) then
         bDig[bCont] := StrToInt(sCgc[bCont])
      else exit;
    bCon1 := 5*bDig[1] + 4*bDig[2] + 3*bDig[3] + 2*bDig[4] + 9*bDig[5] +
             8*bDig[6] + 7*bDig[7] + 6*bDig[8] + 5*bDig[9] + 4*bDig[10]+
             3*bDig[11] + 2*bDig[12];
    bCon2 := bCon1 div 11;
    bCon3 := bCon2 * 11;
    bResto := bCon1 - bCon3;
    if bResto in [0,1] then
       bDig1 := 0
    else
       bDig1 := 11 - bResto;
    bCon1 := (6*bDig[1]) + (5*bDig[2]) + (4*bDig[3]) + (3*bDig[4]) + (2*bDig[5]) +
             (9*bDig[6]) + (8*bDig[7]) + (7*bDig[8]) + (6*bDig[9]) + (5*bDig[10])+
             (4*bDig[11]) + (3*bDig[12]) + (2*bDig1);
    bCon2 := bCon1 div 11;
    bCon3 := bCon2 * 11;
    bResto := bCon1 - bCon3;
    if bResto in [0,1] then
      bDig2 := 0
    else
      bDig2  := 11 - bResto;
    Result := (bDig1 = StrToInt(sCgc[13])) and (bDig2 = StrToInt(sCgc[14]));
//    Result := True;
  end;
end;

function ZerosEsquerda(sTexto: string; nTamanho: byte): String;
var i: byte;
    sNumero: String;
begin
  if length(sTexto) > 0 then
  begin
    if length(sTexto) > nTamanho then
      Result := copy(sTexto,1,nTamanho)
    else
    begin
      for i:=1 to nTamanho - length(sTexto) do
        sNumero := sNumero+'0';
      Result := sNumero + sTexto;
    end;
  end
  else
    Result := copy('00000000000000000000',2,nTamanho);
end;

function TirarMascaras(Const sValor :String):String;
var
  i, iTam :Integer;
begin
  Result := '';
  iTam := Length(sValor);
  for i:= 1 to iTam do
    begin
      if (CharInSet(sValor[i], ['0'..'9'])) or (CharInSet(UpCase(sValor[i]), ['A'..'Z'])) then
        Result := Result + sValor[i];
    end;
end;

function Verifica_CPF(NumCPF: String): Boolean;
//	* Testa validade o CPF digitado
//	LOCAL Codigo,Contador,Multiplicador,Soma,Digito1,Digito2
var Contador, Multiplicador, Soma,
    Digito1N,          { Representação numérica do primeiro DV  }
    Digito2N: integer; { Representação numérica  dos dois DV's  }
    NumeroCPF, { Representação  dos   DV's  inferidos do  parâmetro  de  entrada  (NumCPF)}
    Codigo, { Representação do primeiro DV  }
    Digito1,{ Representação dos  dois DV's  }
    Digito2: string;
begin
  Result    := False;

  if Trim(TirarMascaras(NumCPF)) = '' then Exit;

  NumeroCPF := NumCPF;

  { Para uniformizar  o  formato  do  Número do CPF, retira-se
    pontos e traços que existirem nas strings com 14 caracteres}

  case Length(TrimRight(NumCPF)) of
  11: begin
        Codigo:=copy(NumCPF,10,2);
        NumeroCPF:=copy(NumCPF,1,9);
      end;
  14: begin
        Codigo:=copy(NumeroCPF,13,2);
        NumeroCPF:=Copy(NumeroCPF,1,3)+Copy(NumeroCPF,5,3)+Copy(NumeroCPF,9,3);
      end;
  end;

  Contador      := 1;
  Multiplicador := 10;
  Soma          := 0;

  while Contador <= 9 do
  begin
    Soma := Soma + strtoint(copy(NumeroCPF,contador,1))*Multiplicador;
    Inc(Contador);
    Dec(Multiplicador);
  end;
//	* Soma tem a sominha
//	Digito1=11-mod(Soma,11)
  Digito1N := 11 - ( soma mod 11 );
  Digito1:=IntToStr(Digito1N);
  if Digito1N >= 10 then
  begin
    NumeroCPF:=NumeroCPF + '0';
    Digito1 := '0';
  end
  else
    NumeroCPF:=NumeroCPF+Digito1;

  Contador       := 1;
  Multiplicador  := 11;
  Soma           := 0;

  while contador <= 10 do
  begin
    Soma := Soma + strtoint(copy(NumeroCPF,Contador,1))*Multiplicador;
    Inc(Contador);
    Dec(Multiplicador);
  end;
//	* Soma tem a sominha de novo
//	Digito2=11-mod(Soma,11)
  Digito2N := 11 - (Soma mod 11);
  Digito2  := IntToStr(Digito2N);

  if Digito2N >= 10 then
    Digito2 := Digito1 + '0'
  else
    Digito2 := Digito1 + Digito2;

  if Codigo = Digito2 then
    Result:= True;
end;

function SomenteNumeros(Const sValor :String):String;
var i,iTam :Integer;
begin
  Result := '';
  iTam := Length(sValor);
  for i:= 1 to iTam do
    begin
      if CharInSet(sValor[i], ['0'..'9']) then
        Result := Result + sValor[i];
    end;
end;

function AtribuirMascaras(DataSet :TClientDataSet): Boolean;
var
  Cont :Integer;
begin
  Result := True;
  for Cont := 0 to DataSet.FieldCount -1 do
  begin
    if (DataSet.Fields[Cont] is TDateField) and (pos ('DAT_', TDateField(DataSet.Fields[Cont]).FieldName) > 0) then
    begin
      TDateField(DataSet.Fields[Cont]).EditMask      := gstData;
      TDateField(DataSet.Fields[Cont]).DisplayFormat := gstDataFormato;
    end
    else if (DataSet.Fields[Cont] is TTimeField) and (pos ('HOR_', TDateField(DataSet.Fields[Cont]).FieldName) > 0) then
    begin
      TDateField(DataSet.Fields[Cont]).EditMask      := gstHora;
      TDateField(DataSet.Fields[Cont]).DisplayFormat := gstHoraFormato;
    end
    else if (DataSet.Fields[Cont] is TFloatField) then
    begin
      if pos ('VAL_', TFloatField(DataSet.Fields[Cont]).FieldName) > 0 then
        TFloatField(DataSet.Fields[Cont]).DisplayFormat := gstMascValor
      else if pos ('QTD_', TFloatField(DataSet.Fields[Cont]).FieldName) > 0 then
        TFloatField(DataSet.Fields[Cont]).DisplayFormat := gstMascQuant1
      else if pos ('PER_', TFloatField(DataSet.Fields[Cont]).FieldName) > 0 then
        TFloatField(DataSet.Fields[Cont]).DisplayFormat := gstMascPerc;
    end;
  end;
end;

function AtribuirCaixaAlta(Form : TForm): Boolean;
begin
 Result := True;
//
end;

function AjustarTexto(aTexto: String):String;
var
 Posicao   : Integer;
 NovoTexto : string;
 Texto: string;
begin
  Texto := LowerCase(aTexto);
  for Posicao := 1 to Length(Texto) do
    begin
      if Posicao = 1 then
        begin
          NovoTexto := UpperCase(Texto[1]);
        end
      else
        begin
          if CharInSet(Texto[Posicao - 1], [' ', '-', '_']) then
            begin
              NovoTexto := NovoTexto + UpperCase(Texto[Posicao]);
            end
          else
            NovoTexto := NovoTexto + Texto[Posicao]
        end;
    end;
  Result := NovoTexto;
end;

function RetiraAcento(var sTexto:String):String;
// Funcao que retira caracteres especiais, acentos, cedilha e retorna o texto
// integral, sem esses caracteres.
// Analista : Washington
// Data     : 04-10-2002
var
  vlstTextoAlterado : String;
  vlinCont          : Integer;
  vlchCaracter      : Char;
begin
  for vlinCont := 1 to length(sTexto) do
    begin
      vlchCaracter := sTexto[vlinCont];// Altera Copy(sTexto,i,1);
      Case vlchCaracter of
        'À','Á','Ã','Â','Ä': vlstTextoAlterado := vlstTextoAlterado + 'A';
        'à','á','ã','â','ä': vlstTextoAlterado := vlstTextoAlterado + 'a';
        'È','É','Ê','Ë'    : vlstTextoAlterado := vlstTextoAlterado + 'E';
        'è','é','ê','ë'    : vlstTextoAlterado := vlstTextoAlterado + 'e';
        'Ì','Í','Î','Ï'    : vlstTextoAlterado := vlstTextoAlterado + 'I';
        'ì','í','î','ï'    : vlstTextoAlterado := vlstTextoAlterado + 'i';
        'Ò','Ó','Õ','Ô','Ö': vlstTextoAlterado := vlstTextoAlterado + 'O';
        'ò','ó','õ','ô','ö': vlstTextoAlterado := vlstTextoAlterado + 'o';
        'Ù','Ú','Û','Ü'    : vlstTextoAlterado := vlstTextoAlterado + 'U';
        'ù','ú','û','ü'    : vlstTextoAlterado := vlstTextoAlterado + 'u';
        'Ç'                : vlstTextoAlterado := vlstTextoAlterado + 'C';
        'ç'                : vlstTextoAlterado := vlstTextoAlterado + 'c';
        'Ñ'                : vlstTextoAlterado := vlstTextoAlterado + 'N';
        'ñ'                : vlstTextoAlterado := vlstTextoAlterado + 'n';
        'Ÿ'                : vlstTextoAlterado := vlstTextoAlterado + 'Y';
        'ÿ'                : vlstTextoAlterado := vlstTextoAlterado + 'y';
        'ª'                : vlstTextoAlterado := vlstTextoAlterado + 'a';
        'º'                : vlstTextoAlterado := vlstTextoAlterado + 'o';
        '.'                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        '/'                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        '_'                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        '-'                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        ':'                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        '='                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        '('                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        ')'                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        '['                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        ']'                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        '{'                : vlstTextoAlterado := vlstTextoAlterado + ' ';
        '}'                : vlstTextoAlterado := vlstTextoAlterado + ' ';
      else
        vlstTextoAlterado := vlstTextoAlterado + vlchCaracter;
      end;
    end;
  RetiraAcento := vlstTextoAlterado ;
end;
procedure GeraCodigoBarra(sBanco, sCodConvBco, sDataVenc, sValor : String;  var sCodigoBarra : String);
var
  vlstBanco,vlstConvBco, vlstMoeda, vlstValor, vlstCampoLiv, vlstNossoNro,
  vlstServico, vlstCodBarSemDiv,vlstDataVenc : string;
  vldlFatorVenc : double ;
  vldtFatorVenc : TdateTime;
  vlinDV : integer;
begin
  vlstBanco        := sBanco;
  vlstConvBco      := sCodConvBco;// Nro Convenio do bco
  vlstMoeda        := '9' ; // real
  vlstCampoLiv     := '';
  vlstNossoNro     := '00000000000000000';// 17 zeros
  vlstServico      := '21'; // Servico
  vlstValor        := PreencheDecimal(sValor) ;
  vlstValor        := TirarMascaras(Replicate('0',10-Length(vlstValor))) + vlstValor;
  vlstDataVenc     := sDataVenc;
  vlstCampoLiv     := vlstConvBco + vlstNossoNro + vlstServico ;
  vldtFatorVenc    := StrToDate(sDataVenc) - StrToDate(gstFatorConv)+ 1000 ;
  vldlFatorVenc    := vldtFatorVenc ;
  vlstCodBarSemDiv := vlstBanco + vlstMoeda + FloatToStr(vldlFatorVenc) + vlstValor + vlstCampoLiv;
  CalculaDigitoCodBarra(vlstCodBarSemDiv,vlinDV);
  sCodigoBarra     := vlstBanco + vlstMoeda + IntToStr(vlinDV) + FloatToStr(vldlFatorVenc) + vlstValor + vlstCampoLiv;
end;

procedure GeraLinhaDigitada(sBanco, sCodConvBco, sDataVenc, sValor : String; var sLinhaDigitada: String);
var
  vlstBanco,vlstConvBco, vlstMoeda, vlstValor, vlstCampoLiv, vlstNossoNro,
  vlstServico, vlstCodBarSemDiv, vlstDataVenc, vlstPriCamp, vlstSecCamp,
  vlstTercCamp, vlstQuarCamp, vlstQuinCamp: string;
  vldlFatorVenc : double ;
  vldtFatorVenc : TdateTime;
  vlinDVGeral, vlinPriDV, vlinSecDV, vlinTercDV    : integer;
begin
  vlstBanco := sBanco;
  vlstConvBco := sCodConvBco;// Nro Convenio do bco
  vlstMoeda := '9' ; // real
  vlstCampoLiv := '';
  vlinPriDV    := 0;
  vlinSecDV    := 0;
  vlinTercDV   := 0;
  vlstNossoNro := '00000000000000000';// 17 zeros
  vlstServico  := '21'; // Servico
  vlstCampoLiv := vlstConvBco + vlstNossoNro + vlstServico ;
  vlstValor    := preencheDecimal(sValor) ;
  vlstValor    := TirarMascaras(Replicate('0',10-Length(vlstValor)));
  vlstDataVenc := sDataVenc;
  vlstPriCamp  := vlstBanco + vlstMoeda + Copy(vlstCampoLiv,1,5); //DV

  CalculaDigitoMod11(vlstPriCamp,vlinPriDV);
  vlstPriCamp  := vlstPriCamp + IntToStr(vlinPriDV);
  vlstPriCamp  := Copy(vlstPriCamp,1,5) + '.' + Copy(vlstPriCamp,6,Length(vlstPriCamp));

  vlstSecCamp  := Copy(vlstCampoLiv,6,10);
  CalculaDigitoMod11(vlstSecCamp,vlinSecDV);
  vlstSecCamp  := vlstSecCamp + IntToStr(vlinSecDV);
  vlstSecCamp  := Copy(vlstSecCamp,1,5) + '.' + Copy(vlstSecCamp,6,Length(vlstSecCamp));

  vlstTercCamp := Copy(vlstCampoLiv,16,10);
  CalculaDigitoMod11(vlstTercCamp,vlinTercDV);
  vlstTercCamp := vlstTercCamp + IntToStr(vlinTercDV);
  vlstTercCamp := Copy(vlstTercCamp,1,5) + '.' + Copy(vlstTercCamp,6,Length(vlstTercCamp));

  vlstValor     := preencheDecimal(sValor) ;
  vlstValor     := TirarMascaras(Replicate('0',10-Length(vlstValor)));
  vlstDataVenc  := sDataVenc;
  vldtFatorVenc := StrToDate(sDataVenc) - StrToDate(gstFatorConv)+ 1000 ;
  vldlFatorVenc := vldtFatorVenc ;
  vlstCodBarSemDiv := vlstBanco + vlstMoeda + FloatToStr(vldlFatorVenc) +
                      vlstValor + vlstCampoLiv;
  CalculaDigitoCodBarra(vlstCodBarSemDiv,vlinDVGeral);
  vlstQuarCamp  := IntToStr(vlinDVGeral);

  vldtFatorVenc := StrToDate(sDataVenc) - StrToDate(gstFatorConv)+ 1000 ;
  vldlFatorVenc := vldtFatorVenc ;
  vlstValor     := preencheDecimal(sValor) ;
  vlstValor     := TirarMascaras(Replicate('0',10-Length(vlstValor)));
  vlstQuinCamp  := FloatToStr(vldlFatorVenc) + vlstValor;

  sLinhaDigitada := vlstPriCamp + ' ' + vlstSecCamp + ' ' + vlstTercCamp + ' ' +
                    vlstQuarCamp + ' ' + vlstQuinCamp ;

end;

function Arredondamento(Numero, Arredondamento: Double): Double;
var
  Fracao, Arred,
  Resto: Double;
begin
 Result := Numero;
 Fracao := Frac(Numero);
 Arred  := Frac(Arredondamento);
 if (Arred <> 0) then
   begin
//     Resto  := Fracao - Round(Fracao/Arred) * Arred;
     if Frac(Fracao/Arred) = 0 then
       Exit;
     if (Round(Fracao/Arred) = Int(Fracao/Arred)) then
        Resto  := ((Round(Fracao/Arred) + 1) - (Fracao/Arred)) * Arred
     else
        Resto  := ((Round(Fracao/Arred)) - (Fracao/Arred)) * Arred;
     Result := Numero + Resto;
   end
 else
   Result := Numero + (1-Fracao);
end;

function Arredonda(Numero, Decimais: Double): Double;
var
   Fracao, Inteiro :Double;
   Resto : String;
begin
  Fracao  := Frac(Numero);
  Inteiro := Int(Numero);
  Resto   := FloatToStrF(Fracao,ffNumber,13,Trunc(Decimais));
  Result  := Inteiro + StrToFloat(Resto);
end;

procedure MapadeTroco(Valor: Double; var Num100, Num50,
  Num20, Num10, Num5, Num2, Num1, Num050, Num025, Num010, Num005,
  Num001: Integer);
begin
  Num100 := 0;
  Num50  := 0;
  Num20  := 0;
  Num10  := 0;
  Num5   := 0;
  Num2   := 0;
  Num1   := 0;
  Num050 := 0;
  Num025 := 0;
  Num010 := 0;
  Num005 := 0;
  Num001 := 0;

  if (Valor/100 >= 1) then
    Num100 := Trunc(Int(Valor/100));
  Valor  := Valor - (100 * Num100);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/50 >= 1) then
    Num50  := Trunc(Int(Valor/50));
  Valor  := Valor - (50 * Num50);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/20 >= 1) then
    Num20  := Trunc(Int(Valor/20));
  Valor  := Valor - (20 * Num20);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/10 >= 1) then
    Num10  := Trunc(Int(Valor/10));
  Valor  := Valor - (10 * Num10);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/5 >= 1) then
    Num5   := Trunc(Int(Valor/5));
  Valor  := Valor - (5 * Num5);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/2 >= 1) then
    Num2   := Trunc(Int(Valor/2));
  Valor  := Valor - (2 * Num2);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/1 >= 1) then
    Num1   := Trunc(Int(Valor/1));
  Valor  := Valor - (1 * Num1);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/(1/2) >= 1) then
    Num050 := Trunc(Int(Valor/(1/2)));
  Valor  := Valor - ((1/2) * Num050);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/(1/4) >= 1) then
    Num025 := Trunc(Int(Valor/(1/4)));
  Valor  := Valor - ((1/4) * Num025);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/(1/10) >= 1) then
    Num010 := Trunc(Int(Valor/(1/10)));
  Valor  := Valor - ((1/10) * Num010);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/(1/20) >= 1) then
    Num005 := Trunc(Int(Valor/(1/20)));
  Valor  := Valor - ((1/20) * Num005);
  Valor  := StrToFloat(FloatToStrF(Valor,ffNumber,13,2));

  if (Valor/(1/100) >= 1) then
    Num001 := Trunc(Int(Valor/(1/100)));
end;

function Verifica_PIS(pis : String) : boolean;
var
  Cont, Soma, Dig, CrpPis, Digito : Integer;
begin
  Result := False;
  try
    if (pis <> '') Then
    begin
      crppis := strtoint(copy(pis, 11, 1));
      soma := 0;
      dig := 2;
      for cont := 1 to 10 do
      begin
        soma := soma + (dig *strtoint(copy(pis,11 - cont, 1)));
        if dig < 9 then
        begin
          dig := dig+1
        end
        else
        begin
          dig := 2;
        end;
      end;
      digito := 11 - (soma MOD 11);
      if digito > 9 then
      begin
        digito := 0;
      end;
      if crppis = digito then
      begin
        Result := true;
      end
      else
      begin
        Result := false;
      end;
    end;
  except
    result := False;
  end;
end;

// Retorna o Dia de uma data informada.
function Day(Data : TDateTime) : Word;
var Ano,Mes,Dia : word;
begin
  DecodeDate(Data,Ano,Mes,Dia);
  Day := Dia;
end;

// Retorna o nº do mes da data informada.
function Month(Data : TDateTime) : Word;
var Ano,Mes,Dia : word;
begin
  DecodeDate(Data,Ano,Mes,Dia);
  Month := Mes;
end;

// Retorna o ano da data informada
function Year(Data : TDateTime) : Word;
var Ano,Mes,Dia : word;
begin
  DecodeDate(Data,Ano,Mes,Dia);
  Year := Ano;
end;

// Retorna o nº de meses entre duas datas, considerando a fração de 15 ou mais dias
// como 1 mês para efeito de cálculos trabalhistas
function Func_nMes(dataInicial,dataFinal:TDateTime):integer;
var xMeses, Resto  : Integer;
begin
  xMeses := Round((dataFinal - dataInicial) / 30);
  resto  := Round((dataFinal - dataInicial) / 30 - xMeses);
  result := xMeses;
  if resto >= 15 then
    inc(result);
end;

// Retorna o nº de meses entre duas datas, considerando a fração de 15 ou mais dias
// como 1 mês para efeito de cálculos trabalhistas
function Func_numMeses(dataInicial,dataFinal:TDateTime):integer;
var
  xMeses : Integer;
begin
  xMeses := Round((dataFinal - dataInicial) / 30);
  result := xMeses;
end;

// Retorna o nº de meses entre duas datas, considerando a fração de 15 dias corridos
// como 1 mês para efeito de cálculos trabalhistas
function Func_nMesCorridos(dataInicial,dataFinal:TDateTime; DiasMes : Integer):integer;
var
  xMeses : Integer;
  Resto  : Double;
begin
  xMeses := Round((dataFinal - dataInicial) / 30);
  Resto  := (((dataFinal - dataInicial+1) / 30) - xMeses) * DiasMes;
  Result := xMeses;
  if Resto >= 15 then
    inc(result);
end;

// Retorna o número de meses entre duas datas, considerando a fração de 15 dias
// como 1 (um) mês para efeito de cálculos da folha de pagamento
function nDiasUteis(dDataInicial, dDataFinal : TDateTime):Byte;
var I : Byte;
begin
  I := 0;
  While dDataInicial <= dDataFinal do
    begin
      if not isWeekEnd(dDataInicial) then
        inc(I);
      dDataInicial := dDataInicial +1;
    end;
    nDiasUteis := I;
end;

// Retorna o número de dias úteis entre duas datas - Desconsidera o Domingo
function nDiasUteis2(dDataInicial, dDataFinal : TDateTime):Byte;
var I : Byte;
begin
  I := 0;
  While dDataInicial <= dDataFinal do
    begin
      if not IsSunday(dDataInicial) then
        inc(I);
      dDataInicial := dDataInicial +1;
    end;
    nDiasUteis2 := I;
end;

// Retorna o número de domingos entre duas datas
function nDiasInuteis(dDataInicial, dDataFinal : TDateTime):Byte;
var I : Byte;
begin
  I := 0;
  While dDataInicial <= dDataFinal do
    begin
      if IsSunday(dDataInicial) then
        Inc(I);
      dDataInicial := dDataInicial +1;
    end;
    nDiasInuteis := I;
end;

function nDiasCorridos(dDataInicial, dDataFinal : TDateTime):Byte;
var I : Byte;
begin
  I := 0;
  While dDataInicial <= dDataFinal do
    begin
      inc(I);
      dDataInicial := dDataInicial +1;
    end;
  Result := I;
end;

function MesmaSemana(dDataInicial, dDataFinal : TDateTime):Boolean;
var
  DiaIni, DiaFim : Integer;
begin
  DiaIni := DayOfWeek(dDataInicial);
  DiaFim := DayOfWeek(dDataFinal);
  if (dDataFinal - dDataInicial) >= 7 then
    Result := False
  else
    if DiaFim < DiaIni then
      Result := False
    else
      Result := True;
end;

{Retorna a maior data anterior a uma data inválida}
function MenorDataValida (Ano, Mes, Dia : Word) : TDateTime;
begin
  if Dia = 31 then
     Case mes of
       2: begin
            if ano mod 4 = 0 then
              Dia := Dia - 2
            else
              Dia := Dia - 3;
          end;
       4,6,9,11 : Dec(Dia);
     end;
  if (Mes = 2) and (Dia > 28) then
    begin
      if Ano mod 4 = 0 then
        Dia := 29
      else
        Dia := 28;
    end;
  Result := EncodeDate(Ano,Mes,Dia);
end;

{Retorna uma data no Mês seguinte a uma data informada}
function NextMonth (Data : TDateTime) : TDateTime;
var Ano, Mes, Dia : word;
begin
  DecodeDate(Data, Ano, Mes, Dia);
  if Mes = 12 Then
    begin
      Mes := 1;
      Inc (Ano);
    end
  else
    Inc (Mes);
  NextMonth := MenorDataValida (Ano, Mes, Dia);
end;

{Retorna data do primeiro dia do mês, ou primeiro dia útil, de uma data informada}
function FirstDayOfMonth (Data : TDateTime; lSabDom : Boolean) : TDateTime;
var Ano, Mes, Dia : word;
    DiaDaSemana : Integer;
begin
  DecodeDate (Data, Ano, Mes, Dia);
  Dia := 1;
  if lSabDom Then
  begin
    DiaDaSemana := DayOfWeek (Data);
    if DiaDaSemana = 1 Then
      Dia := 2
    else
      if DiaDaSemana = 7 Then
        Dia := 3;
  end;
  FirstDayOfMonth := EncodeDate (Ano, Mes, Dia);
end;

{Retorna data do último dia do mês, ou último dia útil, de uma data informada}
function LastDayOfMonth (Data : TDateTime; lSabDom : Boolean) : TDateTime;
var Ano, Mes, Dia : word;
AuxData : TDateTime;
DiaDaSemana : Integer;
begin
  AuxData := FirstDayOfMonth (NextMonth (Data), False) - 1;
  if lSabDom Then
  begin
    DecodeDate (Auxdata, Ano, Mes, Dia);
    DiaDaSemana := DayOfWeek (AuxData);
    if DiaDaSemana = 1 Then
      Dia := Dia - 2
    else
      if DiaDaSemana = 7 Then
        Dec (Dia);
    AuxData := EnCodeDate (Ano, Mes, Dia);
  end;
  Result := AuxData;
end;

{Retorna o dia da semana por extenso}
function DiaExtenso (dData : TDateTime) : string;
var xDia : string;
begin
  case DayOfWeek (dData) of
    1: xDia := 'Domingo';
    2: xDia := 'Segunda-feira';
    3: xDia := 'Terça-feira';
    4: xDia := 'Quarta-feira';
    5: xDia := 'Quinta-feira';
    6: xDia := 'Sexta-feira';
    7: xDia := 'Sábado';
  end;
  DiaExtenso := xDia;
end;

{Retorna o extenso do mes passado por parametro}
function MesExtenso (xMes : Variant) : string;
Var Dia, Mes, Ano : Word;
begin
  Mes := 0;
  Case VarType (xMes) of
    VarDate   : DecodeDate (xMes, Ano, Mes, Dia);
    VarString : Try
                  Mes := StrToInt (xMes);
                Except
                End;
  else
    Try
      Mes := Round (xMes);
    Except
    End;
  end;
  case Mes of
    1: Result := 'Janeiro';
    2: Result := 'Fevereiro';
    3: Result := 'Março';
    4: Result := 'Abril';
    5: Result := 'Maio';
    6: Result := 'Junho';
    7: Result := 'Julho';
    8: Result := 'Agosto';
    9: Result := 'Setembro';
    10: Result := 'Outubro';
    11: Result := 'Novembro';
    12: Result := 'Dezembro';
  else
    Result := '';
  end;
end;

{Retorna o extenso de uma data informada}
function DataExtenso (dData : TDateTime) : string;
var Ano, Mes, Dia : word;
begin
  DecodeDate(dData, Ano, Mes, Dia);
  DataExtenso := ZerosEsquerda(FloatToStr(Dia),2) + ' de ' + MesExtenso(Mes) + ' de ' + IntToStr(Ano);
end;

{Verifica se uma data informada cai em um final de semana}
function IsWeekEnd (dData : TDateTime) : boolean;
begin
  result := false;
  if (DayOfWeek(dData) = 1) or (DayOfWeek(dData) = 7) Then
    result := true;
end;

{Verifica se uma data informada cai em um domingo}
function IsSunday (dData : TDateTime) : boolean;
begin
  result := false;
  if (DayOfWeek(dData) = 1) Then
    result := true;
end;

{Retorna o próximo dia útil caso a data informada caia em um fim de semana}
function ProximoDiaUtil (dData : TDateTime) : TDateTime;
begin
  if DayOfWeek(dData) = 7 then
    dData := dData + 2
  else
    if DayOfWeek(dData) = 1 then
      dData := dData + 1;
  ProximoDiaUtil := dData;
end;

{Retorna o último dia útil caso a data informada caia em um fim de semana}
function DiaUtilAnterior (dData : TDateTime) : TDateTime;
begin
  if DayOfWeek(dData) = 7 then
    dData := dData - 1
  else
    if DayOfWeek(dData) = 1 then
      dData := dData - 2;
  DiaUtilAnterior := dData;
end;

{Retorna uma data acrescida de "xMeses" meses, podendo ser corrido ou não}
function SomaMes (dData : TDateTime; xMeses : Integer; lCorrido : boolean) : TDateTime;
var Ano,Mes,Dia : word;
    DataAux : TDateTime;
begin
  DecodeDate(dData, Ano, Mes, Dia);
  Mes := Mes + xMeses;
  Ano := Ano + (Mes DIV 12);
  Mes := Mes mod 12;
  IF Mes = 0 then
    begin
      mes := 12;
      ano := ano -1;
    end;
  DataAux := MenorDataValida (Ano, Mes, Dia);
  if not lCorrido Then
    DataAux := DataAux - 1;
  SomaMes := DataAux;
end;

{Retorna uma data reduzida de "xMeses" meses, podendo ser corrido ou não}
function DiminuiMes (dData : TDateTime; xMeses : Integer; lCorrido : Boolean) : TDateTime;
var Ano, Mes, Dia : word;
    DataAux : TDateTime;
    xMes : SmallInt;
begin
  DecodeDate(dData, Ano, Mes, Dia);
  Ano := Ano - (xMeses DIV 12);
  xMeses := xMeses mod 12;
  xMes := Mes - xMeses;
  if xMes > 0 Then
    Mes := xMes
  else
    begin
      Ano := Ano -1;
      Mes := xMes + 12;
    end;
  DataAux := MenorDataValida (Ano, Mes, Dia);
  if not lCorrido then
    DataAux := DataAux + 1;
  DiminuiMes := DataAux;
end;

function LastDayOfMonth2 (Data : TDateTime) : TDateTime;
var Ano, Mes, Dia : word;
    AuxData       : TDateTime;
begin
  DecodeDate (Data, Ano, Mes, Dia);
  Dia := 1;
  if Mes = 12 then
    begin
      Mes := 1;
      Ano := Ano + 1;
    end
  else
    Mes := Mes + 1;
  AuxData := EnCodeDate (Ano, Mes, Dia) - 1;
  Result := AuxData;
end;

function IsDate(dData : String) : Boolean;
begin
  Result := True;
  try
    StrToDate(dData);
  except
    Application.MessageBox('Data inválida!', 'Erro', MB_OK+MB_ICONERROR);
    Result := False;
  end;
end;

procedure ExpHTML(DataSet: TDataSet; Arq: string);
var
  sl: TStringList;
  dp: TDataSetTableProducer;
begin
  sl := TStringList.Create;
  try
    dp := TDataSetTableProducer.Create(nil);
    try
      DataSet.First;
      dp.DataSet := DataSet;
      dp.TableAttributes.Border := 1;
      sl.Text := dp.Content;
      sl.SaveToFile(Arq);
    finally
      dp.free;
    end;
  finally
    sl.free;
  end;
end;

procedure ExpTXT(DataSet: TDataSet; Arq: string);
var
  i: integer;
  sl: TStringList;
  st: string;
begin
  DataSet.First;
  sl := TStringList.Create;
  try
    st := '';
    for i := 0 to DataSet.Fields.Count - 1 do
      st := st + DataSet.Fields[i].DisplayLabel + ';';
    sl.Add(st);
    DataSet.First;
    while not DataSet.Eof do
    begin
      st := '';
      for i := 0 to DataSet.Fields.Count - 1 do
        st := st + DataSet.Fields[i].DisplayText + ';';
      sl.Add(st);
      DataSet.Next;
    end;
    sl.SaveToFile(Arq);
  finally
     sl.free;
  end;
end;

procedure ExpXML(DataSet : TDataSet; Arq : string);
var
  i: integer;
  xml: TXMLDocument;
  reg, campo: IXMLNode;
begin
  xml := TXMLDocument.Create(nil);
  try
    xml.Active := True;
    DataSet.First;
    xml.DocumentElement :=
      xml.CreateElement('DataSet','');
    DataSet.First;
    while not DataSet.Eof do
    begin
      reg := xml.DocumentElement.AddChild('row');
      for i := 0 to DataSet.Fields.Count - 1 do
      begin
        campo := reg.AddChild(
          DataSet.Fields[i].DisplayLabel);
        campo.Text := DataSet.Fields[i].DisplayText;
      end;
      DataSet.Next;
    end;
    xml.SaveToFile(Arq);
  finally
    xml.free;
  end;
end;

procedure ExpXLS(DataSet: TDataSet; Arq: string);
var
  ExcApp: OleVariant;
  i,l: integer;
begin
  ExcApp := CreateOleObject('Excel.Application');
  ExcApp.Visible := True;
  ExcApp.WorkBooks.Add;
  DataSet.First;
  l := 2;
  DataSet.First;

  for i :=0 to DataSet.FieldCount-1 do
    ExcApp.WorkBooks[1].Sheets[1].Cells[1,i + 1] :=
      DataSet.Fields.Fields[i].DisplayName;
  while not DataSet.EOF do
  begin
    for i := 0 to DataSet.Fields.Count - 1 do
      ExcApp.WorkBooks[1].Sheets[1].Cells[l,i + 1] :=
        DataSet.Fields[i].DisplayText;
    DataSet.Next;
    l := l + 1;
  end;
  ExcApp.WorkBooks[1].SaveAs(Arq);
end;

procedure ExpDOC(DataSet: TDataSet; Arq: string);
var
  WordApp,WordDoc,WordTable,WordRange: Variant;
  Row,Column: integer;
begin
  WordApp := CreateOleobject('Word.basic');
  WordApp.Appshow;
  WordDoc := CreateOleobject('Word.Document');
  WordRange := WordDoc.Range;
  WordTable := WordDoc.tables.Add(
    WordDoc.Range,1,DataSet.FieldCount);
  for Column:=0 to DataSet.FieldCount-1 do
    WordTable.cell(1,Column+1).range.text:=
      DataSet.Fields.Fields[Column].FieldName;
  Row := 2;
  DataSet.First;
  while not DataSet.Eof do
  begin
     WordTable.Rows.Add;
     for Column:=0 to DataSet.FieldCount-1 do
       WordTable.cell(Row,Column+1).range.text :=
         DataSet.Fields.Fields[Column].DisplayText;
     DataSet.next;
     Row := Row+1;
  end;
  WordDoc.SaveAs(Arq);
end;

function MessageDlgCheck(Msg :String; AType: TMsgDlgType; AButtons : TMsgDlgButtons;
IndiceHelp : LongInt; DefButton : TModalResult; Portugues: Boolean; Checar : Boolean; MsgCheck : String; Funcao : TProcedure) : Word;
var
  I         : Integer;
  Mensagem  : TForm;
  Check     : TCheckBox;
begin
     Check := Nil;
     Mensagem := CreateMessageDialog(Msg, AType, Abuttons);
     Mensagem.HelpContext := IndiceHelp;
     with Mensagem do begin
        for i :=0 to ComponentCount -1 do begin
           if (Components[i] is TButton) then begin
              if (TButton(Components[i]).ModalResult = DefButton) then begin
                 ActiveControl := TWincontrol(Components[i]);
              end;
           end;
        end;
        If Portugues Then Begin
           if      Atype = mtConfirmation then Caption := 'Confirmação'
           else if AType = mtWarning      then Caption := 'Aviso'
           else if AType = mtError        then Caption := 'Erro'
           else if AType = mtInformation  then Caption := 'Informação';
        end;
     end;
     If Portugues Then Begin
        TButton(Mensagem.FindComponent('YES')).Caption    := '&Sim';
        TButton(Mensagem.FindComponent('NO')).Caption     := '&Não';
        TButton(Mensagem.FindComponent('CANCEL')).Caption := '&Cancelar';
        TButton(Mensagem.FindComponent('ABORT')).Caption  := '&Abortar';
        TButton(Mensagem.FindComponent('RETRY')).Caption  := '&Repetir';
        TButton(Mensagem.FindComponent('IGNORE')).Caption := '&Ignorar';
        TButton(Mensagem.FindComponent('ALL')).Caption    := '&Todos';
        TButton(Mensagem.FindComponent('HELP')).Caption   := 'A&juda';
     End;
     if Checar then begin
        Mensagem.ClientHeight := Mensagem.ClientHeight + 20;
        Check  := TCheckBox.Create(Mensagem);
        Check.Parent  := Mensagem;
        Check.Left    := 15;
        Check.Top     := Mensagem.ClientHeight - 20;
        Check.Visible := True;
        Check.Caption := MsgCheck;
        Check.Width   := Mensagem.ClientWidth - 10;
     end;
     Result := Mensagem.ShowModal;
     if (Check <> nil) and (Check.Checked) then Funcao;
     Mensagem.Free;
end;

function Incrementa(aNomeTabela, aCampo, aCondicao : String; aConnect : TADOConnection): Double;
var
  vQry : TADOQuery;
begin
  {Cria uma instância do objeto}
  vQry := TADOQuery.Create(nil);
  try
    vQry.Connection := aConnect;
    vQry.SQL.Text := 'SELECT MAX('+aCampo+') FROM '+aNomeTabela + aCondicao;
    vQry.Open;

    if vQry.Fields[0].IsNull then
      Result := 1
    else
      Result := vQry.Fields[0].AsInteger + 1;
  finally
    FreeAndNil(vQry);
  end;
end;

function IncrementaII(aNomeTabela, aCampo : String ;aConnect : TADOConnection): Double;
var
  vQry : TADOQuery;
begin
  {Cria uma instância do objeto}
  vQry := TADOQuery.Create(nil);
  try
    vQry.Connection:= aConnect;
    vQry.SQL.Add('SELECT MAX('+aCampo+') FROM '+aNomeTabela);
    vQry.Open;

    if vQry.Fields[0].IsNull then
      Result := 1
    else
      Result := vQry.Fields[0].AsInteger + 1;
  finally
    FreeAndNil(vQry);
  end;
end;

function IncrementaIII(aNomeTabela, aCampo : String ;aConnect : TSQLConnection): Double;
var
  vQry : TSQLQuery;
begin
  {Cria uma instância do objeto}
  vQry := TSQLQuery.Create(nil);
  try
    vQry.SQLConnection:= aConnect;
    vQry.SQL.Add('SELECT MAX('+aCampo+') FROM '+aNomeTabela);
    vQry.Open;

    if vQry.Fields[0].IsNull then
      Result := 1
    else
      Result := vQry.Fields[0].AsInteger + 1;
  finally
    FreeAndNil(vQry);
  end;
end;

function ValidarInscEstadual(NumInscricao, UF : String) : Boolean;
var
  IRet                      : Integer;
  LibHandle                 : THandle;
  ConsisteInscricaoEstadual : TConsisteInscricaoEstadual;
begin
  LibHandle := LoadLibrary (PChar (Trim ('DllInscE32.Dll')));
  try
    if  LibHandle <=  HINSTANCE_ERROR then
      raise Exception.Create ('Dll não carregada');

    @ConsisteInscricaoEstadual  :=  GetProcAddress (LibHandle, 'ConsisteInscricaoEstadual');
    if  @ConsisteInscricaoEstadual  = nil then
      raise Exception.Create('Entrypoint Download não encontrado na Dll');

    IRet := ConsisteInscricaoEstadual (NumInscricao,UF);

    if IRet = 0 then
      Result := True
    else if IRet = 1 then
      Result := False
    else
      Result := False;
  finally
    FreeLibrary (LibHandle);
  end;
end;

// extrai os valores(número e valor) dos eventos Bases de uma lista de strings
// *** Utilizado na Folha de Pagamento ***
function ExtractBaseLista(Linha: String; var nEvento,Valor,nFolha,nFunc :Double) :Integer;
var vlstValor,vlstLinha :String;
    i,xPos : integer;
begin
  try
    Result := 0;   // Ok
    xPos      := 0;
    vlstLinha := Linha;
    for i := 1 to 4 do
    begin
      inc(xPos);
      vlstLinha := copy(vlstLinha,xPos,length(vlstLinha));
      xPos      := pos(';',vlstLinha);
      if xPos = 0 then
        xPos := length(vlstLinha)+1;
      vlstValor := copy(vlstLinha,1,xPos-1);
      case i of
        1 : nEvento := StrToFloat(vlstValor);
        2 : Valor     := StrToFloat(vlstValor);
        3 : if vlstValor <> '' then
              nFolha := StrToFloat(vlstValor);
        4 : if vlstValor <> '' then
              nFunc  := StrToFloat(vlstValor);
      end;
    end;
  except
    Result := 1;   // Erro
  end;
end;

//  Soma as bases da lista "ListaBaseIn" na lista "ListaBasesOut"
// *** Utilizado na Folha de Pagamento ***
function AtualizaBasesLista(ListaBasesIn,ListaBasesOut :TStringList;nFolha,nFunc:Double) :Boolean;
var
   vldlnFolha1,vldlNumFunc1,vldlnFolha2,vldlNumFunc2,vldlnEvento1,
   vldlnEvento2,vldlValor1,vldlValor2 :Double;
   i,j,vCount :Integer;
begin
  vldlnFolha1  := 0;
  vldlNumFunc1 := 0;
  vldlnFolha2  := 0;
  vldlNumFunc2 := 0;
  try
    Result := True;
    for i := 0 to ListaBasesIn.Count-1 do
    begin
      vCount := 0;
      ExtractBaseLista(ListaBasesIn.Strings[i],vldlnEvento1,vldlValor1,vldlnFolha1,vldlNumFunc1);
      for j := 0 to ListaBasesOut.Count-1 do
      begin
        ExtractBaseLista(ListaBasesOut.Strings[j],vldlnEvento2,vldlValor2,vldlnFolha2,vldlNumFunc2);
        if (vldlnEvento1 = vldlnEvento2) and (vldlnFolha2 = nFolha)
           and (vldlNumFunc2 = nFunc) then
          begin
            ListaBasesOut.Strings[j] := FloatToStr(vldlnEvento1) + ';'
                + FloatToStr(vldlValor1+vldlValor2) + ';' + FloatToStr(nFolha)
                + ';' + FloatToStr(nFunc);
            inc(vCount);
            Break;
          end;
      end;
      if vCount = 0 then
        ListaBasesOut.Add(ListaBasesIn.Strings[i] + ';' + FloatToStr(nFolha)
                + ';' + FloatToStr(nFunc));
    end;
  except
    Result := False;
  end;
end;

//Pega o Login do usuário no Windows
//Retornos: Login Name
function GetLogin(): String;
var lSize: DWord;
begin
    //Seta o tamanho
    lsize := 255;
    SetLength(Result, lSize);
    //Pega o nome do Usuário
    GetUserName(PChar(Result), lSize);
    //Retorna o Login
    Result := String(PChar(Result));
end;

//Pega o nome da máquina na Rede
//Retornos: Machine Name
function GetMachine(): String;
var lSize: DWord;
begin
    //Seta o tamanho
    lSize := MAX_COMPUTERNAME_LENGTH + 1;
    SetLength(Result,lSize);
    //Chama a rotina
    GetComputerName(PChar(Result), lSize);
    //Retorna nome do computador
    Result := String(PChar(Result));
end;

function ConvX(Medida : Double) : Integer;
begin
  Result := Trunc(ValorConvX / 25.4 * Medida);
end;

function ConvY(Medida : Double) : Integer;
begin
  Result := Trunc(ValorConvY / 25.4 * Medida);
end;

procedure Interleaved2of5(Canvas: TCanvas; Numero: String; PosX,PosY: Integer;
  Altura: Double);
const
  Barras: Array[0..9] of String = ('00110','10001','01001','11000','00101',
                          '10100','01100','00011','10010','01010');
  Inicio : String = '0000';
  Final : String = '100';
var
  i,j,k : Integer;
  TamBarra : Integer;
begin
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Style := psInsideFrame;
  Canvas.Brush.Color := clBlack;
// Número de dígitos deve ser par
  if Odd(Length(Numero)) then
    Numero := '0'+Numero;
// Desenha início
  for i := 1 to Length(Inicio) do begin
    if Inicio[i] = '0' then
      TamBarra := ConvX(0.3)
    else
      TamBarra := ConvX(0.6);
    if Odd(i) then
      Canvas.FillRect(Rect(PosX,PosY,PosX+TamBarra,PosY+ConvY(Altura)));
    PosX := PosX+TamBarra;
  end;
// Desenha caracteres
  i:=1;
  while i <= Length(Numero) do begin
    for j := 1 to 5 do
// Cada conjunto tem dois números - k = 0 - Barra; k = 1 - Espaço
      for k := 0 to 1 do begin
        if Barras[Ord(Numero[i+k])-Ord('0')][j] = '0' then
          TamBarra := ConvX(0.3)
        else
          TamBarra := ConvX(0.6);
        if k = 0 then
          Canvas.FillRect(Rect(PosX,PosY,PosX+TamBarra,PosY+ConvY(Altura)));
        PosX := PosX+TamBarra;
      end;
    Inc(i,2);
  end;
// Desenha Final
  for i := 1 to Length(Final) do begin
    if Final[i] = '0' then
      TamBarra := ConvX(0.3)
    else
      TamBarra := ConvX(0.6);
    if Odd(i) then
      Canvas.FillRect(Rect(PosX,PosY,PosX+TamBarra,PosY+ConvY(Altura)));
    PosX := PosX+TamBarra;
  end;
end;

procedure Code39(Canvas: TCanvas; Numero:String; PosX, PosY : Integer; Altura : Double);
const
  Digitos = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%';
  Barras : Array[1..44] of String =
    ('100100001','001100001','101100000','000110001',
     '100110000','001110000','000100101','100100100',
     '001100100','000110100','100001001','001001001',
     '101001000','000011001','100011000','001011000',
     '000001101','100001100','001001100','000011100',
     '100000011','001000011','101000010','000010011',
     '100010010','001010010','000000111','100000110',
     '001000110','000010110','110000001','011000001',
     '111000000','010010001','110010000','011010000',
     '010000101','110000100','011000100','010010100',
     '010101000','010100010','010001010','000101010');
var
  i,j,k : Integer;
  Barra : Boolean;
  TamBarra : Integer;
begin
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Style := psInsideFrame;
  Canvas.Brush.Color := clBlack;
  for i := 1 to Length(Numero) do begin
// Verifica se o caractere é válido
    j := Pos(Numero[i], Digitos);
    if j < 0 then
      raise Exception.Create('Código Inválido');
    Barra := True;
// Imprime caracteres
    for k := 1 to 9 do begin
      if Barras[j][k] = '0' then
        TamBarra := ConvX(0.3)
      else
        TamBarra := ConvY(0.6);
      if Barra then
        Canvas.FillRect(Rect(PosX, PosY, PosX+TamBarra, PosY+ConvY(Altura)));
      PosX := PosX + TamBarra;
      Barra := not Barra;
    end;
// Espaço entre caracteres
    PosX := PosX + ConvX(0.3);
  end;
end;

function CalculaDigito(Numero : String): Char;
var
  i : Integer;
  Soma : Integer;
  Mult : Integer;
begin
  Soma := 0;
  Mult := 3;
  for i := Length(Numero) downto 1 do begin
    Soma := Soma + (Ord(Numero[i])-Ord('0'))*Mult;
    if Mult = 3 then
      Mult := 1
    else
      Mult := 3;
  end;
  if Soma mod 10 <> 0 then
    Result := Chr(10 - Soma mod 10 + Ord('0'))
  else
    Result := '0';
end;

procedure EAN13(Canvas: TCanvas; Numero:String; PosX, PosY : Integer; Altura : Double);
const
  Barras : Array[1..3] of Array[0..9] of String =
    (('0001101','0011001','0010011','0111101','0100011',
      '0110001','0101111','0111011','0110111','0001011'),
     ('0100111','0110011','0011011','0100001','0011101',
      '0111001','0000101','0010001','0001001','0010111'),
     ('1110010','1100110','1101100','1000010','1011100',
      '1001110','1010000','1000100','1001000','1110100'));
  TabSel : Array[0..9] of String =
     ('111111','112122','112212','112221','121122',
      '122112','122211','121212','121221','122121');
  InicioFim : String = '101';
  Meio : String = '01010';
var
  i,j : Integer;
  TamBarra : Integer;
  TabAtu : Integer;
begin
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Style := psInsideFrame;
  Canvas.Brush.Color := clBlack;
  while length(Numero) < 12 do
    Numero := '0'+Numero;
  if Length(Numero) = 12 then
    Numero := Numero + CalculaDigito(Numero);
  if Length(Numero) <> 13 then
    raise Exception.Create('Número Inválido');
  TamBarra := ConvX(0.3);
  for i := 1 to Length(InicioFim) do begin
    if InicioFim[i] = '1' then
      Canvas.FillRect(Rect(PosX,PosY,PosX+TamBarra,PosY+ConvY(Altura+3)));
    PosX := PosX+TamBarra;
  end;
  for i:= 2 to length(Numero) do begin
    if i <= 7 then
      TabAtu := Ord(TabSel[Ord(Numero[1])-Ord('0')][i-1]) - Ord('0')
    else
      TabAtu := 3;
    for j := 1 to 7 do begin
      if Barras[TabAtu,Ord(Numero[i])-Ord('0')][j] = '1' then
        Canvas.FillRect(Rect(PosX, PosY, PosX+TamBarra, PosY+ConvY(Altura)));
      PosX := PosX + TamBarra;
    end;
    if i = 7 then
      for j := 1 to Length(Meio) do begin
        if Meio[j] = '1' then
          Canvas.FillRect(Rect(PosX,PosY,PosX+TamBarra,PosY+ConvY(Altura+3)));
        PosX := PosX+TamBarra;
      end;
  end;
  for i := 1 to Length(InicioFim) do begin
    if InicioFim[i] = '1' then
      Canvas.FillRect(Rect(PosX,PosY,PosX+TamBarra,PosY+ConvY(Altura+3)));
    PosX := PosX+TamBarra;
  end;
end;

(* Chamar com a seguite sintaxe: Extenso(numero,'','') *)
// ------ Valor por extenso de um número ------------------------
function Extenso(Valor: Double; Singular, Plural: string): string;
Var
  N, Code,i: integer;
  Ve: array[0..11] of string;
  Str_Valor, Aux: string;
begin
  result:= '';
  if Valor > 0.0 then begin
     Ve[00]:= 'Trilhão';                // Inicializa Vetor
     Ve[01]:= 'Trilhões';
     Ve[02]:= 'Bilhão';
     Ve[03]:= 'Bilhões';
     Ve[04]:= 'Milhão';
     Ve[05]:= 'Milhões';
     Ve[06]:= 'Mil';
     Ve[07]:= 'Mil';
     Ve[08]:= Singular;
     ve[09]:= Plural;
     Ve[10]:= 'Centavo';
     ve[11]:= 'Centavos';

     Str_Valor:= Format('%18.2f', [Valor]);
     Str_Valor[16]:= '0';               // Tira ponto decimal;

     for i:=0 to 5 do begin             // Trata grupo de 3 dígitos (Trih.., Bilh.., Milh..)
       Aux:= Copy(Str_Valor, i*3+1, 3);
       Val(Aux, N, code);

       if N > 0 then begin
          Aux:= ExtNum(Aux);
          if (i = 5) and (Valor > 1) then                    // Trata Centavos
             Aux:= 'e ' + Aux
          else if (result <> '') and (N <= 100) then         // Trata Centenas e Dezenas
             Aux:= 'e ' + Aux;

          if N = 1 then
             result:= result + Aux + ' ' + Ve[i*2] + ' '     // Singular ( ...lhão  )
          else
             result:= result + Aux + ' ' + Ve[i*2+1] + ' ';  // Plural   ( ...lhões )
       end;

       if Valor > 1000 then begin
          if (N = 0) and (i = 3) then       // Bilhões, Milhões de ....
            result:= result; //+ 'de '

          if (N = 0) and (i = 4) then       // Mil <Plural Moeda> ....
             result:= result + Plural + ' ';
       end;
     end; // for
  end;
end;

// ------ Valor por extenso de 1 ate 999 ( sem unidade )---------
function ExtNum(Str_Valor: string): string;
Const
  Vu: array [1..19] of string = ('Um', 'Dois', 'Tres','Quatro','Cinco','Seis','Sete','Oito',
                                 'Nove','Dez','Onze','Doze','Treze','Quatorze','Quinze',
                                 'Dezeseis', 'Dezesete','Dezoito', 'Dezenove');
  Vd: array [2..10] of string = ('Vinte','Trinta','Quarenta','Cinquenta','Sessenta',
                                 'Setenta','Oitenta','Noventa','Cem');
  Vc: array [1..9]  of string = ('Cento','Duzentos','Trezentos','Quatrocentos','Quinhentos',
                                 'Seiscentos','Setecentos','Oitocentos', 'Novecentos');
Var
  Num: Integer;
  Code, C, D, U, CU: Integer;

begin
  result:= '';
  Val(Str_Valor, Num, Code);                   // Converte String para Número
  if Num > 0 then begin
     Str_Valor:= Format('%03d', [Num]);        // Ajusta string do valor com zeros à esquerda
     Val(Copy(Str_Valor,2,2), CU, Code);       // Copia Centena e Unidade
     Val(Copy(Str_Valor,3,1), U, Code);        // Copia Unidade
     Val(Copy(Str_Valor,2,1), D, Code);        // Copia Dezena
     Val(Copy(Str_Valor,1,1), C, Code);        // Copia Centena
     if Num = 100 then
        result := Vd[10]                       // Trata: 'Cem'
     else begin
        if C > 0 then begin                    // Trata: 'Cento e', 'Duzentos e', ...
           result:= Vc[C];
           if CU > 0 then
              result:= result + ' e ';
        end;
        if D > 1 then begin                    // Trata: 'Vinte', 'Trinta', ...
           result:= result + Vd[D];
           if U > 0 then
              result:= result  + ' e '         // Trata: 'Vinte e ', 'Trinta e ', ...
        end;
        if ( CU >= 1 ) and ( CU <= 19 ) then   // Trata: 'um' a ' 'Dezenove'
           result:= result + Vu[CU];

        if (D > 1) and (U >= 1) then           // Trata: .... ' um', ' Dois', ...
           result:= result + Vu[U];
     end;
  end;
end;

function GetModuleFullName: string;
var
  szFileName: array[0..MAX_PATH] of Char;
begin
  Winapi.Windows.GetModuleFileName(hInstance, szFileName, MAX_PATH);
  Result := szFileName;
end;

function GetModuleFileName: string;
begin
  Result := ExtractFileName(GetModuleFullName);
end;

function GetModulePath: string;
begin
  Result := ExtractFilePath(GetModuleFullName);
end;

function GetModuleIniFileName: string;
var
  aFileName: string;
begin
  aFileName := GetModuleFullName;
  Result := ChangeFileExt(aFileName, '.ini');
end;

function VerificaNivelSupConta(CodConta : String): String;
var
  vlinCont: Integer;
begin
  if (Pos('.', CodConta) = 0) then
  begin
    Result := CodConta;
    Exit;
  end;

  // Acha Conta de Nível Superior
  for vlinCont := 1 to Length(CodConta) do
  begin
    if vlinCont > 1 then
      Result := Result + '.';
    Result := Result+Copy(CodConta, 1, Pos('.', CodConta)-1);
    Delete(CodConta, 1, Pos('.', CodConta));
    if (Pos('.', CodConta) = 0) then
      Break;
  end;
end;

function VerificaMascara(var Codigo: String; const Mascara: String): Boolean;
var
  vlinCont,
  vlinTamMascara,
  vlinTamCodConta : Integer;
  vlstMascara,
  vlstCodConta: String;
begin
  Result          := True;
  vlstCodConta    := '';
  vlstMascara     := Mascara;
  vlinTamCodConta := Length(Codigo);

  if (Pos('.', Codigo) = 0) then // Sem ponto, então coloca mascara
  begin
    if Length(Codigo) > Length(StringReplace(vlstMascara, '.', '', [rfReplaceAll])) then
    begin
      Result := False;
      Exit;
    end
    else vlstMascara := Mascara;

    for vlinCont := 1 to vlinTamCodConta do
    begin
      if Pos('.' ,vlstMascara) = 0 then
        vlinTamMascara := Length(vlstMascara)+1
      else
        vlinTamMascara := Pos('.' ,vlstMascara);

      if (vlinCont > 1) then
        vlstCodConta := vlstCodConta+'.';

      vlstCodConta := vlstCodConta+Copy(Codigo, 1, vlinTamMascara-1);

      Delete(Codigo, 1, vlinTamMascara-1);
      Delete(vlstMascara, 1, vlinTamMascara);

      if (vlstMascara = '') or (Codigo = '') then
        Break;
    end;
    if (Pos('.' ,vlstCodConta) > 0) then
      if not VerificaMascara(vlstCodConta, Mascara) then
      begin
        Result := False;
        Exit;
      end;

    Codigo := vlstCodConta;
  end
  else // Com ponto, verifica se a máscara
  begin
    vlstCodConta := Codigo;
    for vlinCont := 1 to vlinTamCodConta do
    begin
      if (Pos('.', vlstCodConta) = 0) and (Pos('.', vlstMascara) = 0) and
         (Length(vlstCodConta) <> Length(vlstMascara)) then
      begin
        Result := False;
        Exit;
      end;
      if (Pos('.', vlstCodConta) <> Pos('.', vlstMascara)) and
         (Length(vlstCodConta) <> Length(Copy(vlstMascara, 1, Pos('.', vlstMascara)-1))) then
      begin
        Result := False;
        Exit;
      end;
      if Pos('.' ,vlstCodConta) = 0 then
        Break;

      Delete(vlstCodConta, 1, Pos('.' ,vlstCodConta));
      Delete(vlstMascara, 1, Pos('.' ,vlstMascara));
    end;
  end;
end;

function AbreArqWord(aPathArq : String): Boolean;
var
  vWinWord   : OleVariant;
  vDocs      : OleVariant;
begin
  try
    vWinWord  := CreateOleObject('Word.Application');
    vDocs     := vWinWord.Documents;
    vDocs     := vDocs.Open(aPathArq);

    vWinWord.Visible := True;
    Result := True;
  except
    Result := False;
  end;
end;

function BuscaTrocaFuncoes(aStr: String; aStrBusca,
  aStrTroca: array of String): String;
var
  vPos : Integer;
  vI   : Integer;
begin
  for vI := Low(aStrBusca) to High(aStrBusca) do
  begin
    while Pos(aStrBusca[vI], aStr) <> 0 do
    begin
      vPos := Pos(aStrBusca[vI], aStr);
      Delete(aStr, vPos, Length(aStrBusca[vI]));
      if vI <= High(aStrTroca) then
        Insert(aStrTroca[vI], aStr, vPos);
    end;
  end;
  Result := aStr;
end;

procedure GerarContrato(const aCodContrato : String; aDataSet : TClientDataSet);
var
  vBuffer             : array[1..1] of Char;
  vBufferAcumulado    : String;
  vNumBytesLidos      : Integer;
  vNumBytesEscritos   : Integer;
  vCont               : Integer;
  vArqDestino         : File;
  vArqOrigem          : File;
  vPathNomeArqOrigem  : String;
  vPathNomeArqDestino : String;
  vEndereco           : String;
begin
  try
    vPathNomeArqOrigem  := ExtractFilePath(Application.ExeName)+'\Documentos\Contrato.rtf';
    vPathNomeArqDestino := ExtractFilePath(Application.ExeName)+'\Contratos\Contrato_'+aCodContrato+'.rtf';
    AssignFile(vArqDestino, vPathNomeArqDestino);
    {$I-}
    Rewrite(vArqDestino, 1);
    {$I+}

    if IOResult <> 0 then
      ShowMessage('Não foi possível abrir o arquivo: ' + vPathNomeArqDestino + ' caso esteja com ele aberto favor fechá-lo.');

    AssignFile(vArqOrigem, vPathNomeArqOrigem);
    Reset(vArqOrigem, 1);	{ Record size = 1 }
    vBufferAcumulado := EmptyStr;
    repeat
      BlockRead(vArqOrigem, vBuffer, SizeOf(vBuffer), vNumBytesLidos);
      vBufferAcumulado := vBufferAcumulado + vBuffer[1];
    until (vNumBytesLidos = 0);

    vEndereco := aDataSet.FieldByName('DSC_TIPOLOGRADOURO').AsString+
                 aDataSet.FieldByName('DSC_ENDERECO').AsString+' nº'+
                 aDataSet.FieldByName('NUM_ENDERECO').AsString+' '+
                 aDataSet.FieldByName('DSC_COMPLEMENTO').AsString+', '+
                 aDataSet.FieldByName('DSC_BAIRRO').AsString+', '+
                 aDataSet.FieldByName('DSC_CIDADE').AsString+', '+
                 aDataSet.FieldByName('DSC_CEP').AsString;

    vBufferAcumulado := BuscaTrocaFuncoes(vBufferAcumulado, ['[NOME]'], [aDataSet.FieldByName('DSC_PESSOA').AsString]);
    vBufferAcumulado := BuscaTrocaFuncoes(vBufferAcumulado, ['[ENDERECO]'], [vEndereco]);
    vBufferAcumulado := BuscaTrocaFuncoes(vBufferAcumulado, ['[CPFCNPJ]'], [aDataSet.FieldByName('DSC_CPFCNPJ').AsString]);
    vBufferAcumulado := BuscaTrocaFuncoes(vBufferAcumulado, ['[DATA]'], [DataExtenso(Date)]);

    for vCont := 1 to Length(vBufferAcumulado) do
    begin
      vBuffer[1] := vBufferAcumulado[vCont];
      BlockWrite(vArqDestino, vBuffer[1], SizeOf(vBuffer[1]) , vNumBytesEscritos);
    end;

    {$I-}
    CloseFile(vArqOrigem);
    CloseFile(vArqDestino);
    {$I+}
    AbreArqWord(vPathNomeArqDestino);
  finally

  end;
end;

function GerarSenha(aDate : Double): String;
var
  i,j, k: integer;
  s, r1, r2: String;
begin
  for i:= 1 to 2 do
  begin
    for j:= 1 to 5 do
    begin
      Randomize;
      k := Random(Length(str))+1;
      Result := Result + str[k];
      if i = 1 then
        r1 := r1 + ZerosEsquerda(IntToStr(k), 2)
      else
        r2 := r2 + ZerosEsquerda(IntToStr(k), 2);
    end;
    Result := Result +'-';
  end;
  Delete(Result, Length(Result), 1);
  s := r1 +'-'+ r2 +'-'+ FloatToStr(aDate) +'-'+ Result;
  Result := s;
end;

function ValidarSenha(aSenha: String; var aData : String): Boolean;
var
  s, m1, m2, m3, m4, m5 : String;
  r1, r2 : String;
  i, j, k : Integer;
begin
  Result := False;
  try
    s := aSenha;
    i := Pos('-', s);
    m1 := Copy(s, 1, i-1);
    Delete(s, 1, i);
    i := Pos('-', s);
    m2 := Copy(s, 1, i-1);
    Delete(s, 1, i);
    i := Pos('-', s);
    m3 := Copy(s, 1, i-1);
    Delete(s, 1, i);
    i := Pos('-', s);
    m4 := Copy(s, 1, i-1);
    Delete(s, 1, i);
    m5 := s;

    aData := DateToStr(StrToFloat(m3));

    for i := 1 to 2 do
    begin
      for j := 1 to 5 do
      begin
        if i = 1 then
        begin
          k := StrToInt(Copy(m1, 1, 2));
          Delete(m1, 1, 2);
          r1 := r1 + str[k]
        end
        else
        begin
          k := StrToInt(Copy(m2, 1, 2));
          Delete(m2, 1, 2);
          r2 := r2 + str[k];
        end;
      end;
    end;
    if (r1 = m4) and (r2 = m5) then
      Result := True;
  except
    Result := False;
  end;
end;

function GetVersaoArq(aModoVisualizacao : Integer): string;
var
  InfoSize : DWord;
  VerSize : DWord;
  pcArquivo : PChar;
  {$IFDEF VER100} // Delphi 3.0x
  Wnd : Integer;
  {$ELSE} // Delphi 4.0x
  Wnd : Cardinal;
  {$ENDIF}
  VerBuf : Pointer;
  FI : PVSFixedFileInfo;
begin
  pcArquivo := PChar(Application.ExeName);
  Result := 'Não disponível';
  InfoSize := GetFileVersionInfoSize(pcArquivo, Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
    if GetFileVersionInfo(pcArquivo, Wnd, InfoSize, VerBuf) then
      if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
        if aModoVisualizacao = 0 then
          Result := IntToStr(Trunc((FI.dwProductVersionMS / 65536))) + '.' +
          IntToStr(FI.dwProductVersionMS mod 65536 ) + '.' +
          IntToStr(Trunc((FI.dwProductVersionLS / 65536))) + '.' +
          IntToStr(FI.dwProductVersionLS mod 65536)
        else
          Result := IntToStr(Trunc((FI.dwProductVersionMS/ 65536))) + '.' +
          IntToStr(FI.dwProductVersionMS mod 65536);
          Result := ' ' + Result;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

//Cria comandos pra Criptografar os caracteres
function Criptografar(aTexto: String): String;
var
  I:Byte;
  vChave:Word;
  Texto:String;
begin
  vChave := Chave;
  for I:=1 to Length(aTexto) do
  begin
    Texto := Texto + Char(Byte(aTexto[I]) xor (vChave shr 8));
    vChave:=(Byte(Texto[I]) + vChave) * Cripto_1 + Cripto_2;
  end;
  Result := Texto;
end;

//Cria comandos pra Descriptografar os caracteres
function Descriptografar(aTexto: String): String;
var
  I:Byte;
  vChave:Word;
  Texto:String;
begin
  vChave := Chave;
  for I:=1 to Length(aTexto) do
  begin
    Texto := Texto + Char(Byte(aTexto[I]) xor (vChave shr 8));
    vChave:=(Byte(Texto[I]) + vChave) * Cripto_1 + Cripto_2;
  end;
  Result := Texto;
end;

function Incrementa(aNomeTabela, aCampo, aCondicao : String ;aConnect : TSQLConnection): Largeint;overload;
var
  vQry : TSQLQuery;
begin
  {Cria uma instância do objeto}
  vQry := TSQLQuery.Create(nil);
  try
    vQry.SQLConnection := aConnect;
    vQry.SQL.Text := 'SELECT MAX('+aCampo+') FROM '+aNomeTabela + aCondicao;
    vQry.Open;

    if vQry.Fields[0].IsNull then
      Result := 1
    else
      Result := vQry.Fields[0].AsInteger + 1;
  finally
    FreeAndNil(vQry);
  end;
end;

function Incrementa(aNomeTabela, aCampo, aCondicao : String; aTamanho: Integer; aConnect : TSQLConnection): String;overload;
var
  vQry : TSQLQuery;
begin
  {Cria uma instância do objeto}
  vQry := TSQLQuery.Create(nil);
  try
    vQry.SQLConnection := aConnect;
    vQry.SQL.Text := 'SELECT COALESCE(MAX('+aCampo+'), 0) FROM '+aNomeTabela + aCondicao;
    vQry.Open;

    Result := ZerosEsquerda(IntToStr(vQry.Fields[0].AsInteger + 1), aTamanho);
  finally
    FreeAndNil(vQry);
  end;
end;

function SendFileStream(aPath: String): OleVariant;
var
  vFileStream : TMemoryStream;
  vFileOle : OleVariant;
begin
  // Buscar o arquivo
  vFileStream := TMemoryStream.Create;
  try
    vFileStream.LoadFromFile(aPath);
    StreamToOleVariant(vFileStream, vFileOle);
    Result := vFileOle;
  finally
     FreeAndNil(vFileStream);
  end;
end;

procedure ReceiveFileStream(aPath: String; aFile: OleVariant);
var
  vMemoryStream : TMemoryStream;
  pBuffer       : Pointer;
begin
  // Converter o arquivo
  vMemoryStream := TMemoryStream.Create;
  try
    vMemoryStream.Seek( 0, soFromBeginning );
    pBuffer := VarArrayLock(aFile);
    vMemoryStream.WriteBuffer(pBuffer^, VarArrayHighBound(aFile, 1) +1);
  finally
    VarArrayUnlock(aFile);
  end;
  vMemoryStream.Seek( 0, soFromBeginning );
  vMemoryStream.SaveToFile(aPath);
end;

procedure StreamToOleVariant(aStream: TMemoryStream; var aResult: OleVariant);
var
  pBuffer : pointer;
begin
  if aStream.Size = 0 then
    aResult := Null
  else
  begin
    aStream.Seek( 0, soFromBeginning );
    aResult := VarArrayCreate( [0, aStream.Size -1], varByte );
    pBuffer := VararrayLock( aResult );
    try
      aStream.Read( pBuffer^, aStream.Size );
    finally
      varArrayUnlock( aResult );
    end;
  end;
end;

procedure OleVariantToStream(const aVariant: OleVariant; const Result: TMemoryStream);
var
  pBuffer : pointer;
begin
  // Assegura que é um Array
  if not VarIsArray( aVariant ) then
    raise Exception.Create('O Variant não é um Array');
  // Assegura que é preenchido de varByte
  if (VarType(aVariant) and varTypeMask) <> varByte then
    raise Exception.Create('Variant preenchido com tipos inválidos');
  Result.Seek( 0, soFromBeginning );
  pBuffer := VarArrayLock( aVariant );
  try
    Result.WriteBuffer( pBuffer^, VarArrayHighBound(aVariant, 1) +1 );
  finally
    VarArrayUnlock( aVariant );
  end;
  Result.Seek( 0, soFromBeginning );
end;

function MontarString(aTexto, aSubStr: string): string;
var
  I, J :Integer;
begin
  Result := '';
  I := ProcuraExata(aTexto, aSubStr);
  J := ProcuraExata(aTexto, 'FROM');
  if J > I then
  begin
    for J := I-1 downto 7 do begin
      if (aTexto[J] = ',') then
        Break;
      if (aTexto[J] <> ' ') then
        Result := aTexto[J] + Result;
    end;
  end;
  if Pos('.', Result) = Length(Result) then
    Result := Result + aSubStr;
end;

function ProcuraExata(aTexto, aSubStr: string): Integer;
var
  I :Integer;
begin
  Result := 0;
  I := 1;
  while True do begin
    I := PosEx(aSubStr, aTexto, I+1);
    if I = 0 then
      Break;

    if (aTexto[I+Length(aSubStr)] = ' ') or (aTexto[I+Length(aSubStr)] = ',') then begin
      Result := I;
      Break;
    end;
  end;
end;

procedure CarregarConfiguracores;
var
  Arq: TIniFile;
begin
  Arq := TIniFile.Create(GetModulePath+'Config.ini');
  try
    vgliNumGrupo := Arq.ReadInteger('Config', 'CODIGOGR', 0);
    vginTabs     := Arq.ReadInteger('Config', 'TAB', 0);
    vgstSkinName := Arq.ReadString('Config', 'SKIN', '');
    vgstHost     := Arq.ReadString('Servidor', 'Host', 'localhost');
    vginPorta    := Arq.ReadInteger('Servidor', 'Port', 2307);

  finally
    Arq.Free;
  end;

  vgimLogoRel := TPngImage.Create;
end;

procedure SalvarConfiguracores;
var
  Arq: TIniFile;
begin
  Arq := TIniFile.Create(GetModulePath+'Config.ini');
  try
    Arq.WriteString('Config', 'SKIN', vgstSkinName);
  finally
    Arq.Free;
  end;
end;

function Operador(aSQL: string): string;
begin
  if Pos('WHERE', UpperCase(aSQL)) > 0 then
    Result := ' AND '
  else
    Result := ' WHERE ';
end;

function MD5String(const Value: string): string;
var
  xMD5: TIdHashMessageDigest5;
begin
  xMD5 := TIdHashMessageDigest5.Create;
  try
    Result := xMD5.HashStringAsHex(Value);
  finally
    xMD5.Free;
  end;
end;

procedure MontarArvoreUsuario(aTree: TcxTreeView; aNumPai: Integer;
  aNode: TTreeNode; aDataSet: TClientDataSet);
var
 Node : TTreeNode;
 NivelAtual : Integer;
 Filtro : String;
begin
  if aNumPai = 0 then
    Filtro := 'ID_ACESSOPAI IS NULL '
  else
    Filtro := 'ID_ACESSOPAI = ' + IntToStr(aNumPai);

  aDataSet.Filtered := False;
  aDataSet.Filter   := Filtro;
  aDataSet.Filtered := True;

  if aDataSet.RecordCount = 0 then
  begin
    Exit;
  end;

  while not aDataSet.Eof do
  begin
    NivelAtual          := aDataSet.FieldByName('ID_ACESSO').AsInteger;
    Node                := aTree.Items.AddChild(aNode, aDataSet.FieldByName('DSC_MENU').AsString);
    Node.ImageIndex     := aDataSet.FieldByName('FLG_ACESSO').AsInteger-1;
    Node.SelectedIndex  := aDataSet.FieldByName('FLG_ACESSO').AsInteger-1;
    Node.StateIndex     := aDataSet.FieldByName('ID_PERMISSAO').AsInteger;
//    aTree.Checked[Node] := (aDataSet.FieldByName('FLG_ACESSO').AsString <> '4');
    MontarArvoreUsuario(aTree, aDataSet.FieldByName('ID_ACESSO').AsInteger, Node, aDataSet);

    aDataSet.Filtered := False;
    aDataSet.Filter   := Filtro;
    aDataSet.Filtered := True;

    aDataSet.Locate('ID_ACESSO',NivelAtual,[]);
    aDataSet.Next;
  end;
end;

procedure MontarArvoreAcesso(aTree: TcxTreeView; aNumPai: Integer;
  aNode: TTreeNode; aDataSet: TClientDataSet);
var
 Node : TTreeNode;
 NivelAtual : Integer;
 Filtro : String;
begin
  if aNumPai = 0 then
    Filtro := 'ID_ACESSOPAI IS NULL '
  else
    Filtro := 'ID_ACESSOPAI = ' + IntToStr(aNumPai);

  aDataSet.Filtered := False;
  aDataSet.Filter   := Filtro;
  aDataSet.Filtered := True;

  if aDataSet.RecordCount = 0 then
  begin
    Exit;
  end;

  while not aDataSet.Eof do
  begin
    NivelAtual  := aDataSet.FieldByName('ID_ACESSO').AsInteger;
    Node        := aTree.Items.AddChildObject(aNode,
                      aDataSet.FieldByName('DSC_MENU').AsString,
                      aDataSet.GetBookmark);

    MontarArvoreAcesso(aTree, aDataSet.FieldByName('ID_ACESSO').AsInteger, Node, aDataSet);

    aDataSet.Filtered := False;
    aDataSet.Filter   := Filtro;
    aDataSet.Filtered := True;
    aDataSet.Locate('ID_ACESSO',NivelAtual,[]);
    aDataSet.Next;
  end;
end;

procedure MontarJSonArray(aValueType, aOperator, aValue: String; aJSonArray: TJSONArray;
  aEmpty: Boolean = False);
var
  vJSonObj: TJSONObject;
  I: Integer;
begin
  if aEmpty then
    for I := aJSonArray.Count -1 downto 0 do
      aJSonArray.Remove(I);

  if (aValue <> EmptyStr) and (Trim(aValue) <> QuotedStr('')) then begin
    vJsonObj := TJSONObject.Create;
    vJSonObj.AddPair(aValueType, aOperator+' '+aValue);
    aJSonArray.AddElement(vJSonObj);
  end;
end;

procedure LimparJSonArray(aJSonArray: TJSONArray);
var
  I: Integer;
begin
  for I := aJSonArray.Count -1 downto 0 do
    aJSonArray.Remove(I);
end;

procedure ClonarJSON(aJSONOrigem, aJSONDestino: TJSONArray; aClear: Boolean = True);
var
  I: Integer;
begin
  if aClear then
    for I := aJSONDestino.Count -1 downto 0 do
        aJSONDestino.Remove(I);

  for I := 0 to aJSONOrigem.Count -1 do
    aJSONDestino.AddElement(aJSONOrigem.Items[I]);
end;

function RetornarElementoJSON(aJSonArray: TJSONArray; aCampo: string): string;
var
  jSubObj: TJSONObject;
  jSubPar: TJSONPair;
  i, j: integer;
begin
  Result := EmptyStr;
  for i := 0 to aJSonArray.Count - 1 do
  begin
    jSubObj := (aJSonArray.Items[i] as TJSONObject);
    for j := 0 to jSubObj.Count - 1 do
    begin
      jSubPar := jSubObj.Pairs[j];
      if jSubPar.JsonString.Value = aCampo then
        Result := jSubPar.JsonValue.Value;
    end;
  end;
end;

function ParseJSonArray(aJSonArray: TJSONArray; aFull: Boolean = False):TStringList;
var
 jSubObj: TJSONObject;
 jSubPar: TJSONPair;
 i, j: integer;
begin
  Result := TStringList.Create;
  for i := 0 to aJSonArray.Count - 1 do
  begin
    jSubObj := (aJSonArray.Items[i] as TJSONObject);
    for j := 0 to jSubObj.Count - 1 do
    begin
      jSubPar := jSubObj.Pairs[j];
      if aFull then
        Result.Add(jSubPar.JsonString.Value + '=' + jSubPar.JsonValue.Value)
      else
        Result.Add(Copy(jSubPar.JsonString.Value,
                        Pos('.', jSubPar.JsonString.Value)+1,
                        Length(jSubPar.JsonString.Value)) + '=' + jSubPar.JsonValue.Value)
    end;
  end;
end;

function RetirarMascaras(const Texto: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Texto) do begin
    if CharInSet(Texto[I], ['0'..'9','A'..'Z','a'..'z', 'á', 'à', 'é', 'í', 'ó', 'ú', 'ã', 'ê', 'ç', 'Á', 'É', 'Í', 'Ó', 'Ú', 'Ã', 'Ê', 'Ç']) then
      Result := Result + Texto[I];
  end;
end;

//Função para substituir caracteres especiais.
function TrocaCaracterEspecial(aTexto: string; aLimExt: Boolean): string;
var
  xTexto : string;
  I : Integer;
begin
  xTexto := aTexto;
  for I := 1 to Length(xCarEsp) do
    xTexto := StringReplace(xTexto, xCarEsp[i], xCarTro[i], [rfreplaceall]);
  //De acordo com o parâmetro aLimExt, elimina caracteres extras.
  if (aLimExt) then
    for I := 1 to Length(xCarExt) do
      xTexto := StringReplace(xTexto, xCarExt[i], '', [rfreplaceall]);
  Result := xTexto;
end;

//Função para substituir caracteres especiais.
function RetirarCaracterEspecial(aTexto : string): string;
var
  xTexto : string;
  i : Integer;
begin
  xTexto := aTexto;
  for i := 1 to Length(xCarExt)  do
    xTexto := StringReplace(xTexto, xCarExt[i], '', [rfreplaceall]);
  Result := xTexto;
end;

end.
