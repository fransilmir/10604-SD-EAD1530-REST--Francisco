unit UClienteServiceImpl;

interface

uses
  UClienteServiceIntf, UClienteRepositoryIntf;

type
  TClienteService = class(TInterfacedObject, IClienteService)
  private
    FClienteRepository: IClienteRepository;
  public
    function adquirirCodigoCliente(const ADocumentoCliente: string): Integer;

    constructor Create; reintroduce;
  end;

implementation

uses
  System.SysUtils, UClienteRepositoryImpl;

{ TClienteService }

function TClienteService.adquirirCodigoCliente(const ADocumentoCliente: string): Integer;
begin
  Result := Integer.MinValue;
  try
    Result := FClienteRepository.adquirirCodigoCliente(ADocumentoCliente);
  except
    on E: Exception do
    begin
      FClienteRepository.adicionarCliente(ADocumentoCliente);
    end;
  end;

  if (Result = Integer.MinValue) then
    Result := FClienteRepository.adquirirCodigoCliente(ADocumentoCliente);
end;

constructor TClienteService.Create;
begin
  inherited;

  FClienteRepository := TClienteRepository.Create;
end;

end.
