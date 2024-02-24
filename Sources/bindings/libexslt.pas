{This file generated automatically from libexslt-api.xml}
{For libexslt version: 0.8.13}
Unit libexslt;

interface

{$ALIGN 8}
{$MINENUMSIZE 4}

uses libxml2, libxslt;

const
{$IFDEF WIN32}
  LIBEXSLT_SO = 'libexslt.dll';
{$ENDIF}
{$IFDEF WIN64}
  LIBEXSLT_SO = 'libexslt-0.dll';
{$ENDIF}
{$IFDEF LINUX}
  LIBEXSLT_SO = 'libexslt.so';
{$ENDIF}

//type


  procedure exsltCommonRegister (); cdecl; external LIBEXSLT_SO;
  procedure exsltCryptoRegister (); cdecl; external LIBEXSLT_SO;
  procedure exsltDateRegister (); cdecl; external LIBEXSLT_SO;
  procedure exsltDynRegister (); cdecl; external LIBEXSLT_SO;
  procedure exsltFuncRegister (); cdecl; external LIBEXSLT_SO;
  procedure exsltMathRegister (); cdecl; external LIBEXSLT_SO;
  procedure exsltRegisterAll (); cdecl; external LIBEXSLT_SO;
  procedure exsltSaxonRegister (); cdecl; external LIBEXSLT_SO;
  procedure exsltSetsRegister (); cdecl; external LIBEXSLT_SO;
  procedure exsltStrRegister (); cdecl; external LIBEXSLT_SO;
  function exsltLibexsltVersion(): Longint; cdecl;
  function exsltLibraryVersion(): PChar; cdecl;
  function exsltLibxmlVersion(): Longint; cdecl;
  function exsltLibxsltVersion(): Longint; cdecl;

implementation
uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils;

var
  libHandle: THandle;

// Utility function to make sure procedure entry points are not null

procedure CheckForNil(ptr: Pointer; name:string);
begin
  if not Assigned(ptr) then
    raise Exception.Create('"' + name + '" could not be loaded from the dynamic library ' + LIBEXSLT_SO);
end;

var
   pexsltLibexsltVersion: PInteger;

function exsltLibexsltVersion: Longint;
begin
  CheckForNil(pexsltLibexsltVersion, 'exsltLibexsltVersion');
  Result := pexsltLibexsltVersion^;
end;

var
   pexsltLibraryVersion: PPChar;

function exsltLibraryVersion: PChar;
begin
  CheckForNil(pexsltLibraryVersion, 'exsltLibraryVersion');
  Result := pexsltLibraryVersion^;
end;

var
   pexsltLibxmlVersion: PInteger;

function exsltLibxmlVersion: Longint;
begin
  CheckForNil(pexsltLibxmlVersion, 'exsltLibxmlVersion');
  Result := pexsltLibxmlVersion^;
end;

var
   pexsltLibxsltVersion: PInteger;

function exsltLibxsltVersion: Longint;
begin
  CheckForNil(pexsltLibxsltVersion, 'exsltLibxsltVersion');
  Result := pexsltLibxsltVersion^;
end;



initialization
  // The Delphi 'external' directive can be used for functions and procedures,
  // but here we need to obtain the addresses of POINTERS to functions. We can
  // get to these addresses (and also those of other data values exported from
  // the DLL) by using GetProcAddress.
  libHandle := LoadLibrary(LIBEXSLT_SO);
  if libHandle <> 0 then 
  begin
    pexsltLibexsltVersion := PInteger(GetProcAddress(libHandle, 'exsltLibexsltVersion'));
    pexsltLibraryVersion := PPChar(GetProcAddress(libHandle, 'exsltLibraryVersion'));
    pexsltLibxmlVersion := PInteger(GetProcAddress(libHandle, 'exsltLibxmlVersion'));
    pexsltLibxsltVersion := PInteger(GetProcAddress(libHandle, 'exsltLibxsltVersion'));

    FreeLibrary(libHandle);
  end;

end.
