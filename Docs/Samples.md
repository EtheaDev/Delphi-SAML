# Low level samples

## Sign a file

```pascal
function sign_file(tmpl_file: PAnsiChar; key_file: PAnsiChar): string;
var
  doc: xmlDocPtr;
  node: xmlNodePtr;
  dsigCtx: xmlSecDSigCtxPtr;
  PResult :xmlCharPtr;
  ResLength: Integer;
  //res: Integer;
begin
  doc := nil;
  //node := nil;
  dsigCtx := nil;
  //Result := -1;

  assert(tmpl_file <> nil);
  assert(key_file <> nil);

  try

    xmlSetGenericErrorFunc(nil, Callback);

    XmlCryptInit;

    //res = xmlSecCryptoDLLoadLibrary('libxmlsec-openssl.dll');
//    if xmlSecCryptoDLLoadLibrary('openssl') < 0 then
//    begin
//      raise ESignError.Create('Error: unable to load default xmlsec-crypto library');
//    end;

    // load template
    doc := xmlParseFile(tmpl_file);
    if (doc = nil) or (xmlDocGetRootElement(doc) = nil) then
    begin
      raise ESignError.CreateFmt('Error: unable to parse file "%s"', [tmpl_file]);
    end;

    // find start node */
    node := xmlSecFindNode(xmlDocGetRootElement(doc), xmlSecNodeSignature, xmlSecDSigNs);
    if node = nil then
    begin
      raise ESignError.CreateFmt('Error: start node not found in "%s"', [tmpl_file]);
    end;

    // create signature context, we don't need keys manager in this example */
    dsigCtx := xmlSecDSigCtxCreate(nil);
    if dsigCtx = nil then
    begin
      raise ESignError.Create('Error: failed to create signature context');
    end;

    // load private key, assuming that there is not password */
    dsigCtx.signKey := xmlSecCryptoAppKeyLoad(key_file, xmlSecKeyDataFormatPem, nil, nil, nil);
    if dsigCtx.signKey = nil then
    begin
      raise ESignError.CreateFmt('Error: failed to load private pem key from "%s"', [key_file]);
    end;

    // set key name to the file name, this is just an example! */
    if xmlSecKeySetName(dsigCtx.signKey, PAnsiChar(key_file)) < 0 then
    begin
      raise ESignError.CreateFmt('Error: failed to set key name for key from "%s"', [key_file]);
    end;

    // sign the template */
    if xmlSecDSigCtxSign(dsigCtx, node) < 0 then
    begin
      raise ESignError.Create('Error: signature failed');
    end;

    // print signed document to stdout
    //xmlDocDump(nil, doc); // TODO: nil => stdout
    //xmlSaveFile('output.xml', doc);

    //xmlDocDumpFormatMemoryEnc(doc, @PResult, @ResLength, doc.encoding, 1);
    xmlDocDumpFormatMemoryEnc(doc, @PResult, @ResLength, 'UTF8', 1);

    //OutputDebugStringA(PResult);
    Result := UTF8ToString(PResult);

    // success
    //Result := 0;
  finally
    // cleanup
    if dsigCtx <> nil then
    begin
      xmlSecDSigCtxDestroy(dsigCtx);
    end;

    if doc <> nil then
    begin
      xmlFreeDoc(doc);
    end;
    XmlCryptShutdown;
  end;
end;
```

## Verify a file

```
function verify_file(const xml_file, key_file: PAnsiChar): Boolean;
var
  doc: xmlDocPtr;
  node: xmlNodePtr;
  dsigCtx: xmlSecDSigCtxPtr;
begin
  doc := nil;
  //node := nil;
  dsigCtx := nil;

  assert(xml_file <> nil);
  assert(key_file <> nil);

  try

    xmlSetGenericErrorFunc(nil, Callback);

    XmlCryptInit;


    (* load file *)
    doc := xmlParseFile(xml_file);
    if (doc = nil) or (xmlDocGetRootElement(doc) = nil) then
    begin
      raise ESignError.CreateFmt('Error: unable to parse file "%s"', [xml_file]);
    end;

    (* find start node *)
    node := xmlSecFindNode(xmlDocGetRootElement(doc), xmlSecNodeSignature, xmlSecDSigNs);
    if node = nil then
    begin
      raise ESignError.CreateFmt('Error: start node not found in "%s"', [xml_file]);
    end;

    (* create signature context, we don't need keys manager in this example *)
    dsigCtx := xmlSecDSigCtxCreate(nil);
    if dsigCtx = nil then
    begin
      raise ESignError.Create('Error: failed to create signature context');
    end;

    (* load public key *)
    dsigCtx.signKey := xmlSecCryptoAppKeyLoad(key_file, xmlSecKeyDataFormatCertPem, nil, nil, nil);
    if dsigCtx.signKey = nil then
    begin
      raise ESignError.CreateFmt('Error: failed to load public pem key from "%s"', [key_file]);
    end;

    (* set key name to the file name, this is just an example! *)
    if xmlSecKeySetName(dsigCtx.signKey, key_file) < 0 then
    begin
      raise ESignError.CreateFmt('Error: failed to set key name for key from "%s', [key_file]);
    end;

    (* Verify signature *)
    if xmlSecDSigCtxVerify(dsigCtx, node) < 0 then
    begin
      raise ESignError.Create('Error: signature verify');
    end;

    (* print verification result to stdout *)
    Result := dsigCtx.status = xmlSecDSigStatusSucceeded;

  finally
    (* cleanup *)
    if dsigCtx <> nil then
      xmlSecDSigCtxDestroy(dsigCtx);

    if doc <> nil then
      xmlFreeDoc(doc);

    XmlCryptShutdown;
  end;
end;
```

