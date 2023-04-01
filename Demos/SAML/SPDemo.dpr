{******************************************************************************}
{                                                                              }
{  Delphi SAML                                                                 }
{  Copyright (c) 2022 Ethea                                                    }
{  Author: Luca Minuti                                                         }
{  https://github.com/EtheaDev/Delphi-SAML                                     }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
program SPDemo;

uses
  Vcl.Forms,
  SAML.Form.Main in 'SAML.Form.Main.pas' {MainForm},
  SAML.XML.Utils in '..\..\Sources\SAML.XML.Utils.pas',
  libexslt in '..\..\Sources\bindings\libexslt.pas',
  libxml2 in '..\..\Sources\bindings\libxml2.pas',
  libxmlsec in '..\..\Sources\bindings\libxmlsec.pas',
  libxslt in '..\..\Sources\bindings\libxslt.pas',
  Vcl.Themes,
  Vcl.Styles,
  SAML.Config in '..\..\Sources\SAML.Config.pas',
  SAML.http.Server in 'SAML.http.Server.pas' {modHttpServer: TDataModule},
  SAML.Metadata in '..\..\Sources\SAML.Metadata.pas',
  SAML.Request in '..\..\Sources\SAML.Request.pas',
  SAML.Core in '..\..\Sources\SAML.Core.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
