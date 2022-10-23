unit SAML.Test.Signature;

interface

uses
  System.Classes,
  System.SysUtils,
  DUnitX.TestFramework,
  SAML.XML.Utils,
  SAML.Test.Consts;

type
  [TestFixture]
  TTestSignature = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure SignXML;
    [Test]
    procedure VerifyXML;
    [Test]
    procedure VerifyWrongXML;
  end;

implementation

procedure TTestSignature.Setup;
begin
end;

procedure TTestSignature.TearDown;
begin
end;

procedure TTestSignature.VerifyWrongXML;
var
  LModifiedXML: string;
  LXMLDocument: IXMLSecDocument;
  LSignatureContext: ISignatureContext;
begin
  LModifiedXML := StringReplace(XMLSigned, 'Hello', 'Ciao', [rfReplaceAll, rfIgnoreCase]);

  LXMLDocument := TXMLSecDocument.Create(TStringStream.Create(LModifiedXML), True);

  LSignatureContext := TSignatureContext.Create;
  LSignatureContext.LoadKey(TStringStream.Create(PublicKey), TKeyDataFormat.CertPem, True);

  Assert.IsFalse(LSignatureContext.Verify(LXMLDocument));
end;

procedure TTestSignature.VerifyXML;
var
  LXMLDocument: IXMLSecDocument;
  LSignatureContext: ISignatureContext;
begin
  LXMLDocument := TXMLSecDocument.Create(TStringStream.Create(XMLSigned), True);

  LSignatureContext := TSignatureContext.Create;
  LSignatureContext.LoadKey(TStringStream.Create(PublicKey), TKeyDataFormat.CertPem, True);

  Assert.IsTrue(LSignatureContext.Verify(LXMLDocument));
end;

procedure TTestSignature.SignXML;
var
  LXMLDocument: IXMLSecDocument;
  LSignatureContext: ISignatureContext;
  LSigatureValueNode: IXMLSecNode;
begin
  LXMLDocument := TXMLSecDocument.Create(TStringStream.Create(XMLSignTemplate), True);

  LSignatureContext := TSignatureContext.Create;
  LSignatureContext.LoadKey(TStringStream.Create(PrivateKey), TKeyDataFormat.Pem, True);
  LSignatureContext.Sign(LXMLDocument);

  if not LXMLDocument.TryFindNode('SignatureValue', 'http://www.w3.org/2000/09/xmldsig#', LSigatureValueNode) then
  begin
    Assert.Fail('"SignatureValue" node not found');
  end;
  Assert.AreEqual(SignatureValue, TrimAll(LSigatureValueNode.Text));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestSignature);

end.
