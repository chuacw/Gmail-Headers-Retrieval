program GmailHeadersRetrieval;

uses
  Vcl.Forms,
  GmailHeaderRetrieval.Main in 'GmailHeaderRetrieval.Main.pas' {formGmailSender},
  GmailHeaderRetrieval.ListMailBoxes.Main in 'GmailHeaderRetrieval.ListMailBoxes.Main.pas' {formListMailboxes},
  GmailHeaderRetrieval.Frames in 'GmailHeaderRetrieval.Frames.pas' {frameUserNamePassword: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Gmail Headers Retrieval';
  Application.CreateForm(TformGmailSender, formGmailSender);
  Application.CreateForm(TformListMailboxes, formListMailboxes);
  Application.Run;
end.
