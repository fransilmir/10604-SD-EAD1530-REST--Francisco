object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Client'
  ClientHeight = 256
  ClientWidth = 597
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 93
    Width = 90
    Height = 13
    Caption = 'Tamanho da Pizza:'
  end
  object Label2: TLabel
    Left = 16
    Top = 136
    Width = 74
    Height = 13
    Caption = 'Sabor da Pizza:'
  end
  object Label3: TLabel
    Left = 312
    Top = 8
    Width = 118
    Height = 13
    Caption = 'Retorno do WebService:'
  end
  object edtDocumentoCliente: TLabeledEdit
    Left = 16
    Top = 64
    Width = 193
    Height = 21
    EditLabel.Width = 98
    EditLabel.Height = 13
    EditLabel.Caption = 'N'#250'mero Documento:'
    TabOrder = 0
  end
  object cmbTamanhoPizza: TComboBox
    Left = 16
    Top = 109
    Width = 193
    Height = 21
    TabOrder = 1
    Items.Strings = (
      'enPequena'
      'enMedia'
      'enGrange')
  end
  object cmbSaborPizza: TComboBox
    Left = 16
    Top = 152
    Width = 193
    Height = 21
    TabOrder = 2
    Items.Strings = (
      'enCalabresa'
      'enMarguerita'
      'enPortuguesa')
  end
  object Button1: TButton
    Left = 16
    Top = 210
    Width = 105
    Height = 25
    Caption = 'Pedido'
    TabOrder = 3
    OnClick = Button1Click
  end
  object mmRetornoWebService: TMemo
    Left = 312
    Top = 25
    Width = 265
    Height = 217
    Lines.Strings = (
      'mmRetornoWebService')
    TabOrder = 4
  end
  object edtEnderecoBackend: TLabeledEdit
    Left = 16
    Top = 24
    Width = 161
    Height = 21
    EditLabel.Width = 131
    EditLabel.Height = 13
    EditLabel.Caption = 'Endere'#231'o Pizzaria Backend:'
    TabOrder = 5
    Text = 'http://localhost'
  end
  object edtPortaBackend: TLabeledEdit
    Left = 183
    Top = 24
    Width = 114
    Height = 21
    EditLabel.Width = 112
    EditLabel.Height = 13
    EditLabel.Caption = 'Porta Pizzaria Backend:'
    TabOrder = 6
    Text = '8080'
  end
  object btnConsultar: TButton
    Left = 201
    Top = 210
    Width = 105
    Height = 25
    Caption = 'buscar'
    TabOrder = 7
    OnClick = btnConsultarClick
  end
end
