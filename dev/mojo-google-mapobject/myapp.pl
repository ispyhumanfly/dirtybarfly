#!/usr/bin/env perl

use Mojolicious::Lite;

use Geo::Google::MapObject;

my $map = Geo::Google::MapObject->new(
    key => 'ABQFbHAATHwok56Qe3MBtg0s7lgkHBS9HKneet7v0OIFhIwnBhTEGCHLTRRRBa_lUOCy1fDamS5PQt8qULYfYQ',
    zoom => 13,
    size => '512x400',
    maptype => 'terrain',
    markers=>
    [
            {
                    location=>'51.242844,0.011716',
                    color=>'green',
                    label=>'P',
                    title=>'Periapt Technologies',
                    href=>'http://www.periapt.co.uk'
            },
            {
                    location=>'51.243757,0.006051',
                    color=>'red',
                    label=>'C',
                    title=>'Crown Roast Butchers',
                    href=>'http://www.crownroast.co.uk/'
            },
    ]
);

get '/' => 'index';

get '/:groovy' => sub {
    my $self = shift;
    $self->render(text => $self->param('groovy'), layout => 'funky');
};

app->start;
__DATA__

@@ index.html.ep
% layout 'maps';
<!-- This div will be completely replaced by the Google API and is identified by #map_canvas. -->
<div id="map_canvas">

<!-- This image will be loaded by the static Google map API. It will be available whilst the
        javascript based map is loading and if javascript is turned off
-->
<div><img
        alt="Test map"
        src="<%= $maps->static_map_url() %>"
        width="<%= $maps->width() %>>"
        height="<%= $maps->height() %>>"
        />
</div>

</div> <!-- end of #map_canvas -->

@@ layouts/maps.html.ep
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>Geo::Google::MapObject Demo</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="Google Map" />
<link rel="stylesheet" href="./style.css" type="text/css" media="screen, projection" title="Normal" />
<link rel="stylesheet" href="./print.css" type="text/css" media="print" />
<script type="text/javascript" src="<%= $maps->javascript_url() %>"></script>
<!-- This way we tell the javascript what URL to contact the server with. -->
<link href="<%= url_for('json') %>" id="get_init_data"/>
<!-- This will load the yui API. If you use a different javascript API this would obviously change. -->
      <script type="text/javascript" src="http://yui.yahooapis.com/2.8.0r4/build/yahoo-dom-event/yahoo-dom-event.js"></script>
      <script type="text/javascript" src="http://yui.yahooapis.com/2.8.0r4/build/connection/connection.js"></script>
      <script type="text/javascript" src="http://yui.yahooapis.com/2.8.0r4/build/json/json-min.js"></script>
<!-- This loads our javascript code. -->
<script type="text/javascript" src="<%= url_for('maps_js') %>"></script>
</head>
<body>
<h1>Insurgent Software's Google Maps Demon</h1>
<%== content %>

</body>
</html>

