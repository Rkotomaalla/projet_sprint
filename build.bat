
@rem DEPLOUEMENT PAR SCRIPT ...

@echo off
rem variables 
set "name_webapp=sprint0"
set "name_webapp=name_webapp"
set "TOMCAT_PATH=C:\Program Files\Apache Software Foundation\Tomcat 10.1"
set "WORK_PATH=D:\S5\Mr Naina\Sprint\%name_webapp%"
set "CATALINA_HOME=%TOMCAT_PATH%"
set "TOMCAT_PORT=8080"


rem DELETE temp
set "path_TEMP=%WORK_PATH%\temp"
pushd %path_TEMP:~0,3% 
if exist "%path_TEMP%" rmdir /S /Q "%path_TEMP%"

popd

rem RECREER temp
echo CREATION DOSSIER temp ...
mkdir "%path_TEMP%" 
mkdir "%path_TEMP%\WEB-INF"
mkdir "%path_TEMP%\WEB-INF\lib"
mkdir "%path_TEMP%\WEB-INF\views"


rem COPIER Dans TEMP les View et Models
echo Copie Views Dans Temp
if  exist "%WORK_PATH%\src\views" xcopy "%WORK_PATH%\src\views"  "%path_TEMP%\WEB-INF\views" /E /H /C /I


echo Copie Models dans Temp
rem COPIER Dans TEMP les  Models
if  exist "%WORK_PATH%\src\models" xcopy "%WORK_PATH%\src\models"  "%path_TEMP%\WEB-INF" /E /H /C /I


rem COPY web.xml
if not exist "%WORK_PATH%\src\web.xml" (
    echo VOUS DEVEZ CONFIGURER web.xml ds src ...
    pause
    exit
) else (
    copy "%WORK_PATH%\src\web.xml" "%path_TEMP%\WEB-INF\"
)




rem COPY *.jar
xcopy "%WORK_PATH%\lib\*" "%path_TEMP%\WEB-INF\lib\" /s /y

rem COMPILATION
echo COMPILE [en cours...]
if exist "%WORK_PATH%\bin" rmdir /S /Q "%WORK_PATH%\bin"
mkdir "%WORK_PATH%\bin"
setlocal EnableDelayedExpansion


@REM for /D %%d in ("%WORK_PATH%\src\*") do (
@REM     set "nom=%%~nxd"
@REM     javac -cp lib/* -d bin src/!nom!/*.java
@REM     echo "EFA ATOO OOOOOOOOOOOOO"
@REM )
@REM Compilation des code

    javac -cp lib/* -d bin src/*.java

echo COMPILE [terminer]

rem MOVE *.class et les packages
xcopy "%WORK_PATH%\bin\*" "%path_TEMP%\WEB-INF\classes\" /e /y

rem CONFIGURER WEB-INF
if exist "%WORK_PATH%\web\WEB-INF" rmdir /S /Q "%WORK_PATH%\web\WEB-INF"
xcopy "%path_TEMP%\*" "%WORK_PATH%\web\" /e /y
rmdir /S /Q "%path_TEMP%\WEB-INF"

rem COMPRESSE (fichier war)
cd /d "%WORK_PATH%\web"

rem verification TOMCAT

rem Vérifier si Tomcat écoute sur le port spécifié
netstat -ano | findstr /c:":%TOMCAT_PORT%" > nul
@REM if errorlevel 1 (
    call "%TOMCAT_PATH%\bin\startup.bat"
    echo "TOMCAT started"
    timeout /t 5 /nobreak
@REM )

rem METTOYAGE webapps [tomcat]
if exist "%TOMCAT_PATH%\webapps\%name_webapp%.war" del "%TOMCAT_PATH%\webapps\%name_webapp%.war"
if exist "%TOMCAT_PATH%\webapps\%name_webapp%" rmdir /S /Q "%TOMCAT_PATH%\webapps\%name_webapp%"

@REM copy "%projectPath%\error.jsp" "%destinationDir%\" 
copy "%WORK_PATH%\%name_webapp%\error.jsp" "%TOMCAT_PATH%\webapps\%name_webapp%" 
rem DEPLOIEMENT 
jar -cvf "%TOMCAT_PATH%\webapps\%name_webapp%.war" *

pause