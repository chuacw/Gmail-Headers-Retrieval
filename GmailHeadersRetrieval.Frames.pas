unit GmailHeadersRetrieval.Frames;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TframeUserNamePassword = class(TFrame)
    lblEditUserName: TLabeledEdit;
    lblEditPassword: TLabeledEdit;
    Panel1: TPanel;
    cbDomains: TCheckBox;
    UpDown1: TUpDown;
    lblEditThreadCount: TLabeledEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frameUserNamePassword: TframeUserNamePassword;

implementation

{$R *.dfm}

end.
