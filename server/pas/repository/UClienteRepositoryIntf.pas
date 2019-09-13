unit UClienteRepositoryIntf;

interface

type
  IClienteRepository = Interface(IInterface)
    ['{78D99BB0-A73F-48E7-834E-08D7A51270D9}']

    function adquirirCodigoCliente(const ADocumentoCliente: String): Integer;
    procedure adicionarCliente(const ADocumentoCliente: String);
  End;

implementation

end.
