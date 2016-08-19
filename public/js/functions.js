// leadpages_input_data variables come from the template.json "variables" section
var leadpages_input_data = {};
var geocoder,
	map,
	loc,
	address,
	addressLine = "";

function initialize() {
	geocoder = new google.maps.Geocoder();

	geocoder.geocode( { 'address': address}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			loc = results[0].geometry.location;

			var mapOptions = {
				zoom: 17,
				center: loc,
				scrollwheel: false,
                overviewMapControl: true,
                draggable: true,
				scaleControlOptions: true,
				streetViewControl: true,
				zoomControl: true,
				rotateControl: true,
				panControl: true,
				disableDoubleClickZoom: true,
                mapTypeControl: false,
				streetViewControl: false
			};

			map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);

			var marker = new google.maps.Marker({
				position: loc,
				map: map
			});

			google.maps.event.addDomListener(window, 'resize', function() {
				map.setCenter(loc);
			});
		} else {
			alert("Your map will not display correctly for the following reason: " + status);
		}
	});
}

function loadScript() {
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyD9jIO8oPRow4tcVlSmjJ2KV49im-2X4eo&sensor=false&' +
      'callback=initialize';
  document.body.appendChild(script);
}

$(function () {
    $('.header-nav a').each(function() {
        if ($(this).attr('href').substring(0,1) == "#")
            $(this).smoothScroll();
    });

    $(document).ready(function() {
	    if ( typeof window.top.App === 'undefined' ) {
	        // Published page
	        addressLine = LeadPageData['googleMapAddress']['value'];
	    } else {
	        addressLine = "251 N 1st Ave, Minneapolis, MN 55401";
	    }

        if (addressLine != "")
            address = addressLine.replace(/<[^>]*>/g, "");
        else
            address = "251 N 1st Ave, Minneapolis, MN 55401";

    	loadScript();
    });
});


