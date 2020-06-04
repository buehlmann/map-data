#!/bin/bash

rider_id=<REPLACE_ME>
session=<REPLACE_ME>
number_of_flights_to_fetch=10

sync_flight() {
    uri="https://www.syride.com/scripts/XContest.php?idVol=$1"
    printf "\n\nSyncing flight '$1' ($uri)\n"
    curl "$uri" \
    --compressed \
    -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:76.0) Gecko/20100101 Firefox/76.0' \
    -H 'Accept: */*' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'X-Requested-With: XMLHttpRequest' \
    -H 'Connection: keep-alive' \
    -H "Cookie: instruments2=$session"
}

curl "https://www.syride.com/fichePilote_ajxActivite.php?contentLimit=$number_of_flights_to_fetch&l=en&idRider=$rider_id" \
  --compressed \
  -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:76.0) Gecko/20100101 Firefox/76.0' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-US,en;q=0.5' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'Connection: keep-alive' \
  -H "Cookie: instruments2=$session" | tac - > data

while read line
do
    if [[ "$line" =~ .*showFlight\(\'.+\',([0-9]*),[0-9]*\)\;.+pictoLoupe.* ]]; then
        sync_flight ${BASH_REMATCH[1]}
        ((i++))
    fi
done < data

printf "\n\nSynced $i flights from syride to xcontest\n\n"
