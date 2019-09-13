program PizzariaBackend;

{$APPTYPE CONSOLE}


{$R *.dres}

uses
  FireDAC.Stan.Def,
  FireDAC.Phys.SQLite,
  FireDAC.DApt,
  FireDAC.Stan.Async,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf,
  FireDAC.Comp.UI,
  System.SysUtils,
  Web.WebReq,
  Web.WebBroker,
  IdHTTPWebBrokerBridge,
  MVCFramework.REPLCommandsHandlerU,
  MVCFramework.Logger,
  UWMPizzariaBackend in '..\pas\wm\UWMPizzariaBackend.pas' {WebModule1: TWebModule},
  UPizzariaControllerImpl in '..\pas\controller\UPizzariaControllerImpl.pas',
  UPedidoRetornoDTOImpl in '..\..\shared\pas\dto\UPedidoRetornoDTOImpl.pas',
  UPizzaSaborEnum in '..\..\shared\pas\enum\UPizzaSaborEnum.pas',
  UPizzaTamanhoEnum in '..\..\shared\pas\enum\UPizzaTamanhoEnum.pas',
  UPedidoServiceImpl in '..\pas\service\UPedidoServiceImpl.pas',
  UPedidoServiceIntf in '..\pas\service\UPedidoServiceIntf.pas',
  UPedidoRepositoryImpl in '..\pas\repository\UPedidoRepositoryImpl.pas',
  UPedidoRepositoryIntf in '..\pas\repository\UPedidoRepositoryIntf.pas',
  UDBConnectionImpl in '..\pas\db-connection\UDBConnectionImpl.pas',
  UDBConnectionIntf in '..\pas\db-connection\UDBConnectionIntf.pas',
  UClienteServiceImpl in '..\pas\service\UClienteServiceImpl.pas',
  UClienteServiceIntf in '..\pas\service\UClienteServiceIntf.pas',
  UClienteRepositoryImpl in '..\pas\repository\UClienteRepositoryImpl.pas',
  UClienteRepositoryIntf in '..\pas\repository\UClienteRepositoryIntf.pas',
  System.Classes,
  System.Types,
  UEfetuarPedidoDTOImpl in '..\..\shared\pas\dto\UEfetuarPedidoDTOImpl.pas';

{$R *.res}


procedure RunServer(APort: Integer);
var
  lServer: TIdHTTPWebBrokerBridge;
  lCustomHandler: TMVCCustomREPLCommandsHandler;
  lCmd, lStartupCommand: string;
begin
  if ParamCount >= 1 then
    lStartupCommand := ParamStr(1)
  else
    lStartupCommand := 'start';

  lCustomHandler := function(const Value: String; const Server: TIdHTTPWebBrokerBridge; out Handled: Boolean): THandleCommandResult
    begin
      Handled := False;
      Result := THandleCommandResult.Unknown;
    end;

  // Writeln(Format('Starting HTTP Server or port %d', [APort]));
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := APort;
    LogI(Format('Server started on port %d', [APort]));

    { more info about MaxConnections
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html }
    LServer.MaxConnections := 0;

    { more info about ListenQueue
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html }
    LServer.ListenQueue := 200;

    WriteLn('Write "quit" or "exit" to shutdown the server');
    repeat
      // TextColor(RED);
      // TextColor(LightRed);
      Write('-> ');
      // TextColor(White);
      if lStartupCommand.IsEmpty then
        ReadLn(lCmd)
      else
      begin
        lCmd := lStartupCommand;
        lStartupCommand := '';
        WriteLn(lCmd);
      end;

      case HandleCommand(lCmd.ToLower, LServer, lCustomHandler) of
        THandleCommandResult.Continue:
          begin
            Continue;
          end;
        THandleCommandResult.Break:
          begin
            Break;
          end;
        THandleCommandResult.Unknown:
          begin
            REPLEmit('Unknown command: ' + lCmd);
          end;
      end;
    until false;

  finally
    LServer.Free;
  end;
end;

procedure initDB();
var
  oSQL: TStringList;
  oSQLResource: TResourceStream;
begin
  if (not DirectoryExists(GetCurrentDir + PathDelim + 'db')) then
    CreateDir(GetCurrentDir + PathDelim + 'db');

  if (not FileExists(GetCurrentDir + PathDelim + 'db' + PathDelim + 'pizzaria.s3db')) then
    FileCreate(GetCurrentDir + PathDelim + 'db' + PathDelim + 'pizzaria.s3db');

  oSQLResource := TResourceStream.Create(HInstance, 'DB_INIT', RT_RCDATA);
  try
    with TDBConnection.Create do
      try
        oSQL := TStringList.Create;
        try
          oSQL.LoadFromStream(oSQLResource);
          getDefaultConnection.ExecSQL(oSQL.Text);
        finally
          oSQL.Free;
        end;
      finally
        Free;
      end;
  finally
    oSQLResource.Free;
  end;
end;

begin
  initDB();
  ReportMemoryLeaksOnShutdown := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;
    RunServer(8080);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
