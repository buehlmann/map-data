#!/bin/bash
xmlstarlet sel -N "ns=http://www.opengis.net/kml/2.2" -t -v "/ns:kml/ns:Folder/ns:Folder/ns:name/." raw.kml | sort > generated/_layers-available.log
cat generated/_layers-available.log
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(contains(text(),'Sonderregelung'))]/.." raw.kml > generated/sonderregelung.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(contains(text(),'Hindernisse'))]/.." raw.kml > generated/hindernisse.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(contains(text(),'CTR'))]/.." raw.kml > generated/ctr.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(contains(text(),'TMA'))]/.." raw.kml > generated/tma.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(contains(text(),'DANGER'))]/.." raw.kml > generated/lsd.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(contains(text(),'RESTRICTED'))]/.." raw.kml > generated/lsr.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(text()='Anflug' or text()='Abflug')]/.." raw.kml > generated/anabflug.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(text()='Startplaetze')]/.." raw.kml > generated/startplaetze.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(text()='Landeplaetze')]/.." raw.kml > generated/landeplaetze.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(text()='Gefahrengebiete')]/.." raw.kml > generated/gefahrengebiete.kml
xmlstarlet ed -N "ns=http://www.opengis.net/kml/2.2" -d "/ns:kml/ns:Folder/ns:Folder/ns:name[not(text()='Wildschutzzonen')]/.." raw.kml > generated/wildschutzzonen.kml
