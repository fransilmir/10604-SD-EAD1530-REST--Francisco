unit UClienteRepositoryImpl;

interface

uses
  UClienteRepositoryIntf, UDBConnectionIntf, FireDAC.Comp.Client;

type
  TClienteRepository = class(TInterfacedObject, IClienteRepository)
  private
    FDBConnection: IDBConnection;
    FFDQuery: TFDQuery;
  public
    function adquirirCodigoCliente(const ADocumentoCliente: string): Integer;
    procedure adicionarCliente(const ADocumentoCliente: String);

    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  UDBConnectionImpl, System.SysUtils, Data.DB, FireDAC.Stan.Param;

const
  CMD_INSERT_CLIENTE: String = 'insert into tb_cliente (nr_documento) values (:pDocumentoCliente)';
  CMD_ARDQUIRIR_CLIENTE: String = 'select id from tb_cliente where nr_documento = :pDocumentoCliente';

  { TClienteRepository }

procedure TClienteRepository.adicionarCliente(const ADocumentoCliente: String);
begin
  FFDQuery.SQL.Text := CMD_INSERT_CLIENTE;

  FFDQuery.ParamByName('pDocumentoCliente').AsString := ADocumentoCliente;

  FFDQuery.Prepare;
  FFDQuery.ExecSQL(True);
end;

function TClienteRepository.adquirirCodigoCliente(const ADocumentoCliente: string): Integer;
begin
  FFDQuery.SQL.Text := CMD_ARDQUIRIR_CLIENTE;

  FFDQuery.ParamByName('pDocumentoCliente').AsString := ADocumentoCliente;

  FFDQuery.Prepare;
  FFDQuery.Open;
  if (not FFDQuery.IsEmpty) then
    Result := FFDQuery.FieldByName('id').AsInteger
  else
    raise Exception.Create('Cliente não identificado');

end;

constructor TClienteRepository.Create;
begin
  inherited;

  FDBConnection := TDBConnection.Create;
  FFDQuery := TFDQuery.Create(nil);
  FFDQuery.Connection := FDBConnection.getDefaultConnection;
end;

destructor TClienteRepository.Destroy;
begin
  FFDQuery.Free;
  inherited;
end;

end.
