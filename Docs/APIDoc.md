# API Documentation

## XML Handling

The challenging part of SAML is the handling of *XML cryptography*. Every XML it's cipher with some cryptographic algorithm. This project uses the standard XmlSec library to handle these functions. In the binding folder, you can find the low-level API translated from C to Pascal. But I recommend using the wrapper in `SAML.XML.Utils` unit.

Every object in this unit has an *interface* wrapper so you can create the objects without the need to destroy it. Furthermore when you pass a stream to an object (e.g. a key to a context) you can delegate the responsibility to destroy the stream to the object itself.

With the following code when the *LSignatureContext* has done its work it automatically destry the *LByteStream*.

```pascal
LSignatureContext.LoadKey(LByteStream, TKeyDataFormat.Der, True);
```

Here you can find an example of how to sign a XML file; for other examples you can check the *XmlSecDemo* project.

**Sign a document**

```pascal
procedure TMainForm.btnSignClick(Sender: TObject);
var
  // Reference to XML document
  LXMLDocument: IXMLSecDocument;
  // The main "context" that holds the keys for signing and cipher
  LSignatureContext: ISignatureContext;
begin
  // The IXMLSecDocument reads the data from a stream and can
  // handle the life cycle of it 
  LXMLDocument := TXMLSecDocument.Create(TFileStream.Create(edtInputXMLName.Text, fmOpenRead), True);
  // Set the ID of the XML to find the XML fragment to sign
  LXMLDocument.AddIDAttr('ID', 'AuthnRequest', 'urn:oasis:names:tc:SAML:2.0:protocol');

  // Create the SignatureContext
  LSignatureContext := TSignatureContext.Create;
  // Add a private to the context
  LSignatureContext.LoadKey(TFileStream.Create(edtPrivateKeyName.Text, fmOpenRead), TKeyDataFormat(edtPrivateKeyFormat.ItemIndex), True);
  // Sign the document
  LSignatureContext.Sign(LXMLDocument);

  // Retrieve the signed XML as string
  memOutput.Text := LXMLDocument.ToXML;
  // And save the signed XML to a file
  LXMLDocument.SaveToFile(edtOutputXMLName.Text);
end;
```

## SAML Message

The unit `SAML.Request` contains the classes to handle `requests` and `reponses`. If you need to create a new SAML request you can use the helper class `TSAMLRequestBuilder` that use a fluent interface:

```pascal
function BuildAuthnRequest(const AIssuer: string): string;
begin
  Result := TSAMLAuthnRequest.New
    .SetID('SAML_' + IntToStr(Random(1000000000)))
    .SetIssuer(AIssuer)
    .SetSigned(True)
    .SetProtocolBinding(TSAML.BINDINGS_HTTP_POST)
    .AsXML;
end;
```

Then you can sign the request with the `SAML.XML.Utils` unit.

## SAML Metadata

To securely interoperate SAML uses XML metadata that describes both the Service Provider and Identity Provider. `Delphi SAML` provides a class to read and create these files. You can use a builder with a fluent interface like the example below:

```pascal
LMetadata := TSAMLMetadata.New
    .SetEntityID('urn:test.samltest:sp')
    .SetProtocolBinding(TSAML.BINDINGS_HTTP_POST)
    .SetCacheDuration('PT604800S')
    ...
    .AsXML;
```