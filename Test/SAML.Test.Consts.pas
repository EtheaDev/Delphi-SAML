unit SAML.Test.Consts;

interface

uses
  System.SysUtils;

const
  XMLSignTemplate =
    ' <Envelope xmlns="urn:envelope">' + #13 +
    '   <Data>' + #13 +
    ' 	Hello, World!' + #13 +
    '   </Data>' + #13 +
    '   <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">' + #13 +
    '     <SignedInfo>' + #13 +
    '       <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />' + #13 +
    '       <SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />' + #13 +
    '       <Reference URI="">' + #13 +
    '         <Transforms>' + #13 +
    '           <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />' + #13 +
    '         </Transforms>' + #13 +
    '         <DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />' + #13 +
    '         <DigestValue></DigestValue>' + #13 +
    '       </Reference>' + #13 +
    '     </SignedInfo>' + #13 +
    '     <SignatureValue/>' + #13 +
    '     <KeyInfo>' + #13 +
    ' 	<KeyName/>' + #13 +
    '     </KeyInfo>' + #13 +
    '   </Signature>' + #13 +
    ' </Envelope>';

  XMLSigned =
    '<?xml version="1.0" encoding="UTF8"?>' + #13#10 +
    '<Envelope xmlns="urn:envelope">' + #13#10 +
    '   <Data>' + #13#10 +
    ' 	Hello, World!' + #13#10 +
    '   </Data>' + #13#10 +
    '   <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">' + #13#10 +
    '     <SignedInfo>' + #13#10 +
    '       <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>' + #13#10 +
    '       <SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>' + #13#10 +
    '       <Reference URI="">' + #13#10 +
    '         <Transforms>' + #13#10 +
    '           <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>' + #13#10 +
    '         </Transforms>' + #13#10 +
    '         <DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>' + #13#10 +
    '         <DigestValue>4WlH37+hQdyyonZrHkx329A8wWY=</DigestValue>' + #13#10 +
    '       </Reference>' + #13#10 +
    '     </SignedInfo>' + #13#10 +
    '     <SignatureValue>vfY9SnfUw6JOIIsEsKzUYF0m7kKPfSp8yTMwfb0jYhHACpo1j+ZdHk0/dV8GRN/U' + #13#10 +
    '1x1yWCat0wyzLOkQnPUeUYUeLejgFrmqQLnLOZhEFy/OoWL0vZVw0YVUaBkPrwPe' + #13#10 +
    'UzeA2uUa6dXObZTb25+rntRsgdo2VGk5YSU8yLRxuWhIibYR4qVl9mX0EVUAwp38' + #13#10 +
    'zrj+khdORPFbICavOV5Lew3xbIOooZrYm8Af2lbEk/7pBEFm4NDHtVLNniN/HYSp' + #13#10 +
    'YdShHaMSA2aC4TqFhmcQtN0AkDPUTzML9x5XIZl8bTFXYeKBYj2BwGafH1VoYLPz' + #13#10 +
    'Z6IHl6Hg6OwTSN1puJA7UX55bKI/lUwBSxwklrplmzmnaGa9LEvTaHlZ/LOR2IEK' + #13#10 +
    '5Un+O4UHQfbDVvsIKhbU6dJHaiigyvZuBFjv8WiaOnncwAyGg91uBqq4tT8aDdQc' + #13#10 +
    'XoruuXAlR0Zskw3/qvoJ1FbtC7pN1mSaSoYPDznaJN7IjK2/jIUrcYfMj01Qq3rj</SignatureValue>' + #13#10 +
    '     <KeyInfo>' + #13#10 +
    ' 	<KeyName/>' + #13#10 +
    '     </KeyInfo>' + #13#10 +
    '   </Signature>' + #13#10 +
    ' </Envelope>' + #13#10;

  XMLEncTemplate =
    '<?xml version="1.0"?>' + #13#10 +
    '<EncryptedData xmlns="http://www.w3.org/2001/04/xmlenc#">' + #13#10 +
    '    <EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#tripledes-cbc"/>' + #13#10 +
    '    <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">' + #13#10 +
    '	<KeyName/>' + #13#10 +
    '    </KeyInfo>   ' + #13#10 +
    '    <CipherData>' + #13#10 +
    '	<CipherValue></CipherValue>' + #13#10 +
    '    </CipherData>' + #13#10 +
    '</EncryptedData>' + #13#10;

  XMLEncrypted =
    '<?xml version="1.0"?>' + #13#10 +
    '<EncryptedData xmlns="http://www.w3.org/2001/04/xmlenc#" Type="http://www.w3.org/2001/04/xmlenc#Element">' + #13#10 +
    ' <EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#tripledes-cbc"/>' + #13#10 +
    ' <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">' + #13#10 +
    '  <EncryptedKey xmlns="http://www.w3.org/2001/04/xmlenc#">' + #13#10 +
    '   <EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#rsa-1_5"/>' + #13#10 +
    '   <KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#">' + #13#10 +
    '    <KeyName/>' + #13#10 +
    '   </KeyInfo>' + #13#10 +
    '   <CipherData>' + #13#10 +
    '    <CipherValue>dIz2g2EtXTkuCQIAyrHAS3vFRIn1w+v3gv7gIcT5Hi7dFRH2odD44tkmN8K+wFJq' + #13#10 +
    'xSiOdCMNGqkFqC5JQHB+z6tjmuWoFIXfiJBDPTDzbxTZqKqOmJqU/ZfbEDkYCBk/' + #13#10 +
    'G6+MtvbL7seV3CP9GsnUcIEuu9kuNdnFD9H3Mmr9QPQzGHqhgbjKoDZG4lW8vG4y' + #13#10 +
    'x+5/DXBLkNiV3bFVSAnxUOxw3Kzqh/QTNla2PAFsUEP8he9jabxOPQCg69jX91oQ' + #13#10 +
    '3++k2I5lwYxC7cRm4SOLHeR7z1+XDPU12UdFvdaVUd6Yyb9vE0/KypOBUsRXVhUN' + #13#10 +
    'BsxRLx4AupP5dbrT7LmXMbuD/nGaCmHEBk5a4KYkdmFsf26ZGQBVDuA828IR5Hhe' + #13#10 +
    '61kzil1+rpKmjWTavnBTIM8wPJloNEBZRwZdbFKM1YEtjkfPfjGyohYDHmZ0Bnv3' + #13#10 +
    '1SRaN+DxQ+ppamlR8i+v5Q4WcHhttSNJcLTuTNv2I6zMPSTCMZ1M3N1gvrx/c6Ze</CipherValue>' + #13#10 +
    '   </CipherData>' + #13#10 +
    '  </EncryptedKey>' + #13#10 +
    ' </KeyInfo>' + #13#10 +
    ' <CipherData>' + #13#10 +
    '  <CipherValue>sYyVnSCN/JPoh11zNcWJS/YdUUelNjqCedORuz3ewHUZfhNKP6VWe/4QRfTjZKKb' + #13#10 +
    'VwAsq/qtP/qf73/9tgCcQ3ls92UI5IiK63UuMGAtaNXoXd+YeNTY2Q==</CipherValue>' + #13#10 +
    ' </CipherData>' + #13#10 +
    '</EncryptedData>' + #13#10;

  PrivateKey =
    '-----BEGIN RSA PRIVATE KEY-----' + #13#10 +
    'MIIG5AIBAAKCAYEAv3lOMK4NNihmzXuKWKDVpkRMDI1LaZrQDs4zH//C5S/WxIRO' + #13#10 +
    'jp1lsafbcgjFlLHHZKTk9tm+DpxoN+D7FbXQLiZ59Bp1Jwur2g8YzuKAKd6fX35O' + #13#10 +
    'V4CpYkk+7avujedgWmrsYa6Nxd+pcGzKBqr5q2fQIkfqLb6OZ5DEjZo/ipHCSq1/' + #13#10 +
    'GZpPO/5+f6YYd7KsWSj/JU1Unlw4V/LE/ISKmoDrPvAKCYbkcCY0BCNeoFl1G6KX' + #13#10 +
    '75Ny00fgI4lwTUHgyUhwX6gvHmstmQOqZP59RacRpQHIRI2U1bQtnybiBXH509DU' + #13#10 +
    '5T2z+sJU+LSGbnASZO0/PD8nIHJ7RHamTni6UkyfZRiZs6/DpYVNeZc+NGwjA1qi' + #13#10 +
    'xf6Rgjw0YaAaX/7K8k52o6PGvWAbmttJw/d0F1F0jtd+jLXMDY1pX69LoHGZsBzm' + #13#10 +
    'HnRe1bnzrVHa2oJtQTwNCByVIqdauSErXijGB7sGBtyX94pD+r9vf+rmGQet85Wb' + #13#10 +
    'DYhbCmGY+LCrQ6elAgMBAAECggGBAJtgluDN/Q6bzoCk5elx6q4X8halejLiXEAH' + #13#10 +
    'eFlZNRDCt2eVbiIw+9skueFZ2OwHMCUt4lem7qHwrmnZ+ibt+VfaBVDfP35F7Fjx' + #13#10 +
    's1H/X72aWH4ngu9jCxElGxnHUbh5sCjvZ48FFSsjit4eifrLN/uuLKoE7bXdUrYc' + #13#10 +
    'NkQqjbGnAqGTFPbzz6SBqqlvYZ+QsGdR62qbzDUN5PMJoGzCKa+jOkNCiwKcIjgX' + #13#10 +
    '6FILWbiJn4yjbuQNJTrqsqpj12v6LkKf8AWtaOR2Rt11UsIKygvMTAaoXTtIQoES' + #13#10 +
    'ZMK+Vde4JU3MGfi/epzH9Ds1U+UncPNOHIGjWkrM13Lb8KHJ8dWkzsrm9YNhvabS' + #13#10 +
    'flkmVgJ3M+2wuG3K0uZ2INO+FTlVOyxUSjdKsfZLq62Vb68cyOhEPkPX51nQkzPb' + #13#10 +
    'l/v23e3W1H0auB5StiGzdgcEBXEQWCFm7Zm8Q39keGt9u3yUJ7LkBpngS386b02f' + #13#10 +
    'GFtNR7oOEdmyYeraQolJzGw9GOQrQQKBwQD+UPkJWkMcLwtf4waGp8b7aXQHUSl7' + #13#10 +
    '+1kurzeKJy/mBqgAGKj/eKWd+MNWzbp+IOYkByKbPXUET/7bM/vyX7HyARej9kC1' + #13#10 +
    'LX4t2jbo5+nzvsfgvR8LuGjwMAwQvhPcwQ+kM54Azhsz2CaEJORNZBKt0gBoU15u' + #13#10 +
    'vVDOQndn9oLflKteHCeX1+a2BMO9sI5aRyLb+GyPeY7dfQjzJH8txZgWXhgQH1uB' + #13#10 +
    'dHnZu7OqezjudlJwynHYF7FBAlfl8eXCFqkCgcEAwL3TBRnHEb+eALrSED1By/Ax' + #13#10 +
    'ktkB44e4lGfLzZGHDznjWB39uIib+CtoC+QMK3thiYDEFnNxXY52+5k8nBGLYvzT' + #13#10 +
    'KqaYmagcgpg4/AuhWCcBQBJe0GRACSRfpQ9OxLvMh83QwNkmLMOWz96LuDF4eV4m' + #13#10 +
    'd5svz5rIkl9nbE31wfdseh03SS9XZgwB+RMBP6IiLIGLf+9agsfBf6OzrXUm/xo+' + #13#10 +
    'WjbGQmV46aLm+0EL35dbEbXC5K9vsBu/s36tUPKdAoHAEI3gyBUSDUGasfErOZSu' + #13#10 +
    'RStGHDvSQXnJAlrxeJK4cXa5dNgmGAsYbMIGpR3bJ96oXGwCeqxzc4ZphodJvSsx' + #13#10 +
    'gBlGGqwq5iBB+GYd8Oc3uWAPzrdA0Bh+7DOUdXqJ/HKsu/mILXE9IBDP4QYtvkPn' + #13#10 +
    'W10yHZhfq0GzgtmcwC2xszAQP54BjcbGA88nlq9pdMLwp/TxzB0TiaNb88fKZ4ZX' + #13#10 +
    'Mg2J73K7GCAm1l97gHto50zYbPMgmfpg1WR7qEIovIuRAoHAagxHvge340kWC3q/' + #13#10 +
    'N9YsjKRE8nJaOrGjWmxd02ad9D+6mfIudskbYAmp/tjj5UzGltx1h5DPMFXBm59t' + #13#10 +
    'nMV+duF64n21et3niedteyh/Bry3UGSLLIfsP9t2kKACi/Z0i8gvctxHx9t58DeX' + #13#10 +
    'kqoNimHGMor9XHHip768bffbH3Ueh3XpxGe649f5gez2A+gWe3xvn923ZDu6eJs+' + #13#10 +
    'slLCORxccFCw9zlTtOE/y8C3YrepkO38JM1uW2x5Jq6td9t1AoHBAIES+XoxMkzl' + #13#10 +
    'MUVKr403PRzdy86bqNZi2e5EQa6uu0mw5Utdx2zT9Z+q5xv1XvwwGFJsKU6IUf4t' + #13#10 +
    '/tQLkmuiNZ4n0C5vFeSXkYjEZT5r45m6kn9YLPCgrtuvSs+0miyzzm/8rRRWpGoP' + #13#10 +
    'NXPdtUjVs8nX3QXl3vpZO4YQtvo2wYcCZmvXGqByp8HwpebJDcCgssCynS4PzlR+' + #13#10 +
    'wbJliOLtF7azoZJQ02HWqRukrzn/rcowrza+/XPo4HGnxfSKzitHOQ==' + #13#10 +
    '-----END RSA PRIVATE KEY-----' + #13#10;

  PublicKey =
    '-----BEGIN CERTIFICATE-----' + #13#10 +
    'MIIEDzCCAnegAwIBAgIJAPg7PTQAntDoMA0GCSqGSIb3DQEBCwUAMBsxGTAXBgNV' + #13#10 +
    'BAMTEHNwLmx1Y2FtaW51dGkuaXQwHhcNMjIwOTIxMDkwMDU4WhcNMzIwOTE4MDkw' + #13#10 +
    'MDU4WjAbMRkwFwYDVQQDExBzcC5sdWNhbWludXRpLml0MIIBojANBgkqhkiG9w0B' + #13#10 +
    'AQEFAAOCAY8AMIIBigKCAYEAv3lOMK4NNihmzXuKWKDVpkRMDI1LaZrQDs4zH//C' + #13#10 +
    '5S/WxIROjp1lsafbcgjFlLHHZKTk9tm+DpxoN+D7FbXQLiZ59Bp1Jwur2g8YzuKA' + #13#10 +
    'Kd6fX35OV4CpYkk+7avujedgWmrsYa6Nxd+pcGzKBqr5q2fQIkfqLb6OZ5DEjZo/' + #13#10 +
    'ipHCSq1/GZpPO/5+f6YYd7KsWSj/JU1Unlw4V/LE/ISKmoDrPvAKCYbkcCY0BCNe' + #13#10 +
    'oFl1G6KX75Ny00fgI4lwTUHgyUhwX6gvHmstmQOqZP59RacRpQHIRI2U1bQtnybi' + #13#10 +
    'BXH509DU5T2z+sJU+LSGbnASZO0/PD8nIHJ7RHamTni6UkyfZRiZs6/DpYVNeZc+' + #13#10 +
    'NGwjA1qixf6Rgjw0YaAaX/7K8k52o6PGvWAbmttJw/d0F1F0jtd+jLXMDY1pX69L' + #13#10 +
    'oHGZsBzmHnRe1bnzrVHa2oJtQTwNCByVIqdauSErXijGB7sGBtyX94pD+r9vf+rm' + #13#10 +
    'GQet85WbDYhbCmGY+LCrQ6elAgMBAAGjVjBUMDMGA1UdEQQsMCqCEHNwLmx1Y2Ft' + #13#10 +
    'aW51dGkuaXSGFnVybjp0ZXN0Lmx1Y2FtaW51dGk6c3AwHQYDVR0OBBYEFNSSIqaE' + #13#10 +
    '6eQLZ62EpTadnAOftzj7MA0GCSqGSIb3DQEBCwUAA4IBgQCTa9PMwXIx3C0nl/Bl' + #13#10 +
    's2NPHkHZ7DNp1dzM7fa/vbdDbgMp3emgTRRWHaKmNNQxyv4hosDbRjbMhXxcr3o4' + #13#10 +
    'SWV2BkWC3Ddiyij2YC5g8YoCJq+F9oFXZctyLJPDix8fRQU8PH4R7Hs1bYfqOXi1' + #13#10 +
    '0h4VcjkxMo8Qob+8g3tcxJsQ02SY0BG+scVtGGAvPpbV8IzI3zU23im1nHXVn5p0' + #13#10 +
    'hO08g8+58FUoZLXWORa3OHTldykkDdQPOh24pMMjTuIco2ez9S94EeZ+anDp3lIK' + #13#10 +
    '21g610BwAhErmZ53EyRoXZce0VSFHxvfm7VRsjDceVoH4qTJtH53ldWifAl7swkr' + #13#10 +
    'wCBPm9jopHwr1DSavxG4poj/3x2gyIrWxPBCvJ+S0uFwEmf42heNgpG5kIGCh++C' + #13#10 +
    'r5ftKw+uMR/dZfLWh8ywa6KzZT9g0o2sWESKxEpwz1pvvO/ZDELbjxwQaa0motfN' + #13#10 +
    'S4XYwZtd+61Q3C6WqjSdo4dRwGKYA0I81pwaTRLlicEpMXI=' + #13#10 +
    '-----END CERTIFICATE-----' + #13#10;

const
  SignatureValue =
    'vfY9SnfUw6JOIIsEsKzUYF0m7kKPfSp8yTMwfb0jYhHACpo1j+ZdHk0/dV8GRN/U' +
    '1x1yWCat0wyzLOkQnPUeUYUeLejgFrmqQLnLOZhEFy/OoWL0vZVw0YVUaBkPrwPe' +
    'UzeA2uUa6dXObZTb25+rntRsgdo2VGk5YSU8yLRxuWhIibYR4qVl9mX0EVUAwp38' +
    'zrj+khdORPFbICavOV5Lew3xbIOooZrYm8Af2lbEk/7pBEFm4NDHtVLNniN/HYSp' +
    'YdShHaMSA2aC4TqFhmcQtN0AkDPUTzML9x5XIZl8bTFXYeKBYj2BwGafH1VoYLPz' +
    'Z6IHl6Hg6OwTSN1puJA7UX55bKI/lUwBSxwklrplmzmnaGa9LEvTaHlZ/LOR2IEK' +
    '5Un+O4UHQfbDVvsIKhbU6dJHaiigyvZuBFjv8WiaOnncwAyGg91uBqq4tT8aDdQc' +
    'XoruuXAlR0Zskw3/qvoJ1FbtC7pN1mSaSoYPDznaJN7IjK2/jIUrcYfMj01Qq3rj';

function TrimAll(const AText: string): string;

implementation

function TrimAll(const AText: string): string;
begin
  Result := StringReplace(AText, ' ', '', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
  Result := StringReplace(Result, #9, '', [rfReplaceAll]);
end;

end.
