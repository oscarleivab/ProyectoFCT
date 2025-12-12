inherited ListadoFramePermisos: TListadoFramePermisos
  inherited Panelfiltros: TPanel
    Height = 0
    ExplicitHeight = 0
    object chkCrearCliente: TCheckBox
      Left = 18
      Top = 3
      Width = 97
      Height = 17
      Caption = 'Crear cliente'
      TabOrder = 0
      OnClick = chkCrearClienteClick
    end
    object chkCrearEmpleado: TCheckBox
      Left = 274
      Top = 3
      Width = 111
      Height = 17
      Caption = 'Crear empleado'
      TabOrder = 1
      OnClick = chkCrearEmpleadoClick
    end
    object chkCrearProveedor: TCheckBox
      Left = 138
      Top = 3
      Width = 111
      Height = 17
      Caption = 'Crear proveedor'
      TabOrder = 2
      OnClick = chkCrearProveedorClick
    end
    object chkEditarCliente: TCheckBox
      Left = 18
      Top = 26
      Width = 97
      Height = 17
      Caption = 'Editar cliente'
      TabOrder = 3
      OnClick = chkEditarClienteClick
    end
    object chkEditarEmpleado: TCheckBox
      Left = 274
      Top = 26
      Width = 111
      Height = 17
      Caption = 'Editar empleado'
      TabOrder = 4
      OnClick = chkEditarEmpleadoClick
    end
    object chkEditarProveedor: TCheckBox
      Left = 138
      Top = 26
      Width = 97
      Height = 17
      Caption = 'Editar proveedor'
      TabOrder = 5
      OnClick = chkEditarProveedorClick
    end
    object chkListarCliente: TCheckBox
      Left = 18
      Top = 49
      Width = 97
      Height = 17
      Caption = 'Listar cliene'
      TabOrder = 6
      OnClick = chkListarClienteClick
    end
    object chkListarEmpleado: TCheckBox
      Left = 274
      Top = 49
      Width = 111
      Height = 17
      Caption = 'Listar empleado'
      TabOrder = 7
      OnClick = chkListarEmpleadoClick
    end
    object chkListarProveedor: TCheckBox
      Left = 138
      Top = 49
      Width = 111
      Height = 17
      Caption = 'Listar proveedor'
      TabOrder = 8
      OnClick = chkListarProveedorClick
    end
  end
  inherited DBGridListado: TDBGrid
    Top = 61
    Height = 605
  end
  inherited Menulateral: TPanel
    Top = 61
    Height = 615
    ExplicitTop = 61
    ExplicitHeight = 615
  end
end
