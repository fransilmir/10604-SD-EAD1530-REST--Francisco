unit UClienteServiceIntf;

interface

type
  IClienteService = Interface(IInterface)
    ['{A3E35500-F7A2-49C3-8D6B-B0DA9B82367E}']

    function adquirirCodigoCliente(const ADocumentoCliente: String): Integer;
  End;

implementation

end.
