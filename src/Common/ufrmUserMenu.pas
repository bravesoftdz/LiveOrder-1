unit ufrmUserMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Menus, Dialogs, StdCtrls, Buttons, ComCtrls, ADODB, Mask, DBCtrlsEh, StrUtils;

type
  TfrmUserMenu = class(TForm)
    GroupBox4: TGroupBox;
    ListView2: TListView;
    bitBtnFinish: TBitBtn;
    bitBtnClose: TBitBtn;
    Label1: TLabel;
    edtLoginName: TEdit;
    edtDisplayName: TEdit;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    procedure bitBtnCloseClick(Sender: TObject);
    procedure bitBtnFinishClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    LoginID: string;
  public
    { Public declarations }
    procedure GetMenuName; //获得菜单名
    function SaveUserPurview: boolean; //保存用户权限
    class procedure EdtFromList(adt_from: TADODataSet);
  end;

var
  frmUserMenu: TfrmUserMenu;

implementation

uses DataModule, ufrmMain;

{$R *.dfm}

{ TfrmUserMenu }

class procedure TfrmUserMenu.EdtFromList(adt_from: TADODataSet);
begin
  with TfrmUserMenu.Create(Application) do
  try
{    ds_active.DataSet := adt_from;
    if (adt_from.State in [dsEdit]) then
      adt_from.Cancel;
         }
    //edtLoginID.Text := adt_from.fieldbyname('LoginID').AsString;
    LoginID := adt_from.fieldbyname('LoginID').AsString;
    edtLoginName.Text := adt_from.fieldbyname('LoginName').AsString;
    edtDisplayName.Text := adt_from.fieldbyname('DisplayName').AsString;
    GetMenuName;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmUserMenu.GetMenuName;

  function GetMenuLevel(menuid: string): string; //获得菜单ID长度判断极次
  begin
    if length(menuid) = 4 then
      result := '1'
    else if length(menuid) = 6 then
      result := '2'
    else if length(menuid) = 8 then
      result := '3';
  end;

  procedure GetUserMenu; //获得用户可用菜单
  var
    i: integer;
  begin
    for i := 0 to listview2.Items.Count - 1 do
    begin
      if dm.CCheckID('select * from userpurview where LoginID=''' + LoginID
        + ''' and menuid=''' + trim(listview2.Items.Item[i].Caption) + '''') then
        listview2.Items.Item[i].Checked := true;
    end;
  end;

var
  i: integer; //判断
  adt1, adt2: TADODataSet;
begin
  listview2.Items.Clear;
  adt1 := TADODataSet.Create(nil);
  adt2 := TADODataSet.Create(nil);
  try
    DM.DataSetQuery(adt1, 'select MenuID,MenuName from Menuinfo order by MenuSequence');
    adt1.First;
    while not adt1.Eof do
    begin
      if (frmMain.FindComponent(adt1.fieldbyname('MenuName').AsString) <> nil) and
        (GetMenuLevel(adt1.fieldbyname('MenuID').AsString) = '1') then
      begin
        DM.DataSetQuery(adt2, 'select MenuName,MenuID from Menuinfo where '
          + 'left(MenuID,4)=' + adt1.fieldbyname('MenuID').AsString + ' and len(menuid)>4 order by MenuSequence');
        i := 0;
        //ShowMessage(IntToStr(i) + '/' + trim(adt2.fieldbyname('MenuID').AsString) + '/' + adt1.fieldbyname('MenuName').AsString + '/' + (frmMain.FindComponent(adt1.fieldbyname('MenuName').AsString) as tmenuitem).Caption);
        while not adt2.Eof do
        begin
          with ListVIew2.Items.Add do
          begin
            if i = 0 then
            begin
              //ShowMessage(IntToStr(i) + '/' + adt2.fieldbyname('MenuID').AsString + '/' + adt1.fieldbyname('MenuName').AsString + '/' + (frmMain.FindComponent(adt1.fieldbyname('MenuName').AsString) as tmenuitem).Caption);
              Caption := leftstr(trim(adt2.fieldbyname('MenuID').AsString), 4);
              SubItems.Add((frmMain.FindComponent(trim(adt1.fieldbyname('MenuName').AsString)) as tmenuitem).Caption);
            end
            else
            begin
              //ShowMessage(IntToStr(i) + '/' + adt2.fieldbyname('MenuID').AsString + '/' + adt2.fieldbyname('MenuName').AsString + '/' + (frmMain.FindComponent(adt2.fieldbyname('MenuName').AsString) as tmenuitem).Caption);
              Caption := trim(adt2.fieldbyname('MenuID').AsString);
              SubItems.Add('       ' + (frmMain.FindComponent(trim(adt2.fieldbyname('MenuName').AsString)) as tmenuitem).Caption);
              adt2.Next;
            end;
          end;
          inc(i);
        end;
      end;
      adt1.Next;
    end;
    GetUserMenu;
  finally
    adt2.Free;
    adt1.Free;
  end;
end;

procedure TfrmUserMenu.bitBtnFinishClick(Sender: TObject);
begin
  if SaveUserPurview then
    application.messagebox('Save success!', 'Prompt!')
  else
    application.messagebox('Save failed!', 'Prompt!');
  Close;
end;

function TfrmUserMenu.SaveUserPurview: boolean;
var
  Query: TADOQuery;
  i: integer;
begin
  Query := TADOQuery.Create(self);
  Query.Connection := dm.ADOConnection1;
  try
    dm.ADOConnection1.BeginTrans;
    Query.SQL.Clear;
    Query.SQL.Text := 'delete from UserPurview where LoginID=:LID';
    Query.Parameters.ParamByName('LID').Value := LoginID;
    Query.ExecSQL;
    for i := 0 to listview2.Items.Count - 1 do
      if listview2.Items.Item[i].Checked then
      begin
        Query.SQL.Clear;
        Query.SQL.Text := 'insert into UserPurview (LoginID,menuid) values (:LID,:id)';
        Query.Parameters.ParamByName('LID').Value := LoginID;
        Query.Parameters.ParamByName('id').Value := trim(listview2.Items.Item[i].Caption);
        Query.ExecSQL;
      end;
    dm.ADOConnection1.CommitTrans;
    result := true;
  except
    dm.ADOConnection1.RollbackTrans;
    result := false;
  end;
  Query.Close;
  Query.Free;
end;

procedure TfrmUserMenu.bitBtnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmUserMenu.CheckBox1Click(Sender: TObject);
var
  i: integer;
begin
  if CheckBox1.Checked then
  begin
    for i := 0 to listview2.Items.Count - 1 do
    begin
      listview2.Items.Item[i].Checked := true;
    end;
  end
  else
  begin
    for i := 0 to listview2.Items.Count - 1 do
    begin
      listview2.Items.Item[i].Checked := False;
    end;
  end;
end;

end.
