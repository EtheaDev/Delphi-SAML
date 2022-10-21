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
unit SAML.Core;

interface

uses
  System.Classes, System.SysUtils, System.NetEncoding;

type
  ESAMLError = class(Exception)
  end;

  TSAML = class
  const
    BINDINGS_HTTP_POST = 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST';
    BINDINGS_HTTP_REDIRECT = 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect';
  end;

function Base64EncodeStr(const ABytes: TBytes): string;

implementation

function Base64EncodeStr(const ABytes: TBytes): string;
const
  BASE64_NO_LINE_BREAK = 0;
var
  Base64: TBase64Encoding;
begin
  Base64 := TBase64Encoding.Create(BASE64_NO_LINE_BREAK);
  try
    Result := Base64.EncodeBytesToString(ABytes);
  finally
    Base64.Free;
  end;
end;

end.
