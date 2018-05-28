var stationsDisplayed = [ document.getElementById("current-wind").getAttribute("station") ];
$.ajax({
    url: "https://api.meteotest.ch/flugbasis/v1/wind_10min",
    jsonp: "callback",
    dataType: "jsonp",
    data: {
       format: "json"
    },
     success: function( json ) {
       var output="<div>";
       $.map(json, function(element, i) { $.extend(element, { id: i }); return [element]; })
        .filter(function(element, i, json) { return stationsDisplayed.indexOf(element.id) > -1; })
        .forEach(function(element) {
         output += "<b>" + element.name + "</b></br>" +
           "Windrichtung: " + toEasyReadableDir(element.dd) + " " + element.dd + " &#176;</br>" +
           "Mittel: " + element.ff + " km/h</br>" +
           "Spitzen: " + element.fx + " km/h</br>" +
           "Messzeitpunkt: " + new Date(element.datetime.replace(/ /,"T").replace(/ UTC/,"Z")).toString() + "</br>";
       });
      output+="</div>";
      $( "#wind_current" ).html( output );
    }
});

function toEasyReadableDir( dir ) {
  if( dir > 11.25 && dir <= 33.75) { return "NNE";
  } else if( dir > 33.75 && dir <= 56.25) { return "ENE";
  } else if( dir > 56.25 && dir <= 78.75) { return "E";
  } else if( dir > 78.75 && dir <= 101.25) { return "ESE";
  } else if( dir > 101.25 && dir <= 123.75) { return "ESE";
  } else if( dir > 123.75 && dir <= 146.25) { return "SE";
  } else if( dir > 146.25 && dir <= 168.75) { return "SSE";
  } else if( dir > 168.75 && dir <= 191.25) { return "S";
  } else if( dir > 191.25 && dir <= 213.75) { return "SSW";
  } else if( dir > 213.75 && dir <= 236.25) { return "SW";
  } else if( dir > 236.25 && dir <= 258.75) { return "WSW";
  } else if( dir > 258.75 && dir <= 281.25) { return "W";
  } else if( dir > 281.25 && dir <= 303.75) { return "WNW";
  } else if( dir > 303.75 && dir <= 326.25) { return "NW";
  } else if( dir > 326.25 && dir <= 348.75) { return "NNW";
  } else { return "N"; }
}
