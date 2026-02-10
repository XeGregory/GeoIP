unit UGeoIP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Winapi.Winsock2, System.Net.HttpClient, System.JSON;

type
  TForm1 = class(TForm)
    EditHost: TEdit;
    BtnSearch: TButton;
    MemoOut: TMemo;

    procedure BtnSearchClick(Sender: TObject);
  private
    procedure Log(const S: string);
    function ResolveFirstIPv4(const AHost: string; out AIP: string): Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Log(const S: string);
begin
  MemoOut.Lines.Add(S);
end;

function TForm1.ResolveFirstIPv4(const AHost: string; out AIP: string): Boolean;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  AddrPtr: PAnsiChar;
  InAddr: in_addr;
  I: Integer;
begin
  Result := False;
  AIP := '';
  if WSAStartup($0202, WSAData) <> 0 then
    Exit;
  try
    HostEnt := gethostbyname(PAnsiChar(AnsiString(AHost)));
    if HostEnt = nil then
      Exit;
    I := 0;
    while HostEnt^.h_addr_list[I] <> nil do
    begin
      AddrPtr := HostEnt^.h_addr_list[I];
      Move(AddrPtr^, InAddr, SizeOf(InAddr));
      AIP := string(AnsiString(inet_ntoa(InAddr)));
      Result := True;
      Exit;
    end;
  finally
    WSACleanup;
  end;
end;

procedure TForm1.BtnSearchClick(Sender: TObject);
var
  Host, IP, Resp: string;
  Http: THTTPClient;
  JsonObj: TJSONObject;
  Country, CountryCode: string;
begin
  MemoOut.Clear;
  Host := Trim(EditHost.Text);
  if Host = '' then
  begin
    Log('Entrez un nom d''hôte.');
    Exit;
  end;

  if not ResolveFirstIPv4(Host, IP) then
  begin
    Log('Impossible de résoudre une IPv4 pour ' + Host);
    Exit;
  end;

  Log('IP résolue: ' + IP);

  Http := THTTPClient.Create;
  try
    try
      Resp := Http.Get('http://ip-api.com/json/' + IP).ContentAsString();
    except
      on E: Exception do
      begin
        Log('Erreur HTTP GeoIP : ' + E.Message);
        Exit;
      end;
    end;

    try
      JsonObj := TJSONObject.ParseJSONValue(Resp) as TJSONObject;
      if Assigned(JsonObj) then
        try
          Country := JsonObj.GetValue<string>('country', '');
          CountryCode := JsonObj.GetValue<string>('countryCode', '');
          Log(Format('Pays: %s (%s)', [Country, CountryCode]));
        finally
          JsonObj.Free;
        end
      else
        Log('Réponse GeoIP non JSON ou vide.');
    except
      on E: Exception do
        Log('Erreur parsing JSON: ' + E.Message);
    end;
  finally
    Http.Free;
  end;
end;

end.
