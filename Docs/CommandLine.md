# Command line

**Generate the SP keys**

    keygen.bat -h sp.samltools.com -e urn:msingh.samltools:sp -y 10

The `-h` parameter is the hostname, the domain of the Service Provider and the `-e` parameter is the *EntityID* of the Service Provider.

**Sign a file with a private key**

    xmlsec.exe --sign --privkey-pem sp-key.pem sign1-tmpl.xml > signed.xml

**Validate a file with a public certificate**

    xmlsec.exe --verify --pubkey-cert-pem sp-cert.pem signed.xml

**convert a PEM certificate to a DER certificate**

    openssl x509 -inform pem -in Certificate.pem -outform der -out Certificate.der

**To convert a PEM private key to a DER private key**

    openssl rsa -inform pem -in PrivateKey.pem -outform der -out PrivateKey.der
