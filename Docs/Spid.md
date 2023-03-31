# Spid

## Documentazione ufficiale

https://docs.italia.it/italia/spid/spid-regole-tecniche/it/stabile/single-sign-on.html
https://docs.italia.it/italia/spid/spid-regole-tecniche/it/stabile/metadata.html

## Tools

Ambiente Demo SPID:
https://demo.spid.gov.it/

SAML tools:
https://www.samltool.com/online_tools.php

## SP Metadata

* I metadati devono contente il tag <AttributeConsumingService> con l'elenco di tutti gli attributi di cui hanno bisogno
* Devono essere firmati
* Devono avere la sezione <Organization> 

## AuthnRequest

* AuthnContextClassRef deve essere: 
	* https://www.spid.gov.it/SpidL1
	* https://www.spid.gov.it/SpidL2
	* https://www.spid.gov.it/SpidL3

## Todo

* Generate metadata