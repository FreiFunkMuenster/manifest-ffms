# Autoupdater Signaturen für die Firmware von Freifunk Münsterland

In diesem Repository werden die Autoupdater-Signaturen für die Firmware Versionen 
gesammelt. 
Die einzelnen Firmware-Stände müssen von den Einzelnen Entwicklern für die Freigabestufen 
'Beta' und 'Stable' jeweils selektiv signiert werden.  

# Vorbereitungen 

  * Auf dem lokalen Rechner muss das Tool 'ecdsautil' (https://github.com/tcatm/ecdsautils) installiert werden.
  * Auf dem lokalen Rechner muss der geheime Schlüssel als Datei gespeichert sein (Anleitung zm Erstellen: https://github.com/tcatm/ecdsautils#generate-key) 
  * Dieses Repository muss auf dem lokalen Rechner mittels git geclont werden.

# Signierung 

Für die Erstellung einer Signatur wird das Script 'sign.sh <SECRET> <VERSION> <BRANCH> <COMMENT>' aus diesem Repository verwendet werden. 
Das Script lädt, sofern erforderlich, die entsprechende Manifest Datei von dem Webserver herunter.
Durch das Script wird anschließend die Signatur der Manifest-Datei hinzugefügt und in das Repository committed. 
Abschließend wird durch das Script automatisch ein 'git push' ausgeführt.    

## Beispiel 

Signierung der Version 111 für Stable der Variante(Domäne) site-ffms 

'sign.sh ~/my-secret-key site-ffms 111 stable "just a sample" 

## Liste der Parameter 

  * <SECRET>  - Datei mit dem gemeimen Schlüssel 
  * <FLAVOUR> - Firmware-Variante bzw. Domäne 
  * <VERSION> - Versionsnummer, die signiert werden soll  
  * <BRANCH>  - Branch, der signiert werden soll 
  * <COMMENT> - Optionaler commit 


