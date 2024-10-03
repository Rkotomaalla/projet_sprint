@echo off
setlocal

:: Répertoires
:: Tous les fichiers .java sont temporairement stockés ici
set TEMP_SRC=temp_src
:: Tous les fichiers .class seront stockés ici
set MY_CLASSES=classes

:: Création du répertoire temporaire pour les sources
:: Vérifier si le répertoire de destination existe
if exist "%TEMP_SRC%" (
    echo Le répertoire de destination existe déjà. Suppression en cours...
    rmdir /s /q "%TEMP_SRC%"
    echo Répertoire de destination supprimé avec succès.
)
mkdir "%TEMP_SRC%"
echo Répertoire temporaire pour les sources créé.

:: Création du répertoire temporaire pour les .class
:: Vérifier si le répertoire de destination existe
if exist "%MY_CLASSES%" (
    echo Le répertoire de destination existe déjà. Suppression en cours...
    rmdir /s /q "%MY_CLASSES%"
    echo Répertoire de destination supprimé avec succès.
)
mkdir "%MY_CLASSES%"
echo Répertoire temporaire pour les .class créé.

:: Copie de tous les fichiers .java de src vers TEMP_SRC
:: La commande forfiles pourrait être utilisée pour rechercher des fichiers dans un répertoire et les copier
for /r "src" %%f in (*.java) do (
    copy "%%f" "%TEMP_SRC%"
)
echo Fichiers .java copiés dans le répertoire temporaire.

:: Compilation des fichiers Java du répertoire TEMP_SRC vers MY_CLASSES
:: Assurez-vous que le chemin vers javac est correctement défini dans votre environnement
javac -cp "lib\*" -d "%MY_CLASSES%" "%TEMP_SRC%\*.java"
echo Fichiers Java compilés dans le répertoire classes.

:: Création du fichier JAR dans le répertoire lib
:: L'option -C de jar permet de spécifier un répertoire source différent pour les fichiers .class
:: Assurez-vous que le chemin vers jar est correctement défini dans votre environnement
jar cf "lib\front-controller.jar" -C "%MY_CLASSES%" .
echo Fichier JAR créé avec succès.

:: Nettoyage du répertoire temporaire des sources
:: Vous pouvez commenter ou retirer cette partie si vous souhaitez conserver les sources
echo Nettoyage du répertoire temporaire des sources...
rmdir /s /q "%TEMP_SRC%"
echo Nettoyage terminé.

echo Processus terminé.