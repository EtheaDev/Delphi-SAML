object modHttpServer: TmodHttpServer
  Height = 244
  Width = 334
  object SPServer: TIdHTTPServer
    Bindings = <>
    DefaultPort = 4567
    OnCommandGet = SPServerCommandGet
    Left = 144
    Top = 80
  end
end
