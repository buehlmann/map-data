#!/bin/bash

set_name() { xmlstarlet ed -L -N "ns=http://www.opengis.net/kml/2.2" -u "/ns:kml/ns:Folder/ns:name" -x "concat('$1', substring-after(/ns:kml/ns:Folder/ns:name/text(), 'Flyland Daten'))" $2; }

dismiss_unchanged_layers() {
    git diff --stat generated > diff
    set -x
    while read line
    do
        if [[ "$line" =~ ^(generated\/.*kml)( *\| *)([0-9]+).* ]]; then
            [[ "${BASH_REMATCH[3]}" == 2 ]] && git checkout "${BASH_REMATCH[1]}"
        fi
    done < diff
    set +x
}

curl 'http://www.flyland.ch/fl_php/fl_php_Downloader.php?case=1001' --compressed -s \
    -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:74.0) Gecko/20100101 Firefox/74.0' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Origin: http://www.flyland.ch'  \
    -H 'Referer: http://www.flyland.ch/disclamer.php?case=1001' \
    --data 'cbAkzeptieren=on' \ > raw.kml

xmlstarlet sel -N "ns=http://www.opengis.net/kml/2.2" -t -v "/ns:kml/ns:Folder/ns:Folder/ns:name/." raw.kml | sort > generated/_layers-available.log; cat generated/_layers-available.log
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

set_name "An- Abflug" "generated/anabflug.kml"
set_name "Sonderregeln" "generated/sonderregelung.kml"
set_name "Hindernisse" "generated/hindernisse.kml"
set_name "CTR" "generated/ctr.kml"
set_name "TMA" "generated/tma.kml"
set_name "LS-D" "generated/lsd.kml"
set_name "LS-R" "generated/lsr.kml"
set_name "Startplaetze" "generated/startplaetze.kml"
set_name "Landeplaetze" "generated/landeplaetze.kml"
set_name "Gefahren" "generated/gefahrengebiete.kml"
set_name "Wildschutz" "generated/wildschutzzonen.kml"

dismiss_unchanged_layers

rm -rf raw.kml diff
