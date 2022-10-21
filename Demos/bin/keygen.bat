@echo off
setlocal

set DAYS=
set YEARS=
set FQDN=
set ENTITYID=
set TEMP_DOMAIN_NAME=
set PARAM=
set PREFIX=
set OUT=%~dp0

:opt_start
set PARAM=%1

if not defined PARAM goto opt_end
if %1==-o goto opt_out
if %1==-n goto opt_prefix
if %1==-h goto opt_fqdn
if %1==-e goto opt_entityid
if %1==-y goto opt_years
if %1==-f goto opt_force
goto usage
:opt_end

if not defined PREFIX set PREFIX=sp

if exist "%OUT%\%PREFIX%-key.pem" goto protect
if exist "%OUT%\%PREFIX%-cert.pem" goto protect

if not defined YEARS set YEARS=10
set /a DAYS=%YEARS%*365

if not defined FQDN goto guess_fqdn

:generate
set PATH=%PATH%;%ProgramFiles%\Shibboleth\SP\lib\
set CNF="%OUT%\%PREFIX%-cert.cnf"
echo # OpenSSL configuration file for creating keypair       >%CNF%
echo [req]                                                   >>%CNF%
echo prompt=no                                               >>%CNF%
echo default_bits=3072                                       >>%CNF%
echo encrypt_key=no                                          >>%CNF%
echo default_md=sha256                                       >>%CNF%
echo distinguished_name=dn                                   >>%CNF%
echo # PrintableStrings only                                 >>%CNF%
echo string_mask=MASK:0002                                   >>%CNF%
echo x509_extensions=ext                                     >>%CNF%
echo [dn]                                                    >>%CNF%
echo CN=%FQDN%                                               >>%CNF%
echo [ext]                                                   >>%CNF%
if defined ENTITYID (echo subjectAltName=DNS:%FQDN%,URI:%ENTITYID% >>%CNF%) else (echo subjectAltName=DNS:%FQDN% >>%CNF%)
echo subjectKeyIdentifier=hash                               >>%CNF%
openssl.exe req -config %CNF% -new -x509 -days %DAYS% -keyout "%OUT%\%PREFIX%-key.pem" -out "%OUT%\%PREFIX%-cert.pem"
openssl x509 -in "%OUT%\%PREFIX%-cert.pem" -out "%OUT%\%PREFIX%-cert.crt"

del %CNF%
exit /b

:protect
echo The files %OUT%\%PREFIX%-key.pem and/or %OUT%\%PREFIX%-cert.pem already exist!
echo Use -f option to force recreation of keypair.
exit /b

:opt_out
set OUT=%2
shift
shift
goto opt_start

:opt_prefix
set PREFIX=%2
shift
shift
goto opt_start

:opt_force
if exist "%OUT%\%PREFIX%-key.pem" del "%OUT%\%PREFIX%-key.pem"
if exist "%OUT%\%PREFIX%-cert.pem" del "%OUT%\%PREFIX%-cert.pem"
shift
goto opt_start

:opt_fqdn
set FQDN=%2
shift
shift
goto opt_start

:opt_entityid
set ENTITYID=%2
shift
shift
goto opt_start

:opt_years
set YEARS=%2
shift
shift
goto opt_start

:usage
echo usage: keygen [-h hostname for cert] [-y years to issue cert] [-e entityID to embed in cert] [-n filename prefix] [-o output dir]
exit /b

:guess_fqdn
for /F "tokens=2 delims=:" %%i in ('"ipconfig /all | findstr /c:"Primary DNS Suffix" /c:"Primary Dns Suffix""') do set TEMP_DOMAIN_NAME=%%i
if defined TEMP_DOMAIN_NAME set FQDN=%TEMP_DOMAIN_NAME: =%
set TEMP_DOMAIN_NAME=
if defined USERDNSDOMAIN set FQDN=%USERDNSDOMAIN%

for /F %%i in ('hostname') do set HOST=%%i
if defined FQDN (set FQDN=%HOST%.%FQDN%) else (set FQDN=%HOST%)

echo >"%FQDN%"
for /F %%i in ('dir /b/l %FQDN%') do set FQDN=%%i
del %FQDN%
goto generate
