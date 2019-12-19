unit GmailHeadersRetrieval.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdPOP3, Vcl.StdCtrls, Vcl.ComCtrls,
  IdMessageClient, IdIMAP4, Vcl.ExtCtrls, System.Generics.Collections,
  IdThreadSafe, TestGmail.Frames, Vcl.Menus, System.Threading, Vcl.WinXCtrls,
  GmailHeaderRetrieval.Frames, GmailHeadersRetrieval.Frames;

type
  TformGmailSender = class(TForm)
    IdIMAP41: TIdIMAP4;
    PanelStatus: TPanel;
    btnConnect: TButton;
    Label1: TLabel;
    btnCancel: TButton;
    PanelListView: TPanel;
    ListView1: TListView;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    frameUserNamePassword1: TframeUserNamePassword;
    MainMenu1: TMainMenu;
    MailBoxes1: TMenuItem;
    mnuListMailBoxes: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Panel1: TPanel;
    leMailBoxName: TLabeledEdit;
    ActivityIndicator1: TActivityIndicator;
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure mnuListMailBoxesClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
    FStopped: Boolean;
    FThreads: TArray<TThread>;
    FNumThreads: Integer;
    FRetrievedCount, FDone: TIdThreadSafeInteger;
    FDictionary: TDictionary<string, TListItem>;

    procedure CreateThread(AThreadIndex: Integer; var VThread: TThread;
      const AMailBoxName, AUserName, APassword: string; Low, High: Integer);
    function CreateWorkerProc(const AMailBoxName, AUserName, APassword: string; Low, High: Integer): TProc;
    procedure EnsureCredentialsPresent;
    procedure FreeThreads;
    procedure FreeAll;
    procedure ResetUI;
    procedure RetrievalCancel;
    procedure RetrievalDone;
    procedure WaitThreads;
    procedure SetMailBoxName(const Value: string);
    function GetMailBoxName: string;
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    function GetPassword: string;
    function GetUserName: string;
  public
    { Public declarations }
    procedure Connect;

    property MailBoxName: string read GetMailBoxName write SetMailBoxName;
    property Password: string read GetPassword write SetPassword;
    property UserName: string read GetUserName write SetUserName;
  end;

var
  formGmailSender: TformGmailSender;

implementation
uses
  IdMessage, IdGlobal, System.DateUtils, GmailHeaderRetrieval.ListMailBoxes.Main;

{$R *.dfm}

procedure TformGmailSender.btnCancelClick(Sender: TObject);
begin
  RetrievalCancel;
end;

function SortSenderCount(lParam1, lParam2, lParamSort: LPARAM): Integer stdcall;
var
  LCount1, LCount2: Integer;
begin
  LCount1 := StrToInt(TListItem(lParam1).SubItems[0]);
  LCount2 := StrToInt(TListItem(lParam2).SubItems[0]);
  Result := LCount2 - LCount1;
end;

procedure TformGmailSender.btnConnectClick(Sender: TObject);
begin
  Connect;
end;

function TformGmailSender.CreateWorkerProc(const AMailBoxName, AUserName,
  APassword: string; Low, High: Integer): TProc;
var
  LDomainsOnly1: Boolean;
begin
  LDomainsOnly1 := frameUserNamePassword1.cbDomains.Checked;
  Result := procedure
  var
    LIMAP: TIdIMAP4;
    LMsg: TIdMessage;
    I, LRetrieveCount, LMessageCount: Integer;
    LastTime, CurrentTime: TDateTime;
    LSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
    LDomainsOnly: Boolean;
  begin
    LSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    LSSLHandler.Host := 'imap.gmail.com';
    LSSLHandler.Port := 993;
    LSSLHandler.SSLOptions.Mode := sslmClient;
    LSSLHandler.SSLOptions.VerifyMode := [];
    LSSLHandler.SSLOptions.VerifyDepth := 0;
    LSSLHandler.MaxLineAction := maException;

    LDomainsOnly := LDomainsOnly1;
    LMsg := TIdMessage.Create;
    LIMAP := TIdIMAP4.Create(nil);

    LIMAP.Username := AUserName;
    LIMAP.Password := APassword;
    LIMAP.Port := 993;
    LIMAP.Host := 'imap.gmail.com';
    LIMAP.IOHandler := LSSLHandler;
    LIMAP.UseTLS := utUseImplicitTLS;

    LIMAP.Connect;
    try
      LMessageCount := 0; LRetrieveCount := 0;
      if LIMAP.SelectMailBox(AMailBoxName) then
        LMessageCount := LIMAP.MailBox.TotalMsgs;
      try
        LastTime := Now;
        if High > LMessageCount then
          High := LMessageCount;
        for I := High downto Low do
          begin
            if FStopped then
              Break;
            LMsg.Clear;

            if not LIMAP.RetrieveHeader(I, LMsg) then
              Continue;
            LRetrieveCount := FRetrievedCount.Increment;
            CurrentTime := Now;

            TThread.Synchronize(nil, procedure
            var
              LStatus, LCaption, LSenderName, LSenderAddr: string;
              LSenderCount: Integer;
              LNewItem, LFoundItem: TListItem;
            begin
              if SecondsBetween(CurrentTime, LastTime) > 5 then
                begin
                  LStatus := Format('Retrieving %d of %d headers.', [LRetrieveCount, LMessageCount]);
                  Label1.Caption := LStatus;
                  ListView1.CustomSort(SortSenderCount, 0);
                  ListView1.Invalidate;
                  LastTime := Now;
                end;
              if LDomainsOnly then
                begin
                  LSenderAddr := LMsg.From.Domain;
                  LCaption := Format('"%s"', [LSenderAddr]);
                end else
                begin
                  LSenderAddr := LMsg.From.Address;
                  LSenderName := LMsg.From.Name;
                  LCaption := Format('"%s" ("%s")', [LSenderName, LSenderAddr]);
                end;

              if FDictionary.TryGetValue(LSenderAddr, LFoundItem) then
                begin
                  LSenderCount := StrToInt(LFoundItem.SubItems[0]);
                  Inc(LSenderCount);
                  LFoundItem.SubItems[0] := IntToStr(LSenderCount);
                end else
                begin
                  LNewItem := ListView1.Items.Add;
                  LNewItem.Caption := LCaption;
                  LNewItem.SubItems.Add('1');
                  FDictionary.AddOrSetValue(LSenderAddr, LNewItem);
                end;
            end);
          end;
      finally
        LMsg.Free;
      end;
    finally
      LSSLHandler.Free;
      LIMAP.Disconnect;
      LIMAP.Free;
      FDone.Increment;
    end;
  end;
end;

procedure TformGmailSender.RetrievalCancel;
begin
  FStopped := True;
  if FRetrievedCount.Value <> 0 then
    Label1.Caption := Format('Cancelled - Retrieved %d headers.', [FRetrievedCount.Value]) else
    Label1.Caption := 'Cancelled.';
  ResetUI;
  if Assigned(FThreads) then
    begin
      FreeAll;
    end;
  ResetUI;
end;

procedure TformGmailSender.RetrievalDone;
begin
  Label1.Caption := Format('All done! Retrieved %d headers.', [FRetrievedCount.Value]);
  ResetUI;
end;

procedure TformGmailSender.SetMailBoxName(const Value: string);
begin
  leMailBoxName.Text := Value;
end;

procedure TformGmailSender.SetPassword(const Value: string);
begin
  frameUserNamePassword1.lblEditPassword.Text := Value;
end;

procedure TformGmailSender.SetUserName(const Value: string);
begin
  frameUserNamePassword1.lblEditUserName.Text := Value;
end;

procedure TformGmailSender.Connect;
var
  LThreadIndex, LNumThreads, LMessageCount, LRange, LLow, LHigh: Integer;
  LMailBoxName: string;
  LThread: TThread;
begin
  EnsureCredentialsPresent;

  FreeAll;
  FDone.Value := 0;
  ListView1.Items.Clear;
  FStopped := False;
  IdIMAP41.Username := frameUserNamePassword1.lblEditUserName.Text;
  IdIMAP41.Password := frameUserNamePassword1.lblEditPassword.Text;
  Label1.Caption := 'Trying to connect...';
  if not IdIMAP41.Connected then
    begin
      IdIMAP41.Connect;
    end;

  btnCancel.Enabled := True;
  btnConnect.Enabled := False;
  Label1.Caption := 'Starting retrieval...';

  if MailBoxName = '' then
    MailBoxName := 'INBOX';

  LMessageCount := 0; LMailBoxName := MailBoxName;
  if IdIMAP41.SelectMailBox(LMailBoxName) then
    LMessageCount := IdIMAP41.MailBox.TotalMsgs;

  ActivityIndicator1.Animate := True;

  LNumThreads := StrToIntDef(frameUserNamePassword1.lblEditThreadCount.Text, 6);
  FNumThreads := LNumThreads;

  // Change the retrieval count below here by setting LMessageCount to a value you want
  LRange := LMessageCount div LNumThreads;
  LLow := LMessageCount + 1;

  for LThreadIndex := 1 to LNumThreads do
    begin
      LHigh := LLow-1; LLow := (LHigh-LRange)+1;
      if LHigh > LMessageCount then
        LHigh := LMessageCount;
      if (LLow < 1) or (LThreadIndex = LNumThreads) then
        LLow := 1;
      CreateThread(LThreadIndex, LThread, LMailBoxName, IdIMAP41.UserName, IdIMAP41.Password,
        LLow, LHigh);
       FThreads := FThreads + [LThread];
    end;
  WaitThreads;
end;

procedure TformGmailSender.CreateThread(AThreadIndex: Integer; var VThread: TThread;
  const AMailBoxName, AUserName, APassword: string; Low, High: Integer);
begin
  VThread := TThread.CreateAnonymousThread(CreateWorkerProc(AMailBoxName, AUserName, APassword, Low, High));
  VThread.NameThreadForDebugging(Format('IMAP Thread %d %p',
    [AThreadIndex, Pointer(VThread)]), VThread.ThreadID);
  VThread.FreeOnTerminate := False;
  VThread.Start;
end;

procedure TformGmailSender.EnsureCredentialsPresent;
begin
  if (frameUserNamePassword1.lblEditUserName.Text = '') or
     (frameUserNamePassword1.lblEditPassword.Text = '') then
      raise Exception.Create('UserName or password not set');
end;

procedure TformGmailSender.Exit1Click(Sender: TObject);
begin
  formListMailboxes.Close;
  Close;
end;

procedure TformGmailSender.FormCreate(Sender: TObject);
begin
  FDictionary := TDictionary<string, TListItem>.Create;
  FRetrievedCount := TIdThreadSafeInteger.Create;
  FDone := TIdThreadSafeInteger.Create;
end;

procedure TformGmailSender.FormDestroy(Sender: TObject);
begin
  FreeAll;
  FRetrievedCount.Free;
  FreeAndNil(FDictionary);
end;

procedure TformGmailSender.FreeAll;
begin
  FStopped := True;
  FDictionary.Clear;
  FRetrievedCount.Value := 0;
  FreeThreads;
end;

procedure TformGmailSender.FreeThreads;
var
  I: Integer;
begin
  for I := Low(FThreads) to High(FThreads) do
    begin
      FThreads[I].Terminate;
      FThreads[I].Free;
    end;
  FThreads := nil;
end;

function TformGmailSender.GetMailBoxName: string;
begin
  Result := leMailBoxName.Text;
end;

function TformGmailSender.GetPassword: string;
begin
  Result := frameUserNamePassword1.lblEditPassword.Text;
end;

function TformGmailSender.GetUserName: string;
begin
  Result := frameUserNamePassword1.lblEditUserName.Text;
end;

procedure TformGmailSender.mnuListMailBoxesClick(Sender: TObject);
begin
  if UserName <> '' then
    formListMailboxes.UserName := UserName;
  if Password <> '' then
    formListMailboxes.Password := Password;

  Hide;
  formListMailboxes.Show;
end;

procedure TformGmailSender.ResetUI;
begin
  btnCancel.Enabled := False;
  btnConnect.Enabled := True;
  ActivityIndicator1.Animate := False;
end;

procedure TformGmailSender.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var
  LThreadCount: Integer;
begin
  LThreadCount := StrToInt(frameUserNamePassword1.lblEditThreadCount.Text);
  case Button of
    btNext: Inc(LThreadCount);
    btPrev: Dec(LThreadCount);
  end;
  frameUserNamePassword1.lblEditThreadCount.Text := IntToStr(LThreadCount);
end;

procedure TformGmailSender.WaitThreads;
begin
  TThread.CreateAnonymousThread(
  procedure
  begin
    TThread.NameThreadForDebugging('Wait Thread', TThread.CurrentThread.ThreadID);
    repeat
      Sleep(100);
      if FDone.Value = FNumThreads then
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              RetrievalDone;
            end
          );
          Break;
        end;
    until FStopped;
  end
  ).Start;
end;

end.
