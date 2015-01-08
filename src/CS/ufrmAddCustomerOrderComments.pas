unit ufrmAddCustomerOrderComments;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmBasic, ActnList, ImgList, ComCtrls, ToolWin, ExtCtrls,
  DB, ADODB, StdCtrls, DBGridEh, Mask, DBCtrlsEh, DBLookupEh, DBCtrls,
  Buttons, GridsEh, Menus, shellapi;

type
  TfrmAddCustomerOrderComments = class(TfrmBasic)
    dbedtCustomerOrderID: TDBEditEh;
    Label10: TLabel;
    Label14: TLabel;
    dbedtOrderStates: TDBEditEh;
    gboxOrder: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dbtxtCustomerCode: TDBText;
    dbtxtCustomerName: TDBText;
    dbtxtCONumber: TDBText;
    ds_active: TDataSource;
    OpenDialog1: TOpenDialog;
    adt_comments: TADODataSet;
    ds_comments: TDataSource;
    gboxComments: TGroupBox;
    gboxAddComments: TGroupBox;
    memoContent: TMemo;
    Label6: TLabel;
    Label1: TLabel;
    dbcbbCommentsType: TDBLookupComboboxEh;
    gridComments: TDBGridEh;
    gboxCommentsAttach: TGroupBox;
    gridCommentsAttach: TDBGridEh;
    adt_type: TADODataSet;
    adt_attach: TADODataSet;
    ds_type: TDataSource;
    ds_attach: TDataSource;
    adt_attachCustomerOrderCommentsAttachID: TAutoIncField;
    adt_attachCustomerOrderCommentsID: TIntegerField;
    adt_attachAttachmentName: TStringField;
    adt_attachAttachment: TBlobField;
    adt_commentsCustomerOrderCommentsID: TAutoIncField;
    adt_commentsCustomerOrderID: TIntegerField;
    adt_commentsCustomerOrderCommentsTypeID: TIntegerField;
    adt_commentsCommentsContent: TStringField;
    adt_commentsUpdateTime: TDateTimeField;
    adt_commentsCustomerOrderCommentsTypeName: TStringField;
    adt_commentsCustomerOrderCommentsSubCategory: TStringField;
    btnSave: TButton;
    btnExit: TButton;
    PopupMenu1: TPopupMenu;
    MenuUploadAttachment: TMenuItem;
    ProgressBar1: TProgressBar;
    MenuDowloadAttachment: TMenuItem;
    SaveDialog1: TSaveDialog;
    MenuOpenAttachment: TMenuItem;
    MenuDeleteAttachment: TMenuItem;
    N1: TMenuItem;
    MenuDeleteComments: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    DBNavigator1: TDBNavigator;
    procedure adt_commentsAfterScroll(DataSet: TDataSet);
    procedure btnExitClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure dbedtCustomerOrderIDChange(Sender: TObject);
    procedure MenuUploadAttachmentClick(Sender: TObject);
    procedure MenuDowloadAttachmentClick(Sender: TObject);
    procedure gridCommentsEnter(Sender: TObject);
    procedure gridCommentsAttachEnter(Sender: TObject);
    procedure MenuOpenAttachmentClick(Sender: TObject);
    procedure MenuDeleteAttachmentClick(Sender: TObject);
    procedure MenuDeleteCommentsClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure SetData; override;
    procedure SetUI; override;
    procedure SetAccess; override;
  public
    { Public declarations }
    class procedure EdtFromList(adt_from: TADODataSet);
  end;


implementation

uses DataModule, uMJ;

{$R *.dfm}

{ TfrmBasic1 }

procedure TfrmAddCustomerOrderComments.SetData;
begin
  DM.DataSetQuery(adt_type, 'EXEC usp_GetCustomerOrderCommentsType');
end;

procedure TfrmAddCustomerOrderComments.SetUI;
begin
  inherited;
  Position := poOwnerFormCenter;
end;

procedure TfrmAddCustomerOrderComments.SetAccess;
begin
  inherited;
  gridComments.ReadOnly := true;
  gridCommentsAttach.ReadOnly := true;
end;

procedure TfrmAddCustomerOrderComments.gridCommentsEnter(Sender: TObject);
begin
  MenuUploadAttachment.Visible := true;
  MenuDeleteComments.Visible := true;
  MenuDowloadAttachment.Visible := false;
  MenuOpenAttachment.Visible := false;
  MenuDeleteAttachment.Visible := false;
end;

procedure TfrmAddCustomerOrderComments.gridCommentsAttachEnter(
  Sender: TObject);
begin
  MenuUploadAttachment.Visible := false;
  MenuDeleteComments.Visible := false;
  MenuDowloadAttachment.Visible := true;
  MenuOpenAttachment.Visible := true;
  MenuDeleteAttachment.Visible := true;
end;

class procedure TfrmAddCustomerOrderComments.EdtFromList(adt_from: TADODataSet);
begin
  with TfrmAddCustomerOrderComments.Create(Application) do
  try            
    if adt_from.RecordCount = 0 then exit;
    ds_active.DataSet := adt_from;
    if (adt_from.State in [dsEdit]) then
      adt_from.Cancel;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmAddCustomerOrderComments.dbedtCustomerOrderIDChange(
  Sender: TObject);
begin
  gboxComments.Caption := 'Comments Of Order ID : ' + dbedtCustomerOrderID.Text;
  DM.DataSetQuery(adt_comments, 'EXEC usp_GetCustomerOrderComments @CustomerOrderID='
    + VarToStr(dbedtCustomerOrderID.Value));
  gridComments.DataSource.DataSet.Active := false;
  gridComments.DataSource.DataSet.Active := true;
end;

procedure TfrmAddCustomerOrderComments.adt_commentsAfterScroll(
  DataSet: TDataSet);
begin
  gboxCommentsAttach.Caption := 'Attachment Of Comments ID : '
    + DataSet.fieldbyname('CustomerOrderCommentsID').AsString;
  if gridComments.DataSource.DataSet.RecordCount > 0 then
    DM.DataSetQuery(adt_attach, 'EXEC usp_GetCustomerOrderCommentsAttachment '
      + ' @CustomerOrderCommentsID=' + DataSet.fieldbyname('CustomerOrderCommentsID').AsString);
end;

procedure TfrmAddCustomerOrderComments.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAddCustomerOrderComments.btnSaveClick(Sender: TObject);
begin
  if VarToStr(dbcbbCommentsType.Value) = '' then
  begin
    ShowMessage('Please select comments type.');
    Exit;
  end;
  if Trim(memoContent.Text) = '' then
  begin
    ShowMessage('Please input comments content.');
    Exit;
  end;
  DM.DataSetModify('EXEC usp_InsertCustomerOrderComments '
    + ' @CustomerOrderID=' + VarToStr(dbedtCustomerOrderID.Value)
    + ',@CustomerOrderCommentsTypeID=' + VarToStr(dbcbbCommentsType.Value)
    + ',@CommentsContent=''' + Trim(memoContent.Text) + '''');
  memoContent.Clear;
  gridComments.DataSource.DataSet.Active := false;
  gridComments.DataSource.DataSet.Active := true;
end;

procedure TfrmAddCustomerOrderComments.MenuDeleteCommentsClick(
  Sender: TObject);
begin
  if MessageDlg('Delete Comments?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  DM.DataSetModify('EXEC usp_DeleteCustomerOrderComments '
    + ' @CustomerOrderCommentsID=' + gridComments.DataSource.DataSet.fieldbyname('CustomerOrderCommentsID').AsString);
  gridComments.DataSource.DataSet.Active := false;
  gridComments.DataSource.DataSet.Active := true;
end;

procedure TfrmAddCustomerOrderComments.MenuDeleteAttachmentClick(
  Sender: TObject);
begin
  if MessageDlg('Delete Comments Attachment?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  DM.DataSetModify('EXEC usp_DeleteCustomerOrderCommentsAttachment '
    + ' @CustomerOrderCommentsAttachID=' + gridCommentsAttach.DataSource.DataSet.fieldbyname('CustomerOrderCommentsAttachID').AsString);
  gridCommentsAttach.DataSource.DataSet.Active := false;
  gridCommentsAttach.DataSource.DataSet.Active := true;
end;

procedure TfrmAddCustomerOrderComments.MenuUploadAttachmentClick(
  Sender: TObject);
const
  BufSize = $F000;
var
  Counter, N: Integer;
  Buffer: PAnsiChar;
  FieldStrm: TStream;
  ExeFileStream: TFileStream;
  //size_tmp: Double;
begin
  if OpenDialog1.Execute then
  begin
    with gridCommentsAttach.DataSource.DataSet do
    begin
      Open;
      //Edit;
      Append;
      ExeFileStream := TFileStream.Create(OpenDialog1.FileName, fmopenRead); //���ļ�
      try
        FieldStrm := CreateBlobStream(FieldByName('Attachment'), bmWrite);
        GetMem(Buffer, BufSize);
        try
          Counter := ExeFileStream.Size;
          //size_tmp := ExeFileStream.Size;
          ProgressBar1.Position := 0;
          ProgressBar1.Max := Counter div BufSize; //ÿ���ϴ��ļ���Ϊ61440   byte   =   $F000
          while Counter <> 0 do
          begin
            if Counter > BufSize then
              N := BufSize
            else
              N := Counter;
            ExeFileStream.ReadBuffer(Buffer^, N);
            FieldStrm.WriteBuffer(Buffer^, N);
            Dec(Counter, N);
            ProgressBar1.Position := ProgressBar1.Position + 1;
            Application.ProcessMessages;
          end;
        finally
          FreeMem(Buffer, BufSize);
          FieldStrm.Free;
        end;
        FieldByName('CustomerOrderCommentsID').Value := gridComments.DataSource.DataSet.fieldbyname('CustomerOrderCommentsID').AsString;
        FieldByName('AttachmentName').Value := ExtractFileName(OpenDialog1.FileName);
        //FieldByName('AttachmentSize').Value := size_tmp;
        Post;
        Application.MessageBox('Upload success!', 'Prompt', MB_OK + MB_IconInformation);
      finally
        ProgressBar1.Position := ProgressBar1.Max;
        ExeFileStream.Free;
        //CanLeave := True;
      end;
    end;
  end;
end;

procedure TfrmAddCustomerOrderComments.MenuDowloadAttachmentClick(
  Sender: TObject);
const
  MaxBufSize = $F000;
var
  myfilename: string; //�����ļ���·�����ļ���
  myfileStream, exeBlobStream: TStream;
  Count, BufSize, N: Integer;
  Buffer: PChar;
begin
  SaveDialog1.FileName := gridCommentsAttach.DataSource.DataSet.FieldByName('AttachmentName').AsString;
  if SaveDialog1.Execute then
  begin
    with gridCommentsAttach.DataSource.DataSet do
    begin
      Open;
      Edit;
      //myfilename := ExtractFilePath(Application.ExeName) + FieldByName('AttachmentName').AsString; //����ļ�������·��
      myfilename := SaveDialog1.FileName;
      myfileStream := TFileStream.Create(myfilename, fmCreate); //�����ļ�
      try //SaveToStream(Stream);
        ExeBlobStream := CreateBlobStream(FieldByName('Attachment'), bmRead); //�����ݿ���ȡ�ü�¼
        Count := 0;
        try
          if Count = 0 then
          begin
            ExeBlobStream.Position := 0;
            Count := ExeBlobStream.Size; //showmessage(inttostr(count));
          end;
          if Count > MaxBufSize then
            BufSize := MaxBufSize
          else
            BufSize := Count;
          GetMem(Buffer, BufSize);

          ProgressBar1.Position := 0;
          ProgressBar1.Max := count div bufsize; //ÿ��д���ļ�����������СΪbufsize,����maxΪcount   ����   bufsize
          try
            while Count <> 0 do
            begin
              if Count > BufSize then
                N := BufSize
              else
                N := Count;
              ExeBlobStream.ReadBuffer(Buffer^, N); //�����ݿ����ȡ������
              MyFileStream.WriteBuffer(Buffer^, N); //��������д���ļ�
              Dec(Count, N);
              ProgressBar1.Position := ProgressBar1.Position + 1;
            end;
          finally
            FreeMem(Buffer, BufSize);
          end;
        finally
          ExeBlobStream.Free;
        end;
      finally
        myfileStream.Free;
      end;
    end;
    MessageBox(Handle, pchar('Download success.'), 'Prompt', MB_ICONINFORMATION);
  end;
end;

procedure TfrmAddCustomerOrderComments.MenuOpenAttachmentClick(
  Sender: TObject);
const
  MaxBufSize = $F000;
var
  myfilename: string; //�����ļ���·�����ļ���
  myfileStream, exeBlobStream: TStream;
  Count, BufSize, N: Integer;
  Buffer: PChar;
begin
  with gridCommentsAttach.DataSource.DataSet do
  begin
    Open;
    Edit;
      //myfilename := ExtractFilePath(Application.ExeName) + FieldByName('AttachmentName').AsString; //����ļ�������·��
    myfilename := 'D:\' + FieldByName('AttachmentName').AsString; //����ļ�������·��
    myfileStream := TFileStream.Create(myfilename, fmCreate); //�����ļ�
    try //SaveToStream(Stream);
      ExeBlobStream := CreateBlobStream(FieldByName('Attachment'), bmRead); //�����ݿ���ȡ�ü�¼
      Count := 0;
      try
        if Count = 0 then
        begin
          ExeBlobStream.Position := 0;
          Count := ExeBlobStream.Size; //showmessage(inttostr(count));
        end;
        if Count > MaxBufSize then
          BufSize := MaxBufSize
        else
          BufSize := Count;
        GetMem(Buffer, BufSize);

        ProgressBar1.Position := 0;
        ProgressBar1.Max := count div bufsize; //ÿ��д���ļ�����������СΪbufsize,����maxΪcount   ����   bufsize
        try
          while Count <> 0 do
          begin
            if Count > BufSize then
              N := BufSize
            else
              N := Count;
            ExeBlobStream.ReadBuffer(Buffer^, N); //�����ݿ����ȡ������
            MyFileStream.WriteBuffer(Buffer^, N); //��������д���ļ�
            Dec(Count, N);
            ProgressBar1.Position := ProgressBar1.Position + 1;
          end;
        finally
          FreeMem(Buffer, BufSize);
        end;
      finally
        ExeBlobStream.Free;
      end;
    finally
      myfileStream.Free;
    end;
  end;
  ShellExecute(handle, 'open', PChar(myfilename), nil, nil, SW_SHOW);
end;

end.