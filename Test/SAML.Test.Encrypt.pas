unit SAML.Test.Encrypt;

interface

uses
  System.Classes,
  System.SysUtils,
  DUnitX.TestFramework,
  SAML.XML.Utils,
  SAML.Test.Consts;

type
  [TestFixture]
  TTestEncrypt = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure EncryptXML;
    [Test]
    procedure DecryptXML;
  end;


implementation

{ TTestSignature }

procedure TTestEncrypt.DecryptXML;
var
  LXMLDocument: IXMLSecDocument;
  LEncryptionContext: IEncryptionContext;
  LDataNode: IXMLSecNode;
begin
  LXMLDocument := TXMLSecDocument.Create(TStringStream.Create(XMLEncrypted), True);
  //LXMLDocument.AddIDAttr('Id', 'EncryptedKey', 'http://www.w3.org/2001/04/xmlenc#');

  LEncryptionContext := TEncryptionContext.Create;
  LEncryptionContext.LoadKey(TStringStream.Create(PrivateKey), TKeyDataFormat.Pem, True);
  LEncryptionContext.Decrypt(LXMLDocument);

  if not LXMLDocument.TryFindNode('Data', 'urn:envelope', LDataNode) then
  begin
    Assert.Fail('"Data" node not found');
  end;
  Assert.AreEqual('Hello,World!', TrimAll(LDataNode.Text));
end;

procedure TTestEncrypt.EncryptXML;
var
  LXMLDocument: IXMLSecDocument;
  LEncryptionContext: IEncryptionContext;
begin
  LXMLDocument := TXMLSecDocument.Create(TStringStream.Create(XMLEncTemplate), True);

  LEncryptionContext := TEncryptionContext.Create;
  LEncryptionContext.LoadKey(TStringStream.Create(PublicKey), TKeyDataFormat.CertPem, True);

  Assert.WillRaise(
    procedure
    begin
      LEncryptionContext.Encrypt(LXMLDocument);
    end,
    ESAMLNotImplemented
  );

end;

procedure TTestEncrypt.Setup;
begin

end;

procedure TTestEncrypt.TearDown;
begin

end;

initialization
  TDUnitX.RegisterTestFixture(TTestEncrypt);

end.
