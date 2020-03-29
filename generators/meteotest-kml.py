import json
import urllib2

header="""<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/kml/2.2 https://developers.google.com/kml/schema/kml22gx.xsd">
  <Document id="root_doc">
    <Schema name="Meteotest Stationen" id="meteotest-stations">
      <SimpleField name="timestamp" type="string" />
      <SimpleField name="begin" type="string" />
      <SimpleField name="end" type="string" />
      <SimpleField name="altitudeMode" type="string" />
      <SimpleField name="tessellate" type="int" />
      <SimpleField name="extrude" type="int" />
      <SimpleField name="visibility" type="int" />
      <SimpleField name="drawOrder" type="int" />
      <SimpleField name="icon" type="string" />
    </Schema>
    <Style id="landing-site">
      <IconStyle>
        <scale>0.60</scale>
        <Icon>
          <href>https://api3.geo.admin.ch/color/0,0,128/circle-24@2x.png</href>
          <gx:w>48</gx:w>
          <gx:h>48</gx:h>
        </Icon>
        <hotSpot x="24" y="24" xunits="pixels" yunits="pixels" />
      </IconStyle>
      <LabelStyle>
        <color>ff808080</color>
      </LabelStyle>
    </Style>
    <Folder>
      <name>Meteotest</name>
"""

placemarks=""
data = json.load(urllib2.urlopen('https://api.meteotest.ch/flugbasis/v1/wind_10min'))
for key in data:
  placemarks+="""    <Placemark>
        <name>{name}</name>
        <styleUrl>#landing-site</styleUrl>
        <description>
          <![CDATA[
            <div class="container">
              <div class="wind_current" id="wind_current"></div>
              <div id="wind_history"><img src="https://api.meteotest.ch/flugbasis/v1/windgraph/{id}"/></div>
            </div>
            <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
            <script id="current-wind" station="{id}" src="https://afterglowing.ch/meteotest-client.js"></script>
          ]]>
        </description>
        <Point>
          <coordinates>{lon},{lat}</coordinates>
        </Point>
      </Placemark>
  """.format(id=key.lower(), name=data[key]['name'].encode('utf-8'), lon=data[key]['lon'], lat=data[key]['lat'])

footer="""
    </Folder>
  </Document>
</kml>
"""

print header + placemarks + footer
