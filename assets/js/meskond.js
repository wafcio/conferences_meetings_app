function initMap(data) {
  var myLatLng = {
    lat: 53.5775,
    lng: 23.106111
  };

  var map = new google.maps.Map(document.getElementById('map'), {
    center: myLatLng,
    scrollwheel: false,
    zoom: 4
  });

  var markers = [];

  $.each(data, function(index, value) {
    markers.push(new google.maps.Marker({
      map: map,
      position: {
        lat: value.lat,
        lng: value.lng
      },
      title: value.conference
    }));
  });
}
