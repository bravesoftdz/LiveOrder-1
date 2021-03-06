inherited frmCommunicatorCustomer: TfrmCommunicatorCustomer
  Width = 697
  Caption = 'frmCommunicatorCustomer'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlTop: TPanel
    Width = 681
    inherited CoolBar1: TCoolBar
      Width = 681
      Bands = <
        item
          Control = ToolBar1
          ImageIndex = -1
          Width = 681
        end>
      inherited ToolBar1: TToolBar
        Width = 668
        inherited DBNavigator1: TDBNavigator
          Hints.Strings = ()
        end
      end
    end
  end
  inherited pnlBottom: TPanel
    Width = 681
    object Label4: TLabel
      Left = 8
      Top = 13
      Width = 64
      Height = 13
      Caption = 'Customer No.'
    end
    object btnSave: TButton
      Left = 400
      Top = 8
      Width = 97
      Height = 25
      Caption = 'Assign Customer'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object dbcbbCustomer: TDBLookupComboboxEh
      Left = 80
      Top = 10
      Width = 290
      Height = 21
      DropDownBox.Columns = <
        item
          FieldName = 'CustomerNumber'
          Title.Caption = 'Customer No.'
          Width = 60
        end
        item
          FieldName = 'CustomerName'
          Title.Caption = 'Customer Name'
          Width = 100
        end>
      DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh, dlgRowLinesEh, dlgAutoSortMarkingEh, dlgMultiSortMarkingEh]
      DropDownBox.UseMultiTitle = True
      DropDownBox.ShowTitles = True
      DropDownBox.Sizable = True
      EditButtons = <>
      KeyField = 'CustomerID'
      ListField = 'CustomerNumber'
      ListSource = ds_customer
      TabOrder = 1
      Visible = True
    end
  end
  inherited pnlBody: TPanel
    Width = 681
    inherited Splitter1: TSplitter
      Width = 681
    end
    inherited PageControl1: TPageControl
      Width = 681
      inherited tbsBody1: TTabSheet
        inherited GroupBox1: TGroupBox
          Width = 673
          inherited gridData: TDBGridEh
            Width = 669
            Columns = <
              item
                EditButtons = <>
                FieldName = 'CommunicatorID'
                Footers = <>
                Title.Caption = 'ID'
                Width = 45
              end
              item
                EditButtons = <>
                FieldName = 'CommunicatorCode'
                Footers = <>
                Title.Caption = 'Communicator Code'
                Width = 74
              end
              item
                EditButtons = <>
                FieldName = 'CommunicatorPhone'
                Footers = <>
                Title.Caption = 'Communicator Phone'
                Width = 131
              end
              item
                EditButtons = <>
                FieldName = 'CommunicatorFax'
                Footers = <>
                Title.Caption = 'Communicator Fax'
                Width = 141
              end
              item
                EditButtons = <>
                FieldName = 'CommunicatorMail'
                Footers = <>
                Title.Caption = 'Communicator Mail'
                Width = 136
              end
              item
                EditButtons = <>
                FieldName = 'DisplayName1'
                Footers = <>
                Title.Caption = 'Communicator Name'
              end
              item
                EditButtons = <>
                FieldName = 'MainframeDisplayName'
                Footers = <>
                Title.Caption = 'Mainframe Display Name'
                Width = 112
              end>
          end
        end
      end
    end
    inherited GroupBox2: TGroupBox
      Width = 681
      inherited gridData2: TDBGridEh
        Width = 677
        Columns = <
          item
            EditButtons = <>
            FieldName = 'CustomerNumber'
            Footers = <>
            Title.Caption = 'Customer No.'
            Width = 86
          end
          item
            DropDownBox.Options = [dlgColumnResizeEh, dlgColLinesEh]
            DropDownBox.UseMultiTitle = True
            DropDownRows = 14
            DropDownShowTitles = True
            DropDownSizing = True
            DropDownWidth = -1
            EditButtons = <>
            FieldName = 'CustomerName1'
            Footers = <>
            LookupDisplayFields = 'CustomerName;ChineseName;Origin;CustomerNumber'
            Title.Caption = 'Customer Name'
          end>
      end
    end
  end
  inherited adt_active: TADODataSet
    AfterScroll = adt_activeAfterScroll
    object adt_activeCommunicatorID: TAutoIncField
      FieldName = 'CommunicatorID'
      ReadOnly = True
    end
    object adt_activeCommunicatorCode: TStringField
      FieldName = 'CommunicatorCode'
      Size = 3
    end
    object adt_activeCommunicatorPhone: TStringField
      FieldName = 'CommunicatorPhone'
      Size = 30
    end
    object adt_activeCommunicatorFax: TStringField
      FieldName = 'CommunicatorFax'
      Size = 30
    end
    object adt_activeCommunicatorMail: TStringField
      FieldName = 'CommunicatorMail'
      Size = 50
    end
    object adt_activeLoginID: TIntegerField
      FieldName = 'LoginID'
    end
    object adt_activeDisplayName: TStringField
      FieldName = 'DisplayName'
    end
    object adt_activeDisplayName1: TStringField
      FieldKind = fkLookup
      FieldName = 'DisplayName1'
      LookupDataSet = adt_login
      LookupKeyFields = 'LoginID'
      LookupResultField = 'DisplayName'
      KeyFields = 'LoginID'
      Lookup = True
    end
    object adt_activeMainframeDisplayName: TStringField
      FieldName = 'MainframeDisplayName'
      Size = 10
    end
  end
  inherited adt_active2: TADODataSet
    object adt_active2CustomerID: TIntegerField
      FieldName = 'CustomerID'
    end
    object adt_active2CustomerNumber: TStringField
      FieldName = 'CustomerNumber'
      Size = 10
    end
    object adt_active2CustomerName: TStringField
      FieldName = 'CustomerName'
      Size = 40
    end
    object adt_active2CustomerName1: TStringField
      FieldKind = fkLookup
      FieldName = 'CustomerName1'
      LookupDataSet = adt_customer
      LookupKeyFields = 'CustomerID'
      LookupResultField = 'CustomerName'
      KeyFields = 'CustomerID'
      Size = 40
      Lookup = True
    end
  end
  object adt_login: TADODataSet
    Connection = DM.ADOConnection1
    CommandText = 
      ' select l.*,p.PlantCode from Login l'#13#10'   left outer join Plant p' +
      ' on p.plantid=l.plantid'
    Parameters = <>
    Left = 248
    Top = 9
  end
  object adt_customer: TADODataSet
    Connection = DM.ADOConnection1
    CommandText = 
      'select c.CustomerID,c.CustomerNumber,c.CustomerName'#13#10'    ,c.Full' +
      'Name,c.ChineseName,c.Country,c.ContactPerson,c.Telephone'#13#10'    ,c' +
      '.Fax,c.CellPhone,c.Email,c.PlantID,p.PlantCode'#13#10'     from Custom' +
      'er c'#13#10'     left outer join Plant p on c.PlantID=p.PlantID'
    Parameters = <>
    Left = 296
    Top = 9
  end
  object ds_customer: TDataSource
    DataSet = adt_customer
    Left = 337
    Top = 11
  end
end
