unit GmailHeadersRetrieval.ListMailBoxes.Main;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdIMAP4, Vcl.Menus, GmailHeadersRetrieval.Frames;

type
  TformListMailboxes = class(TForm)
    Panel1: TPanel;
    btnListMailboxes: TButton;
    IdIMAP41: TIdIMAP4;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Panel2: TPanel;
    lbMailboxes: TListBox;
    frameUserNamePassword1: TframeUserNamePassword;
    MainMenu1: TMainMenu;
    MailBoxes1: TMenuItem;
    mnuListMessageHeaders: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    procedure btnListMailboxesClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbMailboxesDblClick(Sender: TObject);
  private
    procedure EnsureCredentialsPresent;
    function GetPassword: string;
    function GetUserName: string;
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property Password: string read GetPassword write SetPassword;
    property UserName: string read GetUserName write SetUserName;
  end;

var
  formListMailboxes: TformListMailboxes;

implementation
uses
  GmailHeadersRetrieval.Main;

{$R *.dfm}


procedure TformListMailboxes.btnListMailboxesClick(Sender: TObject);
begin
  EnsureCredentialsPresent;

  IdIMAP41.Username := frameUserNamePassword1.lblEditUserName.Text;
  IdIMAP41.Password := frameUserNamePassword1.lblEditPassword.Text;
  IdIMAP41.Connect;
  IdIMAP41.ListMailBoxes(lbMailboxes.Items);
  IdIMAP41.Disconnect;
end;

procedure TformListMailboxes.EnsureCredentialsPresent;
begin
  if (frameUserNamePassword1.lblEditUserName.Text = '') or
     (frameUserNamePassword1.lblEditPassword.Text = '') then
      raise Exception.Create('UserName or password not set');
end;

procedure TformListMailboxes.Exit1Click(Sender: TObject);
begin
  formGmailSender.Close;
  Close;
end;

procedure TformListMailboxes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Terminate;
  Action := caFree;
end;

function TformListMailboxes.GetPassword: string;
begin
  Result := frameUserNamePassword1.lblEditPassword.Text;
end;

function TformListMailboxes.GetUserName: string;
begin
  Result := frameUserNamePassword1.lblEditUserName.Text;
end;

procedure TformListMailboxes.lbMailboxesDblClick(Sender: TObject);
var
  LMailBoxName: string;
begin
  LMailBoxName := lbMailboxes.Items[lbMailboxes.ItemIndex];
  formGmailSender.MailBoxName := LMailBoxName;

  if UserName <> '' then
    formGmailSender.UserName := UserName;
  if Password <> '' then
    formGmailSender.Password := Password;

  Hide;
  formGmailSender.Show;
  formGmailSender.Connect;
end;

procedure TformListMailboxes.SetPassword(const Value: string);
begin
  frameUserNamePassword1.lblEditPassword.Text := Value;
end;

procedure TformListMailboxes.SetUserName(const Value: string);
begin
  frameUserNamePassword1.lblEditUserName.Text := Value;
end;

end.
