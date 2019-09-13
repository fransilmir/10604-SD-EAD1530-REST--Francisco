unit UPedidoRepositoryImpl;

interface

uses
  UPedidoRepositoryIntf, UPizzaTamanhoEnum, UPizzaSaborEnum, UDBConnectionIntf,
  FireDAC.Comp.Client, UPedidoRetornoDTOImpl;

type
  TPedidoRepository = class(TInterfacedObject, IPedidoRepository)
  private
    FDBConnection: IDBConnection;
    FFDQuery: TFDQuery;
  public
    procedure efetuarPedido(const APizzaTamanho: TPizzaTamanhoEnum;
      const APizzaSabor: TPizzaSaborEnum; const AValorPedido: Currency;
      const ATempoPreparo: Integer; const ACodigoCliente: Integer);
    function consultarPedido(const ADocumentoCliente: string)
      : TpedidoRetornoDTO;

    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  UDBConnectionImpl, System.SysUtils, Data.DB, FireDAC.Stan.Param, System.Rtti;

const
  CMD_INSERT_PEDIDO
    : String =
    'INSERT INTO tb_pedido (cd_cliente, dt_pedido, dt_entrega, vl_pedido, nr_tempopedido, sabor, tamanho) VALUES (:pCodigoCliente, :pDataPedido, :pDataEntrega, :pValorPedido, :pTempoPedido, :pSabor, :pTamanho)';
  CMD_CONSULTAR_PEDIDO:
    String ='select tb_pedido.cd_cliente, tb_pedido.dt_pedido, tb_pedido.nr_tempopedido,' +
    ' tb_pedido.vl_pedido, tb_pedido.te_sabor, tb_pedido.te_tamanho from tb_pedido' +
    ' join tb_cliente on tb_cliente.id = tb_pedido.cd_cliente' +
    ' where tb_cliente.nr_documento = :doc' +
    ' limit 1';

  { TPedidoRepository }

function TPedidoRepository.consultarPedido(
  const ADocumentoCliente: string): TpedidoRetornoDTO;
begin
  FFDQuery.SQL.Text := CMD_CONSULTAR_PEDIDO;
  FFDQuery.ParamByName('PNR_DOCUMENTO').AsString := ADocumentoCliente;
  FFDQuery.Open();
  if (FFDQuery.RecordCount = 0) then
    raise Exception.Create('Não foram encontrados pedidos para este cliente.');
  Result := TPedidoRetornoDTO.Create(
    TRttiEnumerationType.GetValue<TPizzaTamanhoEnum>(FFDQuery.FieldByName('TE_TAMANHO').AsString),
    TRttiEnumerationType.GetValue<TPizzaSaborEnum>(FFDQuery.FieldByName('te_sabor').AsString),
    FFDQuery.FieldByName('VL_PEDIDO').AsFloat,
    FFDQuery.FieldByName('NR_TEMPOPEDIDO').AsInteger)
end;

constructor TPedidoRepository.Create;
begin
  inherited;

  FDBConnection := TDBConnection.Create;
  FFDQuery := TFDQuery.Create(nil);
  FFDQuery.Connection := FDBConnection.getDefaultConnection;
end;

destructor TPedidoRepository.Destroy;
begin
  FFDQuery.Free;
  inherited;
end;

procedure TPedidoRepository.efetuarPedido(const APizzaTamanho
  : TPizzaTamanhoEnum; const APizzaSabor: TPizzaSaborEnum;
  const AValorPedido: Currency; const ATempoPreparo: Integer;
  const ACodigoCliente: Integer);
begin
  FFDQuery.SQL.Text := CMD_INSERT_PEDIDO;

  FFDQuery.ParamByName('pCodigoCliente').AsInteger := ACodigoCliente;
  FFDQuery.ParamByName('pDataPedido').AsDateTime := now();
  FFDQuery.ParamByName('pDataEntrega').AsDateTime := now();
  FFDQuery.ParamByName('pValorPedido').AsCurrency := AValorPedido;
  FFDQuery.ParamByName('pTempoPedido').AsInteger := ATempoPreparo;
  FFDQuery.ParamByName('pSabor').AsString:= TRttiEnumerationType.GetName<TPizzaSaborEnum>(APizzaSabor);
  FFDQuery.ParamByName('pTamanho').AsString:= TRttiEnumerationType.GetName<TPizzaTamanhoEnum>(APizzaTamanho);

  FFDQuery.Prepare;
  FFDQuery.ExecSQL(True);
end;

end.
