function mapInitialize() {

      /* Read the "link" element that tells us how to contact the server. See markup above. */
      var get_init_data = YAHOO.util.Dom.get('get_init_data').href;

      /* Build the AJAX callback object consisting of three parts.  */
      var callback =
      {

          /* Part I: Function called in the event of a successful call. */
          success: function(o) {

                /* Convert the JSON response into a javascript object.
                   This structure corresponds to the Geo::Google::MapObject in perl
                   as intermediated by its "json" method.
                 */
                var data = YAHOO.lang.JSON.parse(o.responseText);

                if (GBrowserIsCompatible()) {

                        /* Build up the Map object which will replace #map_canvas in the above markup. */
                        var mapopt = {};
                        if (data.size) {
                                mapopt.size = new GSize(parseInt(data.size.width), parseInt(data.size.height));
                        }
                        var markers = data.markers;
                        var map = new GMap2(YAHOO.util.Dom.get("map_canvas"), mapopt);
                        var maptype = null;
                        if (data.maptype) {
                                maptype = o.argument[parseInt(data.maptype)];
                        }
                        var zoom = null;
                        if (data.zoom) {
                                zoom = parseInt(data.zoom);
                        }
                        var center = markers[0].location;
                        if (data.center) {
                                center = data.center;
                        }
                        map.setCenter(GLatLng.fromUrlValue(center), zoom, maptype);
                        map.setUIToDefault();

                        /* Now for each marker build and add a GMarker object */
                        for(var i = 0; i < markers.length; i++) {
        
                                var opt = {title: markers[i].title};
                                if (!markers[i].href) {
                                        opt.clickable = false;
                                }
                                if (markers[i].icon) {
                                        opt.icon = new GIcon(G_DEFAULT_ICON, markers[i].icon);
                                        if (markers[i].shadow) {
                                                opt.icon.shadow = markers[i].shadow;
                                        }
                                }
                                var mark = new GMarker(GLatLng.fromUrlValue(markers[i].location), opt);
                                if (markers[i].href) {
                                        mark.href = markers[i].href;
                                        GEvent.addListener(mark, "click", function(){window.location=this.href;});
                                }
                                map.addOverlay(mark);
                        }
                }
          },  /* End of Part I */

          /* Part II: Function called in the event of failure */
          failure: function(o) {alert(o.statusText);},

          /* Part III: Data that is passed to the success function.
             We are using this to map from numerical maptypes that Geo::Google::MapObject has passed us to the 
             forms used in Google maps API. 
           */
          argument: [G_NORMAL_MAP, G_SATELLITE_MAP, G_PHYSICAL_MAP, G_HYBRID_MAP]

      }; /* End of constructing the AJAX callback object. */

      /* This calls the server which should hopefully kick off callback.success with lots of lovely data. */
      var transaction = YAHOO.util.Connect.asyncRequest('GET', get_init_data, callback, null);

  } /* end of mapInitialize function */

  /* This will make sure that we call the above function at a good time. */
  YAHOO.util.Event.onDOMReady(mapInitialize);

  /* We still have to do the memory cleanup ourselves. */
  YAHOO.util.Event.addListener(window, 'unload', 'GUnload');
