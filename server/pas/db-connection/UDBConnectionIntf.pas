unit UDBConnectionIntf;

interface

uses
  Data.SQLExpr, FireDAC.Comp.Client;

type
  IDBConnection = Interface(IInterface)
    ['{83006FF8-A243-4D8D-825A-D04089C0CB2C}']

    function getDefaultConnection: TFDConnection;
  End;

implementation

end.
