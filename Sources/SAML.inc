{******************************************************************************}
{                                                                              }
{  Delphi SAML                                                                 }
{  Copyright (c) 2022-2023 Ethea S.r.l.                                        }
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
{                          R E A D M E                                         }
{                                                                              }
{ In this file you can change some settings used for DLL binding.              }
{ You can use the default if you download 1.2.18 32bit version from:           }
{ https://www.zlatkovic.com/pub/libxml/                                        }
{ Or the 64bit 1.3.3 version from:                                             }
{ https://www.aleksey.com/xmlsec/download/win64/                               }
{                                                                              }
{******************************************************************************}

// For the NON win32 target use xmlsec 1.3
{$IFNDEF WIN32}
  {$DEFINE USE_XMLSEC1_3}
{$ENDIF}

{$DEFINE USE_VS_LIBS}

// For old release in win32 use 32bit time_t
{$IFNDEF USE_XMLSEC1_3}
  {$IFDEF WIN32}
    // for MinGW runtime
    {$DEFINE _USE_32BIT_TIME_T}
  {$ENDIF}
{$ENDIF}


