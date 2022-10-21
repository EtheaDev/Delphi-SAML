# Delphi SAML implementation

`Delphi SAML` is a SAML implementation written on top of [xmlsec](https://www.aleksey.com/xmlsec/). The basic idea behind the code comes from [samltools](https://github.com/monmohan/samltools). 


## How to setup a service provider locally?

* Clone the repo
* Copy all the DLL in the Demos\bin folder (see *installation*)
* Setup a loopback mapping to "sp.samltools.com". On windows:
  * Open `C:\Windows\System32\drivers\etc\hosts`
  * Add `127.0.0.1 sp.samltools.com` 
* Compile Demos\SAML\SPDemo.dpr
* Run it
* Choose `idp-auth0.ini` in Identity Provider settings
* Choose `sp-samltest.ini` in Serivce Provider settings
* Click `Open Browser` and follow the instructions

## Demo

![SPDemo!](./Docs/SPDemo.gif)

## Installation

Download all zip from https://www.zlatkovic.com/pub/libxml/

* libxmlsec.dll: main DLL
    * libxml2.dll: to handle XML
        * iconv.dll: to convert between charsets
    * libxmlsec-mscrypto.dll: if you want to use cryptographics functions from mscrypto (install mscrypto from MS)
    * libxmlsec-openssl.dll: or if you want to use cryptographics functions from openssl
        * libeay32.dll
        * ssleay32.dll
  * zlib1.dll: compression... but I'm not sure who need it
  * libexslt.dll: xsl transformations (optional)
  * libxslt.dll: xsl transformations (optional)


## TODO

* Better metadata support
* Identity provider implementation
* Password protected certificate support
* Basic key format conversion (PEM, DER, ...)
## License

`Delphi SAML` is released under the term of the *Apache License*. Here follows the licenses of all dependencies:

| Library  | License   | Using with proprietary applications/libraries | 
| ---      | ---       | ---- |
| xmlsec-core  | MIT license   | Yes |
| xmlsec-openssl  | OpenSSL License  | Yes |
| xmlsec-mscrypto  | Microsoft licensing: The libraries are part of MS Windows, and are also distributed with Internet Explorer.  | Unknown |
| libxml2 | MIT license | Yes |
| iconv | LGPL | Yes |
| openssl | Apache-2.0 license | Yes |
| zlib1 | Zlib license | Yes |
| libexslt | MIT License | Yes |
| libxslt | MIT License | Yes |

## Resources

SAML documentation:

* http://docs.oasis-open.org/security/saml/v2.0/saml-2.0-os.zip
* https://developer.okta.com/docs/concepts/saml/
* https://shibboleth.atlassian.net/wiki/spaces/CONCEPT/overview
* https://en.wikipedia.org/wiki/SAML_2.0#SAML_Attribute_Query

XML-Sec API:

* https://www.aleksey.com/xmlsec/api/

Resources:

* https://samltest.id/
* https://www.samltool.com/online_tools.php
* https://github.com/monmohan/samltools


## Generate the keys

If you want to sign you request you need a private and a public key. You can generate both with this command:

```
keygen.bat -h sp.samltools.com -e urn:msingh.samltools:sp -y 10
```

See [CommandLine](docs/CommandLine.md) for further detail.

