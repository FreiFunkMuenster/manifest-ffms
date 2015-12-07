#!/bin/sh
#
# Usage:
# - sign.sh <SECRET> <FLAVOUR> <VERSION> <BRANCH> <COMMENT>

set -e

SECRET="$1"
FLAVOUR="$2"
VERSION="$3"
BRANCH="$4"
COMMENT="$5"

# Sicherstellen dass wir im Branch master arbeiten  
git checkout master

# Arbeitsverzeichnis aktualisieren 
git pull

# Verzeichnis erstellen falls es nicht existiert 
if [ ! -d "$FLAVOUR" ]; then
  mkdir $FLAVOUR
fi

# Verzeichnis erstellen falls es nicht existiert 
if [ ! -d "$FLAVOUR/$VERSION" ]; then
  mkdir $FLAVOUR/$VERSION
fi

# Manifest-datei herunterladen falls diese noch nicht existiert 
if [ ! -f "$FLAVOUR/$VERSION/$BRANCH.manifest" ]; then
  wget "https://freifunk-muensterland.de/$FLAVOUR/versions/$VERSION/sysupgrade/$BRANCH.manifest" --output-document="$FLAVOUR/$VERSION/$BRANCH.manifest"
fi


# Temp-Dateien erstellen 
upper="$(mktemp)"
lower="$(mktemp)"

trap 'rm -f "$upper" "$lower"' EXIT


# Manifest-Datei aufteilen, nur der Teil oberhalb der Trennzeichen 
# wird für die Signatur verwendet 
# Die beiden Abschnitte der Datei werden in '$upper' und '$lower' gespeichert  
 
awk 'BEGIN   { sep=0 }
     /^---$/ { sep=1; next }
             { if(sep==0) print > "'"$upper"'";
               else       print > "'"$lower"'"}' \
    "$FLAVOUR/$VERSION/$BRANCH.manifest"


# Signatur erstellen und Manifest-Datei mit der neuen Signatur 
# aktualisieren 

ecdsautil sign "$upper" < "$SECRET" >> "$lower"
(
	cat  "$upper"
	echo ---
	cat  "$lower"
) > "$FLAVOUR/$VERSION/$BRANCH.manifest"


# Änderung committen und an den Server zurücksenden
git add $FLAVOUR/$VERSION/$BRANCH.manifest 
git commit -m "Signatur für $FLAVOUR / $VERSION / $BRANCH hinzugefügt $COMMENT"
git push 

