unit UDBConnectionImpl;

interface

uses
  UDBConnectionIntf, FireDAC.Comp.Client;

type
  TDBConnection = class(TInterfacedObject, IDBConnection)
  private
    FDConnection: TFDConnection;
  public
    function getDefaultConnection: TFDConnection;

    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TDBConnection }

constructor TDBConnection.Create;
begin
  inherited;

  FDConnection := TFDConnection.Create(nil);
  FDConnection.LoginPrompt := False;
  FDConnection.DriverName := 'SQLITE';
  FDConnection.Params.Values['DriverID'] := 'SQLite';
  FDConnection.Params.Values['Database'] := GetCurrentDir + PathDelim + 'db' + PathDelim + 'pizzaria.s3db';
  FDConnection.Params.Values['OpenMode'] := 'CreateUTF8';
  FDConnection.Params.Values['LockingMode'] := 'Normal';
  FDConnection.Params.Values['Synchronous'] := 'Full';
  FDConnection.Connected := True;
  FDConnection.Open();

end;

destructor TDBConnection.Destroy;
begin
  FDConnection.Close;
  FDConnection.Free;

  inherited;
end;

function TDBConnection.getDefaultConnection: TFDConnection;
begin
  Result := FDConnection;
end;

end.
