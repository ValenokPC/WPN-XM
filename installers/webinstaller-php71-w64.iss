;
;          _\|/_
;          (o o)
; +-----oOO-{_}-OOo------------------------------------------------------+
; |                                                                      |
; |  WPN-XM Server Stack - Inno Setup Script File                        |
; |  --------------------------------------------                        |
; |                                                                      |
; |  WPN-XM is an open-source web server solution stack for              |
; |  professional PHP development on the Windows platform.               |
; |                                                                      |
; |  Author:   Jens-Andre Koch <jakoch@web.de>                           |
; |  Website:  http://wpn-xm.org/                                        |
; |  License:  MIT                                                       |
; |                                                                      |
; |  For the full copyright and license information, please view         |
; |  the LICENSE file that was distributed with this source code.        |
; |                                                                      |
; |  Note for developers                                                 |
; |  -------------------                                                 |
; |  A good resource for developing and understanding                    |
; |  Inno Setup Script files is the official "Inno Setup Help".          |
; |  Website:  http://jrsoftware.org/ishelp/index.php                    |
; |                                                                      |
; +---------------------------------------------------------------------<3

; Uncomment the line below to be able to compile the script locally from the IDE.
;#define COMPILE_FROM_IDE

; debug mode toggle
#define DEBUG                "false"

; the -STACK_VERSION- token is replaced during the build process
#ifdef COMPILE_FROM_IDE
#define APP_VERSION          "LocalSnapshot"
#else
#define APP_VERSION          "@STACK_VERSION@"
#endif

#define APP_NAME             "WPN-XM Server Stack"
#define APP_PUBLISHER        "Jens-Andre Koch"
#define APP_URL              "http://wpn-xm.org/"
#define APP_SUPPORT_URL      "https://github.com/WPN-XM/WPN-XM/issues/new/"
#define COPYRIGHT_YEAR        GetDateTimeString('yyyy', '', '');
#define CODESIGN_INSTALLER   "false"

#define INSTALLER_TYPE       "Webinstaller"
#define PHP_VERSION          "php71"
#define BITSIZE              "w64"

#define SOURCE_ROOT          AddBackslash(SourcePath);
#define INSTALLER_FOLDER     LowerCase(INSTALLER_TYPE);


; include Inno-Download-Plugin download functionality
#include SOURCE_ROOT + "..\bin\innosetup-download-plugin\idp.iss"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{8E0B8E63-FF85-4B78-9C7F-109F905E1D3B}}
AppName={#APP_NAME}
AppVerName={#APP_NAME} {#APP_VERSION}
AppVersion={#APP_VERSION}
AppPublisher={#APP_PUBLISHER}
AppCopyright=© {#APP_PUBLISHER}
AppPublisherURL={#APP_URL}
AppSupportURL={#APP_SUPPORT_URL}
AppUpdatesURL={#APP_URL}
; default installation folder is "c:\server". users might change this via dialog.
DefaultDirName={sd}\server
DefaultGroupName={#APP_NAME}
OutputBaseFilename=WPNXM-{#APP_VERSION}-{#INSTALLER_TYPE}-Setup-{#PHP_VERSION}-{#BITSIZE}
Compression=lzma2/ultra
LZMAUseSeparateProcess=yes
LZMANumBlockThreads=2
InternalCompressLevel=max
SolidCompression=true
CloseApplications=no
; disable wizard pages: Languages, Ready, Select Start Menu Folder
ShowLanguageDialog=no
DisableReadyPage=yes
DisableProgramGroupPage=yes
ShowComponentSizes=no
BackColor=clBlack
PrivilegesRequired=none
; create a log file, see [code] procedure CurStepChanged
SetupLogging=yes
#ifndef COMPILE_FROM_IDE
VersionInfoVersion={#APP_VERSION}
#endif
VersionInfoCompany={#APP_PUBLISHER}
VersionInfoDescription={#APP_NAME} {#APP_VERSION}
VersionInfoTextVersion={#APP_VERSION}
VersionInfoCopyright=Copyright (C) 2011 - {#COPYRIGHT_YEAR} {#APP_PUBLISHER}, All Rights Reserved.
SetupIconFile={#SOURCE_ROOT}..\bin\icons\Webinstaller-Setup.ico
WizardImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\banner-left-164x314-web.bmp
WizardSmallImageFile={#SOURCE_ROOT}..\bin\icons\innosetup-wizard-images\icon-topright-55x55-stamp.bmp
; Tell Windows Explorer to reload the environment, because we modify the environment variable PATH
ChangesEnvironment=yes
; Portable Mode
; a) do no create registry keys for uninstallation
CreateUninstallRegKey=not IsTaskSelected('portablemode')
; b) do not include uninstaller
Uninstallable=not IsTaskSelected('portablemode')
; code-sign the installer
#if "True" == CODESIGN_INSTALLER
SignTool=__SIGNTOOL__
SignedUnInstaller=yes
#endif

; include the sections [Languages], [Messages], [CustomMessages]
#include "includes\languages.iss"

[CustomMessages]
; overload "RetryNext" message of "Inno-Download-Plugin"
IDP_RetryNext="Click ''OK'' to close. Then click ''Retry'' to try downloading the file again. Click ''Next'' to skip this file and continue installing anyway. Please report this issue, if it's not a client-side connectivity problem."

[Types]
Name: full; Description: Full installation
Name: serverstack; Description: Server Stack with Administration Tools
Name: debug; Description: Server Stack with Debugtools
Name: custom; Description: Custom installation; Flags: iscustom

[Components]
; The base component "serverstack" consists of PHP + MariaDB + Nginx. These three components are always installed.
Name: serverstack; Description: Base of the WPN-XM Server Stack (Nginx & PHP & MariaDb); ExtraDiskSpaceRequired: 197000000; Types: full serverstack debug custom; Flags: fixed
Name: adminer; Description: Adminer - Database management in single PHP file; ExtraDiskSpaceRequired: 355000; Types: full
Name: assettools; Description: Google Closure Compiler and yuiCompressor; ExtraDiskSpaceRequired: 1000000; Types: full
Name: benchmark; Description: WPN-XM Benchmark Tools; ExtraDiskSpaceRequired: 100000; Types: full debug
Name: composer; Description: Composer - Dependency Manager for PHP; ExtraDiskSpaceRequired: 486000; Types: full serverstack debug
Name: conemu; Description: Conemu - Advanced console emulator with multiple tabs; ExtraDiskSpaceRequired: 8700000; Types: full serverstack
Name: git; Description: Git Version Control (Msysgit & Go Git Service); ExtraDiskSpaceRequired: 24000000; Types: full
Name: heidisql; Description: HeidiSQL - Database management tool; ExtraDiskSpaceRequired: 4400000; Types: full
Name: imagick; Description: ImageMagick - create, edit, compose or convert bitmap images; ExtraDiskSpaceRequired: 6030000; Types: full
Name: memadmin; Description: memadmin - memcached administration tool; ExtraDiskSpaceRequired: 630000; Types: full
Name: memcached; Description: Memcached - distributed memory caching; ExtraDiskSpaceRequired: 240000; Types: full
Name: mongodb; Description: MongoDb - scalable, high-performance, open source NoSQL database; ExtraDiskSpaceRequired: 620000; Types: full
Name: node; Description: NodeJS + NodeNPM - V8 for fast, scalable network applications; ExtraDiskSpaceRequired: 10000000; Types: full
Name: openssl; Description: OpenSSL - transport protocol security layer (SSL/TLS); ExtraDiskSpaceRequired: 1000000; Types: full
Name: osquery; Description: OsQuery - allows you to easily ask questions about your infrastructure; ExtraDiskSpaceRequired: 16000000; Types: full
Name: phpcsfixer; Description: phpcsfixer - PHP Coding Standards Fixer; ExtraDiskSpaceRequired: 1200000; Types: full
Name: phpextensions; Description: Additional PHP Extensions; ExtraDiskSpaceRequired: 31040000; Types: full
Name: phpmemcachedadmin; Description: phpMemcachedAdmin - memcached administration tool; ExtraDiskSpaceRequired: 130000; Types: full
Name: phpmyadmin; Description: phpMyAdmin - MySQL database administration webinterface; ExtraDiskSpaceRequired: 13020000; Types: full
Name: pickle; Description: Pickle - PHP Extension Installer; ExtraDiskSpaceRequired: 486000; Types: full serverstack debug
Name: postgresql; Description: PostgreSQL - object-relational database management system; ExtraDiskSpaceRequired: 33430000; Types: full
Name: rclone; Description: RClone - rsync for cloud storage; ExtraDiskSpaceRequired: 4700000; Types: full 
Name: redis; Description: Rediska; ExtraDiskSpaceRequired: 2000000; Types: full
Name: robo3t; Description: Robo3T (formerly Robomongo) - MongoDB administration tool; ExtraDiskSpaceRequired: 19000000; Types: full
Name: sendmail; Description: Fake Sendmail - sendmail emulator; ExtraDiskSpaceRequired: 1230000; Types: full
Name: servercontrolpanel; Description: WPN-XM - Server Control Panel (Tray App); ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: varnish; Description: Varnish Cache; ExtraDiskSpaceRequired: 11440000; Types: full
Name: webgrind; Description: Webgrind - Xdebug profiling web frontend; ExtraDiskSpaceRequired: 80000; Types: full debug
Name: webinterface; Description: WPN-XM - Webinterface; ExtraDiskSpaceRequired: 500000; Types: full serverstack debug
Name: xdebug; Description: Xdebug - Debugger and Profiler Tool for PHP; ExtraDiskSpaceRequired: 300000; Types: full debug

[Files]
; tools:
Source: ..\bin\7zip\x64\7za.exe; DestDir: {tmp}; Flags: dontcopy
Source: ..\bin\7zip\x64\*; DestDir: {app}\bin\tools\
Source: ..\bin\7zip\License.txt; DestDir: {app}\docs\licenses\; DestName: 7zip_license.txt;
Source: ..\bin\backup\*; DestDir: {app}\bin\backup\
Source: ..\bin\HideConsole\RunHiddenConsole.exe; DestDir: {app}\bin\tools\
Source: ..\bin\hosts\hosts.exe; DestDir: {app}\bin\tools\
Source: ..\bin\php-cgi-spawn\spawn.exe; DestDir: {app}\bin\tools\
; psvince is installed to the app folder, because it's needed during uninstallation, to check if daemons are still running.
Source: ..\bin\psvince\psvince.dll; DestDir: {app}\bin\tools\
Source: ..\bin\stripdown-mariadb.bat; DestDir: {tmp}
Source: ..\bin\stripdown-mongodb.bat; DestDir: {tmp}; Components: mongodb
Source: ..\bin\stripdown-postgresql.bat; DestDir: {tmp}; Components: postgresql
; incorporate the whole "www" folder into the setup, except the webinterface folder
Source: ..\www\*; DestDir: {app}\www; Flags: recursesubdirs; Excludes: \tools\webinterface,.git*;
; webinterface folder is only copied, if component "webinterface" is selected.
Source: ..\www\tools\webinterface\*; DestDir: {app}\www\tools\webinterface; Excludes:.git*,.travis*; Flags: recursesubdirs; Components: webinterface
; if webinterface is not installed by user, then delete the redirecting index.html file. this activates a simple dir listing.
Source: ..\www\index.html; DestDir: {app}\www; Flags: deleteafterinstall; Components: not webinterface
; ship documentation, changelog and license information
Source: ..\docs\*; DestDir: {app}\docs;
; incorporate several startfiles and shortcut commands
Source: ..\startfiles\backup.bat; DestDir: {app}
Source: ..\startfiles\composer.bat; DestDir: {app}\bin\composer; Components: composer
Source: ..\startfiles\console.bat; DestDir: {app}; Components: conemu
Source: ..\startfiles\pickle.bat; DestDir: {app}\bin\pickle; Components: pickle
Source: ..\startfiles\generate-certificate.bat; DestDir: {app}\bin\openssl; Components: openssl
Source: ..\startfiles\install-phpunit.bat; DestDir: {app}\bin\php\
Source: ..\startfiles\update-phars.bat; DestDir: {app}\bin\php\
Source: ..\startfiles\repair-mongodb.bat; DestDir: {app}; Components: mongodb
Source: ..\startfiles\reset-db-pw.bat; DestDir: {app}
Source: ..\startfiles\restart.bat; DestDir: {app}
Source: ..\startfiles\start-mongodb.bat; DestDir: {app}; Components: mongodb
Source: ..\startfiles\start-scp-server.bat; DestDir: {app}
Source: ..\startfiles\run.bat; DestDir: {app}
Source: ..\startfiles\status.bat; DestDir: {app}
Source: ..\startfiles\stop-mongodb.bat; DestDir: {app}; Components: mongodb
Source: ..\startfiles\stop.bat; DestDir: {app}
Source: ..\startfiles\webinterface.url; DestDir: {app}; Components: webinterface

; backup config files, when upgrading
Source: {app}\bin\php\php.ini; DestDir: {app}\bin\php; DestName: "php.ini.old"; Flags: external skipifsourcedoesntexist
Source: {app}\bin\nginx\conf\nginx.conf; DestDir: {app}\bin\nginx\conf; DestName: "nginx.conf.old"; Flags: external skipifsourcedoesntexist
Source: {app}\bin\mariadb\my.ini; DestDir: {app}\bin\mariadb; DestName: "my.ini.old"; Flags: external skipifsourcedoesntexist
Source: {app}\bin\mongodb\mongodb.conf; DestDir: {app}\bin\mongodb; DestName: "mongodb.conf.old"; Flags: external skipifsourcedoesntexist; Components: mongodb;
Source: {app}\bin\pgsql\data\postgresql.conf; DestDir: {app}\bin\pgsql\data; DestName: "postgresql.conf.old"; Flags: external skipifsourcedoesntexist; Components: postgresql;
Source: {app}\bin\backup\backup.txt; DestDir: {app}\bin\backup; DestName: "backup.txt.old"; Flags: external skipifsourcedoesntexist

; config files
Source: ..\software\php\config\{#PHP_VERSION}\php.ini; DestDir: {app}\bin\php
Source: ..\software\nginx\config\nginx.conf; DestDir: {app}\bin\nginx\conf
Source: ..\software\nginx\config\conf\sites-disabled\*; DestDir: {app}\bin\nginx\conf\sites-disabled
Source: ..\software\nginx\html\errorpages\*;                DestDir: {app}\bin\nginx\html\errorpages
Source: ..\software\mariadb\config\my.ini; DestDir: {app}\bin\mariadb
Source: ..\software\php\config\composer\php.ini; DestDir: {app}\bin\composer; Components: composer
Source: ..\software\phpmyadmin\config\config.inc.php; DestDir: {app}\www\tools\phpmyadmin; Components: phpmyadmin
Source: ..\software\redis\config\redis.windows.conf; DestDir: {app}\bin\redis; Components: redis
Source: ..\software\webgrind\config\config.php; DestDir: {app}\www\tools\webgrind; Components: webgrind
Source: ..\software\mongodb\config\mongodb.conf; DestDir: {app}\bin\mongodb; Components: mongodb
Source: ..\software\openssl\config\openssl.cfg; DestDir: {app}\bin\openssl; Components: openssl
Source: ..\software\openssl\cert-bundle\ca-bundle.crt; DestDir: {app}\bin\openssl; Components: openssl
Source: ..\software\conemu\config\*; DestDir: {app}\bin\conemu; Components: conemu
Source: ..\software\conemu\images\*; DestDir: {app}\bin\conemu; Components: conemu
Source: ..\software\git\config\bash_profile; DestDir: {app}\bin\git\etc; Components: git

[Icons]
Name: {group}\Server Control Panel; Filename: {app}\wpn-xm.exe; Tasks: add_startmenu
Name: {group}\Start WPN-XM; Filename: {app}\run.bat; Tasks: add_startmenu
Name: {group}\Stop WPN-XM; Filename: {app}\stop.bat; Tasks: add_startmenu
Name: {group}\Status of WPN-XM; Filename: {app}\status.bat; Tasks: add_startmenu
Name: {group}\Localhost; Filename: {app}\localhost.url; Tasks: add_startmenu
Name: {group}\Administration; Filename: {app}\administration.url; Tasks: add_startmenu
Name: {group}\{cm:ProgramOnTheWeb,{#APP_NAME}}; Filename: {#APP_URL}; Flags: preventpinning excludefromshowinnewinstall; Tasks: add_startmenu
Name: {group}\{cm:ReportBug}; Filename: {#APP_SUPPORT_URL}; Flags: preventpinning excludefromshowinnewinstall; Tasks: add_startmenu
Name: {group}\{cm:RemoveApp}; Filename: {uninstallexe}; Flags: preventpinning excludefromshowinnewinstall; Tasks: add_startmenu
Name: {userdesktop}\WPN-XM ServerControlPanel; Filename: {app}\wpn-xm.exe; Tasks: add_desktopicon
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\WPN-XM; Filename: {app}\wpn-xm.exe; Tasks: add_quicklaunchicon
Name: {userdesktop}\WPN-XM Start; Filename: {app}\run.bat; Tasks: add_startstop_desktopicons
Name: {userdesktop}\WPN-XM Stop; Filename: {app}\stop.bat; Tasks: add_startstop_desktopicons

[Tasks]
Name: portablemode; Description: "Portable Mode"; Flags: unchecked
Name: add_startmenu; Description: Create Startmenu entries
Name: add_quicklaunchicon; Description: Create a &Quick Launch icon for the Server Control Panel; GroupDescription: Additional Icons:; Components: servercontrolpanel
Name: add_desktopicon; Description: Create a &Desktop icon for the Server Control Panel; GroupDescription: Additional Icons:; Components: servercontrolpanel
Name: add_startstop_desktopicons; Description: Create &Desktop icons for starting and stopping; GroupDescription: Additional Icons:; Flags: unchecked

[Run]
; Automatically started...
Filename: {tmp}\stripdown-mariadb.bat; Parameters: "{app}\bin\mariadb"; Flags: runhidden;
Filename: {tmp}\stripdown-mongodb.bat; Parameters: "{app}\bin\mongodb"; Components: mongodb; Flags: runhidden;
Filename: {tmp}\stripdown-postgresql.bat; Parameters: "{app}\bin\pgsql"; Components: postgresql; Flags: runhidden;
; User selected Postinstallation runs...
Filename: {app}\wpn-xm.exe; Description: Start Server Control Panel; Flags: postinstall nowait skipifsilent unchecked; Components: servercontrolpanel

[Registry]
; A registry change needs the following directive: [SETUP] ChangesEnvironment=yes
; The registry is not modified, when in portable mode.
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\php"; Flags: preservestringtype; Check: NeedsAddPathCurrentUser(ExpandConstant('{app}\bin\php')); Tasks: not portablemode;
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\mariadb\bin"; Flags: preservestringtype; Check: NeedsAddPathCurrentUser(ExpandConstant('{app}\bin\mariadb\bin')); Tasks: not portablemode;
; when installing "Git for Windows", add "/bin/git/bin" to PATH, to have git available on CLI
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\git\bin"; Flags: preservestringtype; Check: NeedsAddPathCurrentUser(ExpandConstant('{app}\bin\git\bin')); Tasks: not portablemode; Components: git;
; when installing "Imagick", add "/bin/php/ext" to PATH, because the PHP extension needs to find the imagick CORE_*.dlls
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\php\ext"; Flags: preservestringtype; Check: NeedsAddPathCurrentUser(ExpandConstant('{app}\bin\php\ext')); Tasks: not portablemode; Components: imagick;
; when installing "Pickle", add "/bin/pickle" to PATH
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\pickle"; Flags: preservestringtype; Check: NeedsAddPathCurrentUser(ExpandConstant('{app}\bin\pickle')); Tasks: not portablemode; Components: pickle;
; when installing "Composer", add "/bin/composer" to PATH
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"PATH"; ValueData:"{olddata};{app}\bin\composer"; Flags: preservestringtype; Check: NeedsAddPathCurrentUser(ExpandConstant('{app}\bin\composer')); Tasks: not portablemode; Components: composer;

[Dirs]
Name: {app}\bin\backup
Name: {app}\bin\nginx\conf\sites-enabled
Name: {app}\logs
Name: {app}\temp
Name: {app}\www\tools\webinterface; Components: webinterface

[Code]
// include Unzip() helper
#include "includes\unzip.iss"

// include helper for VCRedist Conditional Installation Check
#include "includes\vcredist.iss"

// modification and path lookup helper for env PATH 
#include "includes\envpath.iss"

type
  TPositionStorage = array of Integer;

var
  CompPageModified: Boolean;
  CompPagePositions: TPositionStorage;
  // the controls move on resize
  WebsiteButton : TButton;
  HelpButton    : TButton;
  DebugLabel    : TNewStaticText;

const
  // reassign preprocessor constant debug
  DEBUG = {#DEBUG};

  {
     Define download URLs for the software packages
     ----------------------------------------------
     The majority of download URLs point to our redirection script.
     The WPN-XM redirection script uses an internal software registry for looking
     up the latest version and redirecting the installer to the download url.
  }

  URL_adminer               = 'http://wpn-xm.org/get.php?s=adminer';
  URL_benchmark             = 'http://wpn-xm.org/get.php?s=wpnxm-benchmark';
  URL_closure_compiler      = 'http://wpn-xm.org/get.php?s=closure-compiler';
  URL_composer              = 'http://wpn-xm.org/get.php?s=composer';
  URL_conemu                = 'http://wpn-xm.org/get.php?s=conemu';
  URL_gogitservice          = 'http://wpn-xm.org/get.php?s=gogs-x64';
  URL_heidisql              = 'http://wpn-xm.org/get.php?s=heidisql';
  URL_imagick               = 'http://wpn-xm.org/get.php?s=imagick';
  URL_mariadb               = 'http://wpn-xm.org/get.php?s=mariadb-x64';
  URL_memadmin              = 'http://wpn-xm.org/get.php?s=memadmin';
  URL_memcached             = 'http://wpn-xm.org/get.php?s=memcached-x64';
  URL_mongodb               = 'http://wpn-xm.org/get.php?s=mongodb';
  URL_msysgit               = 'http://wpn-xm.org/get.php?s=msysgit-x64';
  URL_nginx                 = 'http://wpn-xm.org/get.php?s=nginx';
  URL_node                  = 'http://wpn-xm.org/get.php?s=node';
  URL_nodenpm               = 'http://wpn-xm.org/get.php?s=nodenpm';
  URL_openssl               = 'http://wpn-xm.org/get.php?s=openssl-x64';
  URL_osquery               = 'http://wpn-xm.org/get.php?s=osquery';
  URL_php                   = 'http://wpn-xm.org/get.php?s=php-x64&p=7.1';
  URL_phpcsfixer            = 'http://wpn-xm.org/get.php?s=php-cs-fixer';
  URL_phpext_amqp           = 'http://wpn-xm.org/get.php?s=phpext_amqp&p=7.1&bitsize=x64';
  URL_phpext_apcu           = 'http://wpn-xm.org/get.php?s=phpext_apcu&p=7.1&bitsize=x64';
  //URL_phpext_ice            = 'http://wpn-xm.org/get.php?s=phpext_ice&p=7.1';  // phpext_ice not available for PHP 7.1 x64
  URL_phpext_imagick        = 'http://wpn-xm.org/get.php?s=phpext_imagick&p=7.1&bitsize=x64';
  // NOTE: phpext_jsond is part of PHP 7, because of Douglas Crockford
  URL_phpext_mailparse      = 'http://wpn-xm.org/get.php?s=phpext_mailparse&p=7.1&bitsize=x64';
  //URL_phpext_memcache       = 'http://wpn-xm.org/get.php?s=phpext_memcache&p=7.1&bitsize=x64';
  URL_phpext_mongodb        = 'http://wpn-xm.org/get.php?s=phpext_mongodb&p=7.1&bitsize=x64';
  URL_phpext_msgpack        = 'http://wpn-xm.org/get.php?s=phpext_msgpack&p=7.1&bitsize=x64';
  URL_phpext_pdo_sqlsrv     = 'http://wpn-xm.org/get.php?s=phpext_pdo_sqlsrv&p=7.1&bitsize=x64';
  //URL_phpext_phalcon        = 'http://wpn-xm.org/get.php?s=phpext_phalcon&p=7.1&bitsize=x64';
  //URL_phpext_rar            = 'http://wpn-xm.org/get.php?s=phpext_rar&p=7.1&bitsize=x64';
  // runkit not available for PHP7.1
  //URL_phpext_stats          = 'http://wpn-xm.org/get.php?s=phpext_stats&p=7.1&bitsize=x64';
  URL_phpext_sqlsrv         = 'http://wpn-xm.org/get.php?s=phpext_sqlsrv&p=7.1&bitsize=x64';
  URL_phpext_trader         = 'http://wpn-xm.org/get.php?s=phpext_trader&p=7.1&bitsize=x64';
  // uploadprogress not available for PHP7.1
  URL_phpext_varnish        = 'http://wpn-xm.org/get.php?s=phpext_varnish&p=7.1&bitsize=x64';
  URL_phpext_xdebug         = 'http://wpn-xm.org/get.php?s=phpext_xdebug&p=7.1&bitsize=x64';
  URL_phpext_zmq            = 'http://wpn-xm.org/get.php?s=phpext_zmq&p=7.1&bitsize=x64';
  URL_phpmemcachedadmin     = 'http://wpn-xm.org/get.php?s=phpmemcachedadmin';
  URL_phpmyadmin            = 'http://wpn-xm.org/get.php?s=phpmyadmin';
  URL_pickle                = 'http://wpn-xm.org/get.php?s=pickle';
  URL_postgresql            = 'http://wpn-xm.org/get.php?s=postgresql';
  URL_redis                 = 'http://wpn-xm.org/get.php?s=redis';
  URL_rclone                = 'http://wpn-xm.org/get.php?s=rclone-x64';
  URL_robo3t             = 'http://wpn-xm.org/get.php?s=robo3t';
  URL_sendmail              = 'http://wpn-xm.org/get.php?s=sendmail';
  URL_varnish               = 'http://wpn-xm.org/get.php?s=varnish';
  URL_vcredist              = 'http://wpn-xm.org/get.php?s=vcredist-x64&v=14.0.23026'; // Visual C++ Redistributable for Visual Studio 2015
  URL_webgrind              = 'http://wpn-xm.org/get.php?s=webgrind';
  URL_wpnxmscp              = 'http://wpn-xm.org/get.php?s=wpnxmscp';
  URL_yuicompressor         = 'http://wpn-xm.org/get.php?s=yuicompressor';

  // Define file names for the downloads
  Filename_adminer               = 'adminer.php';
  Filename_closure_compiler      = 'closure-compiler.zip';
  Filename_composer              = 'composer.phar';
  Filename_conemu                = 'conemu.7z';
  Filename_gogs                  = 'gogitservice.zip';
  Filename_heidisql              = 'heidisql.zip';
  Filename_imagick               = 'imagick.zip';
  Filename_mariadb               = 'mariadb.zip';
  Filename_memadmin              = 'memadmin.zip';
  Filename_memcached             = 'memcached.zip';
  Filename_mongodb               = 'mongodb.zip';
  Filename_msysgit               = 'msysgit.exe'; // WATCH IT: 7zip SFX EXE!
  Filename_nginx                 = 'nginx.zip';
  Filename_node                  = 'node.exe'; // WATCH IT: EXE!
  Filename_nodenpm               = 'nodenpm.zip';
  Filename_openssl               = 'openssl.zip';
  Filename_osquery               = 'osquery.zip';
  Filename_php                   = 'php.zip';
  Filename_php_cs_fixer          = 'php-cs-fixer.phar';
  Filename_phpext_amqp           = 'phpext_amqp.zip';
  Filename_phpext_apcu           = 'phpext_apcu.zip';
  //Filename_phpext_ice            = 'phpext_ice.zip'; // phpext_ice not available for PHP 7.1 x64
  Filename_phpext_imagick        = 'phpext_imagick.zip';
  // phpext_json is included in PHP7
  Filename_phpext_mailparse      = 'phpext_mailparse.zip';
  //Filename_phpext_memcache       = 'phpext_memcache.zip'; // memcache without D
  Filename_phpext_mongodb        = 'phpext_mongodb.zip';
  Filename_phpext_msgpack        = 'phpext_msgpack.zip';
  Filename_phpext_pdo_sqlsrv     = 'phpext_pdo_sqlsrv.zip';
  //Filename_phpext_phalcon        = 'phpext_phalcon.zip';
  //Filename_phpext_rar            = 'phpext_rar.zip';
  Filename_phpext_redis          = 'phpext_redis.zip';
  //Filename_phpext_runkit         = 'phpext_runkit.zip';
  Filename_phpext_stats          = 'phpext_stats.zip';
  Filename_phpext_sqlsrv         = 'phpext_sqlsrv.zip';  
  Filename_phpext_trader         = 'phpext_trader.zip';
  // phpext_uploadprogress not AV for 7
  Filename_phpext_varnish        = 'phpext_varnish.zip';
  Filename_phpext_xdebug         = 'phpext_xdebug.zip';
  Filename_phpext_zmq            = 'phpext_zmq.zip';
  Filename_phpmemcachedadmin     = 'phpmemcachedadmin.zip';
  Filename_phpmyadmin            = 'phpmyadmin.zip';
  Filename_pickle                = 'pickle.phar';
  Filename_postgresql            = 'postgresql.zip';
  Filename_rabbitmq              = 'rabbitmq.zip';
  Filename_rclone                = 'rclone.zip';
  Filename_redis                 = 'redis.zip';
  Filename_robo3t                = 'robo3t.zip';
  Filename_sendmail              = 'sendmail.zip';
  Filename_varnish               = 'varnish.zip';
  Filename_vcredist              = 'vcredist_x86.exe';
  Filename_webgrind              = 'webgrind.zip';
  Filename_wpnxm_benchmark       = 'wpnxm-benchmark.zip';
  Filename_wpnxm_scp             = 'wpnxmscp.zip';
  Filename_yuicompressor         = 'yuicompressor.jar';

var
  targetPath  : String;   // init in prepareUnzip() - if debug true will download to app/downloads, else temp dir
  appDir      : String;   // init in prepareUnzip() - installation folder of the application
  hideConsole : String;   // init in prepareUnzip() - shortcut to {tmp}\runHiddenConsole.exe
  InstallPage                   : TWizardPage;
  intTotalComponents            : Integer;
  intInstalledComponentsCounter : Integer;

procedure SaveComponentsPage(out Storage: TPositionStorage);
begin
  SetArrayLength(Storage, 13);

  Storage[0] := WizardForm.Height;
  Storage[1] := WizardForm.NextButton.Top;
  Storage[2] := WizardForm.BackButton.Top;
  Storage[3] := WizardForm.CancelButton.Top;
  Storage[4] := WizardForm.ComponentsList.Height;
  Storage[5] := WizardForm.OuterNotebook.Height;
  Storage[6] := WizardForm.InnerNotebook.Height;
  Storage[7] := WizardForm.Bevel.Top;
  Storage[8] := WizardForm.BeveledLabel.Top;
  Storage[9] := WizardForm.ComponentsDiskSpaceLabel.Top;
  Storage[10] := WebsiteButton.Top;
  Storage[11] := HelpButton.Top;
  if DEBUG = true then Storage[12] := DebugLabel.Top;
end;

procedure LoadComponentsPage(const Storage: TPositionStorage;
  HeightOffset: Integer);
begin
  if GetArrayLength(Storage) <> 13 then
    RaiseException('Invalid storage array length.');

  WizardForm.Height := Storage[0] + HeightOffset;
  WizardForm.NextButton.Top := Storage[1] + HeightOffset;
  WizardForm.BackButton.Top := Storage[2] + HeightOffset;
  WizardForm.CancelButton.Top := Storage[3] + HeightOffset;
  WizardForm.ComponentsList.Height := Storage[4] + HeightOffset;
  WizardForm.OuterNotebook.Height := Storage[5] + HeightOffset;
  WizardForm.InnerNotebook.Height := Storage[6] + HeightOffset;
  WizardForm.Bevel.Top := Storage[7] + HeightOffset;
  WizardForm.BeveledLabel.Top := Storage[8] + HeightOffset;
  WizardForm.ComponentsDiskSpaceLabel.Top := Storage[9] + HeightOffset;
  WebsiteButton.Top := Storage[10] + HeightOffset;
  HelpButton.Top := Storage[11] + HeightOffset;
  if DEBUG = true then DebugLabel.Top := Storage[12] + HeightOffset;
end;

// Runs an external command via RunHiddenConsole
function ExecHidden(Command: String): Integer;
var
  ErrorCode: Integer;
begin
  if Exec(hideConsole, ExpandConstant(Command), '', SW_SHOW, ewWaitUntilTerminated, ErrorCode) then
  begin
    Result := ErrorCode;
  end
  else
  begin
    Log('[Error] ExecHidden failed executing the following command: [' + ExpandConstant(Command) + ']');
    Result := ErrorCode;
  end;
end;

function ReplaceStringInFile(const SearchString: String; const ReplaceString: String; const FileName: String): boolean;
var
  MyFile : TStrings;
  MyText : string;
begin
  MyFile := TStringList.Create;

  try
    result := true;

    try
      MyFile.LoadFromFile(FileName);
      MyText := MyFile.Text;

      if StringChangeEx(MyText, SearchString, ReplaceString, True) > 0 then // save only, if text was changed
      begin;
        MyFile.Text := MyText;
        MyFile.SaveToFile(FileName);
      end;
    except
      result := false;
    end;
  finally
    MyFile.Free;
  end;
end;

procedure OpenBrowser(Url: string);
var
  ErrorCode: Integer;
begin
  ShellExec('open', Url, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure HelpButtonClick(Sender: TObject);
begin
  // example URL: http://wpn-xm.org/help.php?section=installation-wizard&type=webinstaller&page=1&version=0.6.0&language=de
  OpenBrowser('{#APP_URL}help.php'
    + '?section=installation-wizard'
    + '&type=' + Lowercase(ExpandConstant('{#INSTALLER_TYPE}'))
    + '&page=' + IntToStr(WizardForm.CurPageID)
    + '&version=' + ExpandConstant('{#APP_VERSION}')
    + '&language=' + ExpandConstant('{language}'));
end;

procedure WebsiteButtonClick(Sender: TObject);
begin
  OpenBrowser('{#APP_URL}');
end;

{
  Custom wpInstalling Page with two progress bars.

  The first progress bar shows the total progress.
    (1 of 10 zips to unzip = 10 %)
  The second progress bar shows the current operation progress.
    (unzipping component 2: 25% of 100%)

  The Page is put into the install page loop via
  CurPageChanged(CurPageID) -> CurPageID=wpInstalling then CustomWpInstallingPage;
}
procedure CustomWpInstallingPage;
var
  { Total Progress Bar }
  TotalProgressBar                : TNewProgressBar;
  TotalProgressLabel              : TLabel;
  TotalProgressStaticText         : TNewStaticText;

  { Current Component Progress Bar }
  CurrentComponentProgressBar     : TNewProgressBar;
  CurrentComponentLabel           : TLabel;
  CurrentComponentStaticText      : TNewStaticText;

begin
  // Custom InstallPage is shown after the wpReady page
  InstallPage := CreateCustomPage(wpReady, 'Installation', 'Description');

  { Total Progress Bar }

  TotalProgressStaticText := TNewStaticText.Create(InstallPage);
  TotalProgressStaticText.Top := 16;
  TotalProgressStaticText.Caption := 'Total Progress';
  TotalProgressStaticText.AutoSize := True;
  TotalProgressStaticText.Parent := InstallPage.Surface;

  TotalProgressBar := TNewProgressBar.Create(InstallPage);
  TotalProgressBar.Name := 'TotalProgressBar'; // needed for FindComponent()
  TotalProgressBar.Left := 24;
  TotalProgressBar.Top := 40;
  TotalProgressBar.Width := 366;
  TotalProgressBar.Height := 24;
  // The inital state of Min and Position is "-1". Position is set to "0", after Max has been
  // calculated, based on the number of selected components (see GetTotalNumberOfComponents()).
  TotalProgressBar.Min := -1
  TotalProgressBar.Position := -1
  TotalProgressBar.Parent := InstallPage.Surface;

  TotalProgressLabel := TLabel.Create(InstallPage);
  TotalProgressLabel.Name := 'TotalProgressLabel'; // needed for FindComponent()
  TotalProgressLabel.Top := TotalProgressStaticText.Top;
  TotalProgressLabel.Left := TotalProgressBar.Width;
  TotalProgressLabel.Caption := '--/--';
  TotalProgressLabel.Alignment := taRightJustify;
  TotalProgressLabel.Font.Style := [fsBold];
  TotalProgressLabel.Parent := InstallPage.Surface;

  { Current Component Progress Bar }

  CurrentComponentStaticText := TNewStaticText.Create(InstallPage);
  CurrentComponentStaticText.Top := 80;
  CurrentComponentStaticText.Caption := 'Extracting Component';
  CurrentComponentStaticText.AutoSize := True;
  CurrentComponentStaticText.Parent := InstallPage.Surface;

  CurrentComponentProgressBar := TNewProgressBar.Create(InstallPage);
  CurrentComponentProgressBar.Name := 'CurrentComponentProgressBar'; // needed for FindComponent()
  CurrentComponentProgressBar.Left := 24;
  CurrentComponentProgressBar.Top := 104;
  CurrentComponentProgressBar.Width := 366;
  CurrentComponentProgressBar.Height := 24;
  CurrentComponentProgressBar.Min := 0
  CurrentComponentProgressBar.Max := 100
  // Marquee displays some activity on the progressbar (pseudo progress)
  CurrentComponentProgressBar.Style := npbstMarquee;
  CurrentComponentProgressBar.Parent := InstallPage.Surface;

  CurrentComponentLabel := TLabel.Create(InstallPage);
  CurrentComponentLabel.Name := 'CurrentComponentLabel'; // needed for FindComponent()
  CurrentComponentLabel.Top := CurrentComponentStaticText.Top;
  CurrentComponentLabel.Width := 20;
  CurrentComponentLabel.Left := CurrentComponentProgressBar.Width;
  CurrentComponentLabel.Alignment := taRightJustify;
  CurrentComponentLabel.Caption := '';
  CurrentComponentLabel.Font.Style := [fsBold];
  CurrentComponentLabel.Parent := InstallPage.Surface;

  { Render Page }

  InstallPage.Surface.Show;       // show the new page
  InstallPage.Surface.Update;     // activate showing updates on this page
end;

procedure OnDirEditChange(Sender: TObject);
var
  S: string;
begin
  S := WizardDirValue;

  // string must not be empty
  if (Length(S) = 0) then MsgBox('Please enter a target folder for the installation.', mbError, MB_OK);

  // disallow installation into folders starting with "c:\windows"
  if(Pos(ExpandConstant('{win}'), S) > 0) then MsgBox('The installation into the windows folder is not allowed.', mbError, MB_OK);

  if(Pos(ExpandConstant('C:\Windows'), S) > 0) or (Pos(ExpandConstant('C:\windows'), S) > 0)
  or(Pos(ExpandConstant('c:\Windows'), S) > 0) or (Pos(ExpandConstant('c:\windows'), S) > 0)
  then MsgBox('The installation into the windows folder is not allowed.', mbError, MB_OK);

  // disallow installation into folders: program files
  if(Pos(ExpandConstant('{pf}'), S) > 0) then MsgBox('The installation into the program files folder is not allowed.', mbError, MB_OK);

  // disallow installation into folders: common files
  if(Pos(ExpandConstant('{cf}'), S) > 0) then MsgBox('The installation into the common files folder is not allowed.', mbError, MB_OK);

  // disallow installation into folders with spaces
  if(Pos(' ', S) > 0) then MsgBox('Your installation folder must not contain any spaces.', mbError, MB_OK);
end;

procedure InitializeWizard();
var
  VersionLabel  : TLabel;
  VersionLabel2 : TLabel;
  CancelBtn     : TButton;
begin
  // no resize flag
  CompPageModified := False;

  //change background colors of wizard pages and panels
  WizardForm.Mainpanel.Color:=$ECECEC;
  WizardForm.TasksList.Color:=$ECECEC;
  WizardForm.ReadyMemo.Color:=$ECECEC;
  WizardForm.WelcomePage.Color:=$ECECEC;
  WizardForm.FinishedPage.Color:=$ECECEC;
  WizardForm.WizardSmallBitmapImage.BackColor:=$ECECEC;

  {
    Configure Inno Download Plugin

    http://mitrich.net23.net/public/doc/idp/idpSetOption.htm
  }

  // allow user to continue installation if download fails.
  idpSetOption('AllowContinue',  '1');

  // Change from a simple overall progress bar to the detailed download view
  idpSetOption('DetailsVisible', '1');
  idpSetOption('DetailsButton',  '1');
  idpSetOption('RetryButton',    '1');
  idpSetOption('UserAgent',      'WPN-XM Server Stack - Webinstaller - ' + ExpandConstant('{#APP_VERSION}'));
  idpSetOption('InvalidCert',    'ignore');

  // Start the download after the "Ready to install" screen is shown
  idpDownloadAfter(wpReady);

  // reset files, previously added with idpAddFile() procedure
  idpClearFiles();

  // Display the Version Number as overlay on the WizardImageFile (banner-left)
  // Label for the WelcomePage
  VersionLabel            := TLabel.Create(WizardForm);
  VersionLabel.Top        := 43;
  VersionLabel.Left       := 129;
  VersionLabel.Caption    := ExpandConstant('{#APP_VERSION}');
  VersionLabel.Font.Name  := 'Tahoma';
  VersionLabel.Font.Size  := 7;
  VersionLabel.Font.Style := [fsBold];
  VersionLabel.Font.Color := $343434;
  VersionLabel.Parent     := WizardForm.WelcomePage;
  // Label for the Finished Page
  // ( @todo because i don't know how to attach one object to both wizard pages )
  VersionLabel2            := TLabel.Create(WizardForm);
  VersionLabel2.Top        := 43;
  VersionLabel2.Left       := 129;
  VersionLabel2.Caption    := ExpandConstant('{#APP_VERSION}');
  VersionLabel2.Font.Name  := 'Tahoma';
  VersionLabel2.Font.Size  := 7;
  VersionLabel2.Font.Style := [fsBold];
  VersionLabel2.Font.Color := $343434;
  VersionLabel2.Parent     := WizardForm.FinishedPage;

  // Display website link in the bottom left corner of the install wizard
  CancelBtn                := WizardForm.CancelButton;
  WebsiteButton            := TButton.Create(WizardForm);
  WebsiteButton.Top        := CancelBtn.Top;
  WebsiteButton.Left       := WizardForm.ClientWidth - CancelBtn.Left - CancelBtn.Width;
  WebsiteButton.Height     := CancelBtn.Height;
  WebsiteButton.Caption    := ExpandConstant('{cm:WebsiteButton}');
  WebsiteButton.Cursor     := crHand;
  WebsiteButton.Font.Color := clHighlight;
  WebsiteButton.OnClick    := @WebsiteButtonClick;
  WebsiteButton.Parent     := WizardForm;

  HelpButton               := TButton.Create(WizardForm);
  HelpButton.Top           := CancelBtn.Top;
  HelpButton.Left          := WebsiteButton.Left + WebsiteButton.Width;
  HelpButton.Height        := CancelBtn.Height;
  HelpButton.Caption       := ExpandConstant('{cm:HelpButton}');
  HelpButton.Cursor        := crHelp;
  HelpButton.Font.Color    := clHighlight;
  HelpButton.OnClick       := @HelpButtonClick;
  HelpButton.Parent        := WizardForm;

  // Show that Debug Mode is active
  if DEBUG = true then
  begin
    DebugLabel            := TNewStaticText.Create(WizardForm);
    DebugLabel.Top        := WebsiteButton.Top + 4;
    DebugLabel.Left       := WebsiteButton.Left + WebsiteButton.Width + 85;
    DebugLabel.Caption    := ExpandConstant('DEBUG ON');
    DebugLabel.Font.Style := [fsBold];
    DebugLabel.Parent     := WizardForm;
  end;

  // register OnChange event handling function for the "Select Destination Location" dialog
  // if the folder is not OK, force the user to fix it.
  WizardForm.DirEdit.OnChange := @OnDirEditChange;
end;

function NextButtonClick(CurPage: Integer): Boolean;
(*
    Called when the user clicks the Next button.
    If you return True, the wizard will move to the next page.
    If you return False, it will remain on the current page (specified by CurPageID).
*)
begin
  if CurPage = wpSelectComponents then
  begin
    // The "targetPath" for downloads or extractions is the temporary path.
    // When the installation is finished (or at least when temp folder gets cleared) the stuff gets deleted.
    targetPath := ExpandConstant('{tmp}\');

    {
      Leave this!   - It's for determining the download file sizes manually
      There is a strange bug, when trying to get the filesize from googlecode.
      So webgrind has a size of 0. Thats why "unknown" is shown as total progress.

      idpGetFileSize(URL_nginx, size);
      MsgBox(intToStr(size), mbError, MB_OK);
    }

    // Add Files to Download Handler

    if IsComponentSelected('serverstack') then
    begin
      idpAddFile(URL_nginx,   ExpandConstant(targetPath + Filename_nginx));
      idpAddFile(URL_php,     ExpandConstant(targetPath + Filename_php));
      idpAddFile(URL_mariadb, ExpandConstant(targetPath + Filename_mariadb));
    end;

    if IsComponentSelected('adminer')            then idpAddFile(URL_adminer,           ExpandConstant(targetPath + Filename_adminer));

    if IsComponentSelected('assettools') then
    begin
       idpAddFile(URL_closure_compiler, ExpandConstant(targetPath + Filename_closure_compiler));
       idpAddFile(URL_yuicompressor, ExpandConstant(targetPath + Filename_yuicompressor));
    end;

    if IsComponentSelected('benchmark')          then idpAddFile(URL_benchmark,         ExpandConstant(targetPath + Filename_wpnxm_benchmark));
    if IsComponentSelected('composer')           then idpAddFile(URL_composer,          ExpandConstant(targetPath + Filename_composer));
    if IsComponentSelected('conemu')             then idpAddFile(URL_conemu,            ExpandConstant(targetPath + Filename_conemu));

    if IsComponentSelected('git') then
    begin
       idpAddFile(URL_gogitservice, ExpandConstant(targetPath + Filename_gogs));
       idpAddFile(URL_msysgit,      ExpandConstant(targetPath + Filename_msysgit));
    end;

    if IsComponentSelected('heidisql') then
    begin
       idpAddFile(URL_heidisql, ExpandConstant(targetPath + Filename_heidisql));
    end;

    if IsComponentSelected('imagick') then
    begin
       idpAddFile(URL_imagick,           ExpandConstant(targetPath + Filename_imagick));
       idpAddFile(URL_phpext_imagick,    ExpandConstant(targetPath + Filename_phpext_imagick));
    end;

    if IsComponentSelected('memadmin') then
    begin
       idpAddFile(URL_memadmin,          ExpandConstant(targetPath + Filename_memadmin));
    end;

    if IsComponentSelected('memcached') then
    begin
        idpAddFile(URL_memcached,        ExpandConstant(targetPath + Filename_memcached));
        //idpAddFile(URL_phpext_memcache,  ExpandConstant(targetPath + Filename_phpext_memcache));
    end;

    if IsComponentSelected('mongodb')    then
    begin
        idpAddFile(URL_mongodb,        ExpandConstant(targetPath + Filename_mongodb));
        idpAddFile(URL_phpext_mongodb, ExpandConstant(targetPath + Filename_phpext_mongodb));
    end;

    if IsComponentSelected('node') then
    begin
       idpAddFile(URL_node,    ExpandConstant(targetPath + Filename_node));
       idpAddFile(URL_nodenpm, ExpandConstant(targetPath + Filename_nodenpm));
    end;

    if IsComponentSelected('openssl')            then idpAddFile(URL_openssl,           ExpandConstant(targetPath + Filename_openssl));
    if IsComponentSelected('osquery')            then idpAddFile(URL_osquery,           ExpandConstant(targetPath + Filename_osquery));
    if IsComponentSelected('phpcsfixer')         then idpAddFile(URL_phpcsfixer,        ExpandConstant(targetPath + Filename_php_cs_fixer));
    if IsComponentSelected('phpmemcachedadmin')  then idpAddFile(URL_phpmemcachedadmin, ExpandConstant(targetPath + Filename_phpmemcachedadmin));
    if IsComponentSelected('phpmyadmin')         then idpAddFile(URL_phpmyadmin,        ExpandConstant(targetPath + Filename_phpmyadmin));
    if IsComponentSelected('postgresql')         then idpAddFile(URL_postgresql,        ExpandConstant(targetPath + Filename_postgresql));
    if IsComponentSelected('pickle')             then idpAddFile(URL_pickle,            ExpandConstant(targetPath + Filename_pickle));
    if IsComponentSelected('redis')              then idpAddFile(URL_redis,             ExpandConstant(targetPath + Filename_redis));
    if IsComponentSelected('robomongo')          then idpAddFile(URL_robo3t,         ExpandConstant(targetPath + Filename_robo3t));
    if IsComponentSelected('sendmail')           then idpAddFile(URL_sendmail,          ExpandConstant(targetPath + Filename_sendmail));
    if IsComponentSelected('servercontrolpanel') then idpAddFile(URL_wpnxmscp,          ExpandConstant(targetPath + Filename_wpnxm_scp));
    if IsComponentSelected('webgrind')           then idpAddFileSize(URL_webgrind,      ExpandConstant(targetPath + Filename_webgrind), 648000);
    if IsComponentSelected('xdebug')             then idpAddFile(URL_phpext_xdebug,     ExpandConstant(targetPath + Filename_phpext_xdebug));

    if IsComponentSelected('varnish') then
    begin
       idpAddFile(URL_varnish,                ExpandConstant(targetPath + Filename_varnish));
       idpAddFile(URL_phpext_varnish,         ExpandConstant(targetPath + Filename_phpext_varnish));
    end;

    if IsComponentSelected('phpextensions') then
    begin
        idpAddFile(URL_phpext_amqp,           ExpandConstant(targetPath + Filename_phpext_amqp));
        idpAddFile(URL_phpext_apcu,           ExpandConstant(targetPath + Filename_phpext_apcu));
        // phpext_ice not AV PHP 7.1 x86
        // phpext_json part of core
		idpAddFile(URL_phpext_mailparse,      ExpandConstant(targetPath + Filename_phpext_mailparse));
        idpAddFile(URL_phpext_msgpack,        ExpandConstant(targetPath + Filename_phpext_msgpack));
        idpAddFile(URL_phpext_pdo_sqlsrv,       ExpandConstant(targetPath + Filename_phpext_pdo_sqlsrv));
        //idpAddFile(URL_phpext_phalcon,        ExpandConstant(targetPath + Filename_phpext_phalcon));
        //idpAddFile(URL_phpext_rar,            ExpandConstant(targetPath + Filename_phpext_rar));
        // runkit
        //idpAddFile(URL_phpext_stats,          ExpandConstant(targetPath + Filename_phpext_stats));
        idpAddFile(URL_phpext_sqlsrv,         ExpandConstant(targetPath + Filename_phpext_sqlsrv));
        idpAddFile(URL_phpext_trader,         ExpandConstant(targetPath + Filename_phpext_trader));
        // uploadprogress not av for PHP7
        idpAddFile(URL_phpext_zmq,            ExpandConstant(targetPath + Filename_phpext_zmq));
        // phpext_imagick installed with imagick
        // phpext_memcache installed with memcached
        // phpext_mongodb installed with mongodb
        // phpext_xdebug is standalone
        // phpext_redis is installed with redis
     end;

    if (VCRedist_x64_2012_NeedsInstall() = TRUE) then
    begin
        idpAddFile(URL_vcredist, ExpandConstant(targetPath + Filename_vcredist));
    end;

    // if DEBUG On and already downloaded, skip downloading files, by resetting files
    if (DEBUG = true) and (FileExists(ExpandConstant(targetPath + 'nginx.zip')) = true) then
    begin
       MsgBox('Debug On. Skipping all downloads, because file exists: ' + ExpandConstant(targetPath + 'nginx.zip'), mbInformation, MB_OK);
       idpClearFiles();
    end;

  end; // of wpSelectComponents

  Result := True;
end;

procedure DoExtractSFX(source: String; targetdir: String);
begin
    // You MUST use DOUBLE backslashes in the InstallPath.
    // Here StringChangeEx is used to change Backslashes to DoubleBackslashes.
    StringChangeEx(targetdir, '\', '\\', False);

    ExecHidden(source + ' -y -gm2 -InstallPath="' + targetDir + '"');
end;

Procedure GetNumberOfSelectedComponents(selectedComponents : String);
var
  i : Integer;
begin
  // determine the total number of components by counting the selected components.
  for i := 0 to WizardForm.ComponentsList.Items.Count - 1 do
    if WizardForm.ComponentsList.Checked[i] = true then
       intTotalComponents := intTotalComponents + 1;

  if (DEBUG = true) then Log('# The following [' + IntToStr(intTotalComponents) + '] components are selected: ' + selectedComponents);

  // the "serverstack" contains 3 components and is always installed. we have to add 2 to the counter.
  intTotalComponents := intTotalComponents + 2;

  // the following components contain 2 components. if selected, we have to add 1 to the counter.
  if Pos('assettools', selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // closure+yuicomp
  if Pos('git',        selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // gogs+msysgit
  if Pos('node',       selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // npm
  if Pos('memcached',  selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // phpext_memcache
  if Pos('varnish',    selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // phpext_varnish
  if Pos('imagick',    selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // phpext_imagick
  if Pos('mongodb',    selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // phpext_mongo
  if Pos('redis',      selectedComponents) > 0 then intTotalComponents := intTotalComponents + 1; // phpext_redis

  // the component "PHP Extensions" contains 11 extensions. if selected, we have to add 10 to the counter.
  if Pos('phpextensions', selectedComponents) > 0 then intTotalComponents := intTotalComponents + 10;

  if (DEBUG = true) then Log('# Recalculated total number of components: [' + IntToStr(intTotalComponents) + ']');
end;

procedure UpdateTotalProgressBar();
{
  This procedure is called, when installing a component is finished.
  It updates the TotalProgessBar and the Label in the InstallationScreen with the new percentage.
}
var
    TotalProgressBar   : TNewProgressBar;
    TotalProgressLabel : TLabel;
begin
    TotalProgressBar := TNewProgressBar(InstallPage.FindComponent('TotalProgressBar'));

    {
      Initalize the ProgessBar
    }

    if(TotalProgressBar.Position = -1) then
    begin
        TotalProgressBar.Min := 0;
        TotalProgressBar.Position := 0;
        TotalProgressBar.Max := (intTotalComponents * 100);
        if (DEBUG = true) then Log('# ProgressBar.Max set to: [' + IntToStr(TotalProgressBar.Max) + '].');
    end;

    {
      Increase counter and update the ProgressBar accordingly
    }

    // increase counter
    intInstalledComponentsCounter := intInstalledComponentsCounter + 1;

    // Update Label
    TotalProgressLabel := TLabel(InstallPage.FindComponent('TotalProgressLabel'));
    TotalProgressLabel.Caption := IntToStr(intInstalledComponentsCounter) + '/' +IntToStr(intTotalComponents);

    // Update ProgressBar
    TotalProgressBar.Position := (intInstalledComponentsCounter * 100);

    if (DEBUG = true) then
    begin
      Log('# Processed Components '+IntToStr(intInstalledComponentsCounter) +'/'+IntToStr(intTotalComponents)+'.');
    end;
end;

{
  This procedure is called, when installing a new component starts.
  It updates the CurrentComponentLabel with the name of the component.
}
procedure UpdateCurrentComponentName(component: String);
var
    CurrentComponentLabel : TLabel;
begin
    CurrentComponentLabel := TLabel(InstallPage.FindComponent('CurrentComponentLabel'));
    CurrentComponentLabel.Caption := component;
    if (DEBUG = true) then Log('# Extracting Component: ' + component);
end;

{
  Called from DoPreInstall() before UnzipFiles().

  We extract some tools
}
procedure PrepareUnzip();
begin
  // extract unzip util from the compressed setup to temp folder
  ExtractTemporaryFile('7za.exe');

  // set application path as global variable
  appDir := ExpandConstant('{app}');

  // set "targetPath" for downloads or extractions to the temporary path
  // when the installation is finished, the temp folder gets cleared.
  targetPath := ExpandConstant('{tmp}\');

  // fetch the "hide console" command from the compressed setup and define a shortcut
  ExtractTemporaryFile('RunHiddenConsole.exe');
  hideConsole := targetPath + 'RunHiddenConsole.exe';

  // create missing folders
  ForceDirectories(appDir + '\bin');
  ForceDirectories(appDir + '\www\tools');
  ForceDirectories(appDir + '\docs\licenses');
end;

{
  Called from DoPreInstall() after PrepareUnzip().
}
procedure UnzipFiles();
var
  selectedComponents     : String;
begin
  selectedComponents := WizardSelectedComponents(false);

  GetNumberOfSelectedComponents(selectedComponents);

  // Update Progress Bars

  // always unzip the serverstack base (3 components)

  UpdateCurrentComponentName('Nginx');
    Unzip(targetPath + Filename_nginx, appDir + '\bin'); // no subfolder, brings own dir
    ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\nginx-* ' + appDir + '\bin\nginx"'); // rename directory
  UpdateTotalProgressBar();

  UpdateCurrentComponentName('PHP');
    Unzip(targetPath + Filename_php, appDir + '\bin\php');
  UpdateTotalProgressBar();

  UpdateCurrentComponentName('MariaDB');
    Unzip(targetPath + Filename_mariadb, appDir + '\bin'); // no subfolder, brings own dir
    ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\mariadb-* ' + appDir + '\bin\mariadb"');  // rename directory
  UpdateTotalProgressBar();

  // unzip selected components

  if Pos('benchmark', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('WPN-XM Benchmark Tools');

      Unzip(ExpandConstant(targetPath + Filename_wpnxm_benchmark), appDir); // multiple files and folders into top level
    UpdateTotalProgressBar();
  end;

  if Pos('heidisql', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('HeidiSQL');
      ForceDirectories(appDir + '\bin\heidisql\');
      Unzip(targetPath + Filename_heidisql, appDir + '\bin\heidisql');
    UpdateTotalProgressBar();
  end;

  if Pos('conemu', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('ConEmu');
      ForceDirectories(appDir + '\bin\conemu\');
      Unzip(targetPath + Filename_conemu, appDir + '\bin\conemu');
    UpdateTotalProgressBar();
  end;

  if Pos('servercontrolpanel', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('WPN-XM Server Control Panel');
      Unzip(ExpandConstant(targetPath + Filename_wpnxm_scp), appDir); // no subfolder, top level
    UpdateTotalProgressBar();
  end;

  if Pos('git', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Go Git Service');
      Unzip(ExpandConstant(targetPath + Filename_gogs), appDir + '\bin'); // no subfolder, brings own dir (/gogs)
      DelTree(appDir + '\bin\__MACOSX', True, True, True); // remove odd packaging artefacts
    UpdateTotalProgressBar();

    UpdateCurrentComponentName('Git for Windows');
      ForceDirectories(appDir + '\bin\git');
      DoExtractSFX(targetPath + Filename_msysgit, appDir + '\bin\git');
    UpdateTotalProgressBar();
  end;

  if Pos('rabbitmq', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('RabbitMQ');
      Unzip(ExpandConstant(targetPath + Filename_rabbitmq), appDir + '\bin\'); // no subfolder, brings own folder "rabbitmq_server-x.y.z"
      ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\rabbitmq_* ' + appDir + '\bin\rabbitmq"'); // rename folder
    UpdateTotalProgressBar();
  end;

  if Pos('redis', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Redis');
      Unzip(ExpandConstant(targetPath + Filename_redis), appDir + '\bin\redis'); // no subfolder, top level
    UpdateTotalProgressBar();

    UpdateCurrentComponentName('PHP Extension - Redis');
      Unzip(targetPath + Filename_phpext_redis, targetPath + 'phpext_redis');
      FileCopy(ExpandConstant(targetPath + 'phpext_redis\php_redis.dll'), appDir + '\bin\php\ext\php_redis.dll', false);
    UpdateTotalProgressBar();
  end;

  if Pos('assettools', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Google Closure Compiler');
      Unzip(ExpandConstant(targetPath + Filename_closure_compiler), appDir + '\bin\assettools');
    UpdateTotalProgressBar();

    UpdateCurrentComponentName('YUI Compressor');
      FileCopy(ExpandConstant(targetPath + Filename_yuicompressor), appDir + '\bin\assettools\' + Filename_yuicompressor, false);
    UpdateTotalProgressBar();
  end;

  if Pos('node', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Node JS');
      ForceDirectories(appDir + '\bin\node\');
      FileCopy(ExpandConstant(targetPath + Filename_node), appDir + '\bin\node\node.exe', false);
    UpdateTotalProgressBar();

    UpdateCurrentComponentName('Node NPM');
      Unzip(ExpandConstant(targetPath + Filename_nodenpm), appDir + '\bin\node'); // into the node folder
    UpdateTotalProgressBar();
  end;

  if Pos('openssl', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('OpenSSL');
      Unzip(ExpandConstant(targetPath + Filename_openssl), appDir + '\bin\openssl');
    UpdateTotalProgressBar();
  end;

  if Pos('osquery', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('OpenSSL');
      Unzip(ExpandConstant(targetPath + Filename_osquery), appDir + '\bin\osquery');
    UpdateTotalProgressBar();
  end;

  if Pos('rclone', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('RClone');
      Unzip(ExpandConstant(targetPath + Filename_rclone), appDir + '\bin\rclone');
    UpdateTotalProgressBar();
  end;

  if Pos('xdebug', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Xdebug');
      Unzip(targetPath + Filename_phpext_xdebug, targetPath + 'phpext_xdebug');
      FileCopy(ExpandConstant(targetPath + 'phpext_xdebug\php_xdebug.dll'), appDir + '\bin\php\ext\php_xdebug.dll', false);

      ForceDirectories(appDir + '\www\tools\xdebug\');
      FileCopy(ExpandConstant(targetPath + 'phpext_xdebug\tracefile-analyser.php'), appDir + '\www\tools\xdebug\tracefile-analyser.php', false);
    UpdateTotalProgressBar();
  end;

  if Pos('phpextensions', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('PHP Extension - AMQP');
      Unzip(targetPath + Filename_phpext_amqp, targetPath + 'phpext_amqp');
      FileCopy(ExpandConstant(targetPath + 'phpext_amqp\php_amqp.dll'), appDir + '\bin\php\ext\php_amqp.dll', false);
      FileCopy(ExpandConstant(targetPath + 'phpext_amqp\rabbitmq.1.dll'), appDir + '\bin\php\ext\rabbitmq.1.dll', false);
    UpdateTotalProgressBar();

    UpdateCurrentComponentName('PHP Extension - APCu');
      Unzip(targetPath + Filename_phpext_apcu, targetPath + 'phpext_apcu');
      FileCopy(ExpandConstant(targetPath + 'phpext_apcu\php_apcu.dll'), appDir + '\bin\php\ext\php_apcu.dll', false);
    UpdateTotalProgressBar();

    { 
      
       PHP Extension - ICE Not AV for 7.1
      
    }
   
    //
    //  The PHP extension JsonD is part of core PHP 7.
    //
    //

    UpdateCurrentComponentName('PHP Extension - Mailparse');
      Unzip(targetPath + Filename_phpext_mailparse, targetPath + 'phpext_mailparse');
      FileCopy(ExpandConstant(targetPath + 'phpext_mailparse\php_mailparse.dll'), appDir + '\bin\php\ext\php_mailparse.dll', false);
    UpdateTotalProgressBar();

    UpdateCurrentComponentName('PHP Extension - MsgPack');
      Unzip(targetPath + Filename_phpext_msgpack, targetPath + 'phpext_msgpack');
      FileCopy(ExpandConstant(targetPath + 'phpext_msgpack\php_msgpack.dll'), appDir + '\bin\php\ext\php_msgpack.dll', false);
    UpdateTotalProgressBar();

   // UpdateCurrentComponentName('PHP Extension - UploadProgress');
     // Unzip(targetPath + Filename_phpext_uploadprogress, targetPath + 'phpext_uploadprogress');
     // FileCopy(ExpandConstant(targetPath + 'phpext_uploadprogress\php_uploadprogress.dll'), appDir + '\bin\php\ext\php_uploadprogress.dll', false);
   // UpdateTotalProgressBar();

   // UpdateCurrentComponentName('PHP Extension - Phalcon');
     // Unzip(targetPath + Filename_phpext_phalcon, targetPath + 'phpext_phalcon');
     // FileCopy(ExpandConstant(targetPath + 'phpext_phalcon\php_phalcon.dll'), appDir + '\bin\php\ext\php_phalcon.dll', false);
   // UpdateTotalProgressBar();

    UpdateCurrentComponentName('PHP Extension - Stats');
      Unzip(targetPath + Filename_phpext_stats, targetPath + 'phpext_stats');
      FileCopy(ExpandConstant(targetPath + 'phpext_stats\php_stats.dll'), appDir + '\bin\php\ext\php_stats.dll', false);
    UpdateTotalProgressBar();
    // rar
    //
    //
    //
  
    UpdateCurrentComponentName('PHP Extension - SQLSRV');

      Unzip(targetPath + Filename_phpext_sqlsrv, targetPath + 'phpext_sqlsrv');     
      FileCopy(ExpandConstant(targetPath + 'phpext_sqlsrv\php_sqlsrv.dll'), appDir + '\bin\php\ext\php_sqlsrv.dll', false);
    UpdateTotalProgressBar();

    UpdateCurrentComponentName('PHP Extension - PDO_SQLSRV');
      Unzip(targetPath + Filename_phpext_pdo_sqlsrv, targetPath + 'phpext_pdo_sqlsrv');
      FileCopy(ExpandConstant(targetPath + 'phpext_pdo_sqlsrv\php_pdo_sqlsrv.dll'), appDir + '\bin\php\ext\php_pdo_sqlsrv.dll', false);
    UpdateTotalProgressBar();

   // UpdateCurrentComponentName('PHP Extension - RAR');
     // Unzip(targetPath + Filename_phpext_rar, targetPath + 'phpext_rar');
     // FileCopy(ExpandConstant(targetPath + 'phpext_rar\php_rar.dll'), appDir + '\bin\php\ext\php_rar.dll', false);
   // UpdateTotalProgressBar();

   // UpdateCurrentComponentName('PHP Extension - Trader');
     // Unzip(targetPath + Filename_phpext_trader, targetPath + 'phpext_trader');
     // FileCopy(ExpandConstant(targetPath + 'phpext_trader\php_trader.dll'), appDir + '\bin\php\ext\php_trader.dll', false);
   // UpdateTotalProgressBar();

    UpdateCurrentComponentName('PHP Extension - ZMQ');
      Unzip(targetPath + Filename_phpext_zmq, targetPath + 'phpext_zmq');
      FileCopy(ExpandConstant(targetPath + 'phpext_zmq\php_zmq.dll'), appDir + '\bin\php\ext\php_zmq.dll', false);
      FileCopy(ExpandConstant(targetPath + 'phpext_zmq\libzmq.dll'), appDir + '\bin\php\ext\libzmq.dll', false);
    UpdateTotalProgressBar();
  end;

  if Pos('varnish', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Varnish');
      Unzip(targetPath + Filename_varnish, appDir + '\bin'); // no subfolder, brings own dir
      ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\varnish-* ' + appDir + '\bin\varnish"');// rename directory, like "varnish-3.0.2"
    UpdateTotalProgressBar();

   // UpdateCurrentComponentName('PHP Extension - Varnish');
     // Unzip(targetPath + Filename_phpext_varnish, targetPath + 'phpext_varnish');
     // FileCopy(ExpandConstant(targetPath + 'phpext_varnish\php_varnish.dll'), appDir + '\bin\php\ext\php_varnish.dll', false);
   // UpdateTotalProgressBar();
  end;

  if Pos('imagick', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Imagick');
      ForceDirectories(appDir + '\bin\imagick\');
      Unzip(targetPath + Filename_imagick, appDir + '\bin\imagick');
    UpdateTotalProgressBar();

    UpdateCurrentComponentName('PHP Extension - Imagick');
      Unzip(targetPath + Filename_phpext_imagick, targetPath + 'phpext_imagick');
      // copy php_imagick.dll and CORE_RL_*.dll
      ExecHidden('cmd.exe /c "copy ' + targetPath + 'phpext_imagick\*.dll' + ' ' + appDir + '\bin\php\ext\*.dll' + '"');

      // Delete pdb and crappy text files
      DelTree(targetPath + 'phpext_imagick\*.dll', False, True, False);
      DelTree(targetPath + 'phpext_imagick\*.pdb', False, True, False);
      DeleteFile(targetPath + 'phpext_imagick\TODO');
      DeleteFile(targetPath + 'phpext_imagick\INSTALL');
      DeleteFile(targetPath + 'phpext_imagick\CREDITS');
      DeleteFile(targetPath + 'phpext_imagick\ChangeLog');
      DeleteFile(targetPath + 'phpext_imagick\LICENSE');
      DeleteFile(targetPath + 'phpext_imagick\LICENSE.IMAGEMAGICK');
      DeleteFile(targetPath + 'phpext_imagick\OFL.txt');

      // Move all remaining files (examples) shipped with the extension to /www/tools/imagick
      ForceDirectories(appDir + '\www\tools\imagick\');
      ExecHidden('cmd.exe /c "move /Y ' + targetPath + 'phpext_imagick\*.* ' + appDir + '\www\tools\imagick"');

    UpdateTotalProgressBar();
  end;
  
  if Pos('memcached', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Memcached');
      Unzip(targetPath + Filename_memcached, appDir + '\bin'); // no subfolder, brings own dir
      ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\memcached-* ' + appDir + '\bin\memcached"'); // rename folder
    UpdateTotalProgressBar;

   // UpdateCurrentComponentName('PHP Extension - Memcached');
     // Unzip(targetPath + Filename_phpext_memcache, targetPath + 'phpext_memcache');
     // FileCopy(ExpandConstant(targetPath + 'phpext_memcache\php_memcache.dll'), appDir + '\bin\php\ext\php_memcache.dll', false);
   // UpdateTotalProgressBar();
  end;

  if Pos('memadmin', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Memadmin');
      Unzip(targetPath + Filename_memadmin, appDir + '\www\tools'); // no subfolder, brings own dir
      ExecHidden('cmd.exe /c "move /Y ' + appDir + '\www\tools\memadmin-* ' + appDir + '\www\tools\memadmin"'); // rename folder, e.g. "memadmin-1.0.11"
    UpdateTotalProgressBar();
  end;

  if Pos('phpmemcachedadmin', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('phpMemcachedAdmin');
      Unzip(targetPath + Filename_phpmemcachedadmin, appDir + '\www\tools\phpmemcachedadmin');
    UpdateTotalProgressBar();
  end;

  if Pos('phpmyadmin', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('phpMyAdmin');
      Unzip(targetPath + Filename_phpmyadmin, appDir + '\www\tools'); // no subfolder, brings own dir
      ExecHidden('cmd.exe /c "move /Y ' + appDir + '\www\tools\phpMyAdmin-*  ' + appDir + '\www\tools\phpmyadmin"'); // rename folder, e.g. "phpMyAdmin-3.4.6-english"
    UpdateTotalProgressBar();
  end;

  if Pos('pickle', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('pickle');
      // pickle is not zipped. Its a PHP PHAR file.
      FileCopy(ExpandConstant(targetPath + Filename_pickle), appDir + '\bin\pickle\' + Filename_pickle, false);
    UpdateTotalProgressBar();
  end;

  if Pos('postgresql', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('PostgreSQL');
      Unzip(targetPath + Filename_postgresql, appDir + '\bin'); // no subfolder, brings own dir "pgsql"
    UpdateTotalProgressBar();
  end;

  // adminer is not zipped. its a php file. copy it to the target path.
  if Pos('adminer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Adminer');
      ForceDirectories(appDir + '\www\tools\adminer\');
      FileCopy(ExpandConstant(targetPath + Filename_adminer), appDir + '\www\tools\adminer\' + Filename_adminer, false);
    UpdateTotalProgressBar();
  end;

  // composer is not zipped, its just a php phar package, so copy it to the php path
  if Pos('composer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Composer');
      FileCopy(ExpandConstant(targetPath + Filename_composer), appDir + '\bin\composer\' + Filename_composer, false);
    UpdateTotalProgressBar();
  end;

  // php-cs-fixer is a php phar package, so copy it to the php path
  if Pos('phpcsfixer', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('phpcsfixer');
      FileCopy(ExpandConstant(targetPath + Filename_php_cs_fixer), appDir + '\bin\php\' + Filename_php_cs_fixer, false);
    UpdateTotalProgressBar();
  end;

  if Pos('sendmail', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Sendmail');
      ForceDirectories(appDir + '\bin\sendmail\');
      Unzip(targetPath + Filename_sendmail, appDir + '\bin\sendmail');
    UpdateTotalProgressBar();
  end;

  if Pos('webgrind', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Webgrind');
      Unzip(targetPath + Filename_webgrind, appDir + '\www\tools'); // no subfolder, brings own dir
      ExecHidden('cmd.exe /c "move /Y ' + appDir + '\www\tools\webgrind-master ' + appDir + '\www\tools\webgrind"'); // rename folder, e.g. "webgrind-master"
    UpdateTotalProgressBar();
  end;

  if Pos('robo3t', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('Robo 3T');
      Unzip(targetPath + Filename_robo3t, appDir + '\bin'); // no subfolder, brings own dir
      ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\robo3t-* ' + appDir + '\bin\robo3t"'); // rename folder
    UpdateTotalProgressBar();
  end;

  if Pos('mongodb', selectedComponents) > 0 then
  begin
    UpdateCurrentComponentName('MongoDB');
      Unzip(targetPath + Filename_mongodb, appDir + '\bin'); // no subfolder, brings own dir
      ExecHidden('cmd.exe /c "move /Y ' + appDir + '\bin\mongodb-* ' + appDir + '\bin\mongodb"');  // rename directory
    UpdateTotalProgressBar();

    UpdateCurrentComponentName('PHP Extension - Mongo');
      Unzip(targetPath + Filename_phpext_mongodb, targetPath + 'phpext_mongo');
      FileCopy(ExpandConstant(targetPath + 'phpext_mongo\php_mongo.dll'), appDir + '\bin\php\ext\php_mongo.dll', false);
    UpdateTotalProgressBar();
  end;

end;

{
   DoPreInstall will be called after the user clicks Next on the wpReady page,
   but before Inno installs any of the [Files] and other standard script items.
   Its triggered by CurStep == ssInstall in procedure CurStepChanged().
   Workflow: wpReady to Install -> Click Next (Triggers ssInstall) -> wpInstalling
}
procedure DoPreInstall();
begin
  PrepareUnzip();
  UnzipFiles();
end;

procedure Configure();
var
  selectedComponents: String;
  appDirWithSlashes : String; // some servers (e.g. maria) expect linux paths in config files
  php_ini_file : String;
  mariadb_ini_file : String;
begin
  selectedComponents := WizardSelectedComponents(false);

  // StringChange(S,FromStr,ToStr) works on the string S, changing all occurances in S of FromStr to ToStr.
  appDirWithSlashes := appDir;
  StringChange(appDirWithSlashes, '\', '/');

  {
    =============== Inital Setup for Components (post-install commands) ===============
  }

  // MariaDb - install with user ROOT and without password (this is the position to add a default password)
  ExecHidden(appDir + '\bin\mariadb\bin\mysql_install_db.exe --datadir="' + appDir + '\bin\mariadb\data" --default-user=root --password=');

  // MariaDB - initialize mysql tables, e.g. performance_tables
  ExecHidden(appDir + '\bin\mariadb\bin\mysql_upgrade.exe');

  // PostgreSQL - initial setup
  if Pos('postgresql', selectedComponents) > 0 then
  begin
      ExecHidden(appDir + '\bin\pgsql\bin\initdb.exe --username=root --encoding=UTF-8 --pgdata="' + appDir + '\bin\pgsql\data"');
  end;

  if (VCRedist_x64_2015_NeedsInstall() = TRUE) then
  begin
    ExecHidden('cmd.exe /c {tmp}\vcredist_x64.exe /quiet /norestart');
  end;

  {
    =============== Modify Configuration Files ===============
  }

  // config files
  php_ini_file := appDir + '\bin\php\php.ini';
  mariadb_ini_file := appDir + '\bin\mariadb\my.ini';

  // http://dev.mysql.com/doc/refman/5.5/en/server-options.html#option_mysqld_log-error
  // waring: mysqld will not start if backslashes (\) are used. fwd slashes (/) needed!
  SetIniString('mysqld', 'log-error',        appDirWithSlashes + '/logs/mariadb_error.log',  mariadb_ini_file);

  // PHP
  ReplaceStringInFile('error_log = php_error.log',
                      'error_log = ' + appDir + '\logs\php_error.log', php_ini_file);

  ReplaceStringInFile(';upload_tmp_dir =',           'upload_tmp_dir = ' + appDir + '\temp',    php_ini_file);
  ReplaceStringInFile('upload_max_filesize = 2M',    'upload_max_filesize = 8M',                php_ini_file);
  ReplaceStringInFile(';session.save_path = "/tmp"', 'session.save_path = ' + appDir + '\temp', php_ini_file);

  ReplaceStringInFile(';zend_extension=php_opcache.dll',
                      'zend_extension=' + appDir + '\bin\php\ext\php_opcache.dll', php_ini_file);

  if Pos('xdebug', selectedComponents) > 0 then
  begin
      ReplaceStringInFile(';zend_extension=php_xdebug.dll',
                          'zend_extension=' + appDir + '\bin\php\ext\php_xdebug.dll', php_ini_file);
  end;

  if Pos('webgrind', selectedComponents) > 0 then
  begin
	ReplaceStringInFile('xdebug.profiler_enable         = 0', 'xdebug.profiler_enable         = 1', php_ini_file);

    ReplaceStringInFile(';xdebug.profiler_output_dir    = "C:\server\logs"',
                        'xdebug.profiler_output_dir     = "' + appDir + '\logs"', php_ini_file);
  end;

  if Pos('openssl', selectedComponents) > 0 then
  begin
    ReplaceStringInFile(';curl.cainfo =', 'curl.cainfo =' + appDir + '\bin\openssl\ca-bundle.crt', php_ini_file);
    ReplaceStringInFile(';openssl.cafile =', 'openssl.cafile =' + appDir + '\bin\openssl\ca-bundle.crt', php_ini_file);
  end;

  if Pos('mongodb', selectedComponents) > 0 then
  begin
      ReplaceStringInFile(';extension=php_mongo.dll', 'extension=php_mongo.dll', php_ini_file);
  end;
end;

{
  DoPostInstall will be called after Inno has completed installing all of
  the [Files], [Registry] entries, and so forth, and also after all the
  non-postinstall [Run] entries, but before the wpInfoAfter or wpFinished pages.
  Its triggerd by CurStep == ssPostInstall. See procedure CurStepChanged().
  wpInstalling Install finshed -> ssPostInstall
}
procedure DoPostInstall();
begin
  Configure()
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then DoPreInstall();
  if CurStep = ssPostInstall then DoPostInstall();

  // when the wizard finishes, copy the installation logfile from tmp dir to application dir.
  // this allows easier debugging of installation problems. the user can upload or reference parts of the log.
  if CurStep = ssDone then
      filecopy(ExpandConstant('{log}'), ExpandConstant('{app}\logs\') + ExtractFileName(ExpandConstant('{log}')), false);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  // resize only the components page and all controls accordingly
  if CurpageID = wpSelectComponents then
  begin
    SaveComponentsPage(CompPagePositions);
    LoadComponentsPage(CompPagePositions, 250);
    CompPageModified := True;
  end
  else
  if CompPageModified then
  begin
    LoadComponentsPage(CompPagePositions, 0);
    CompPageModified := False;
  end;

  // show custom wpInstalling page with two progress bars.
  if CurPageID=wpInstalling then CustomWpInstallingPage();
end;

{
  Uninstaller

  a) Display Dialogbox
     Warning the user about the deletion of the WPN-XM folder.
     This is ensures no user projects get lost (/www/projects).

  b) Check for running daemon processes before uninstallation.
     Provide Button to shut them down.
     Shutdown is needed, in order to delete them.
}

// boolean function for calling IsModuleLoaded on psvince.dll
function IsModuleLoaded(modulename: AnsiString) : Boolean;
external 'IsModuleLoaded@{app}\bin\tools\psvince.dll stdcall uninstallonly';

function ProcessesRunningWhenUninstall(): Boolean;
var
  index : Integer;
  processes: Array [1..6] of String;
begin
  // fill processes array with process executables to look for
  processes[1] := 'nginx.exe';
  processes[2] := 'memcached.exe';
  processes[3] := 'php-cgi.exe';
  processes[4] := 'mysqld.exe';
  processes[5] := 'mongod.exe';
  processes[6] := 'postgres.exe';

  // method return value defaults to false, meaning that no processes is running
  Result := false;

  // iterate processes
  for index := 1 to 6 do
  begin
    // and check if process is running (using external call to psvince.dll)
    if ( IsModuleLoaded( processes[index] ) = true ) then
    begin
     MsgBox( processes[index] + ' is running, please close it and run again uninstall.', mbError, MB_OK );
     Result := true;
    end;

  end;
end;

function InitializeUninstall(): Boolean;
var
  ErrorCode: Integer;
  ButtonPressed: Integer;
begin
  ButtonPressed := IDRETRY;

  // Check if daemons are running or if the user has pressed the cancel button.
  // We need to perform a check for running daemon processes,
  // because files of running processes can not be deleted while running.
  while ProcessesRunningWhenUninstall and ( ButtonPressed <> IDCANCEL ) do
  begin
    ButtonPressed := MsgBox('Some server processes are still running.'#13#10 +
                            'Click Retry to shut them down and continue uninstallation, or click Cancel to quit the uninstaller.',
                            mbError, MB_RETRYCANCEL );

    if( ButtonPressed = IDRETRY ) then
    begin
      // "Yes/Retry" clicked, now shutdown the processes
      if Exec('cmd.exe', '/c ' + ExpandConstant('{app}\stop.bat'), '', SW_HIDE,
         ewWaitUntilTerminated, ErrorCode) then
      begin
        Result := ErrorCode > 0;
      end;
    end;

    // "Cancel" clicked, quits the un-installer
    if( ButtonPressed = IDCANCEL ) then
    begin
      Result := false;
      Exit;
    end;
  end;

  // unload the dll, otherwise the psvince.dll is not deleted, because in use
  UnloadDLL(ExpandConstant('{app}\bin\tools\psvince.dll'));

  Result := true;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin

  // open uninstall survey in browser on (non-silent) uninstallation
  if (IsUninstaller and not UninstallSilent) then begin
    if (CurUninstallStep = usDone) then begin
          OpenBrowser('http://wpn-xm.org/uninstall-survey.php?version=' + ExpandConstant('{#APP_VERSION}'));
    end;
  end;

  // warn the user, that his working folder is going to be deleted and projects might get lost
  if (CurUninstallStep = usUninstall) then begin
    if MsgBox('***WARNING***'#13#10#13#10 +
        'The WPN-XM installation folder is [ '+ ExpandConstant('{app}') +' ].'#13#10 +
        'You are about to delete this folder and all its subfolders,'#13#10 +
        'including [ '+ ExpandConstant('{app}') +'\www ], which may contain your projects.'#13#10#13#10 +
        'This is your last chance to do a backup of your files.'#13#10#13#10 +
        'Do you want to proceed?'#13#10, mbConfirmation, MB_YESNO) = IDYES
    then begin
      // User clicked: YES

      // fix "read-only" status of all files and folders, else some things might remain after uninstallation
      ExecHidden('cmd.exe /c "attrib -R ' + appDir + '\*.* /s /d"');

      // Deletes the application directory and everything inside it.
      // This function will remove directories that are reparse points,
      // but it will not recursively delete files/directories inside them.
      DelTree(ExpandConstant('{app}'), True, True, True);

      // Removing a path from the environment PATH variable works in 3 steps (see includes/envpath.iss):
      // 1. get the old env var PATH and store it temporarily in oldPath
      SaveOldPathCurrentUser();

    end else begin
      // User clicked: No
      Abort;
    end;
  end;

  // 2. remove paths from the env var PATH 
  if (CurUninstallStep = usPostUninstall) then begin
     RemovePathCurrentUser(appDir + '\bin\php');
     RemovePathCurrentUser(appDir + '\bin\php\ext');
     RemovePathCurrentUser(appDir + '\bin\mariadb\bin');
     RemovePathCurrentUser(appDir + '\bin\git\bin');
     // 3. refresh environment, so that the modified PATH var is activated
     RefreshEnvironment();
  end;
end;