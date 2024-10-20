.oepnvpoi[type='parking'][zoom>=17]
{
    point-file:url('img/oepnv_parking.svg');
    point-allow-overlap:false;
}
.oepnvpoi[type='taxi'][zoom>=14]{
    point-file:url('img/oepnv_taxi.svg');
    point-allow-overlap:false;
}
.oepnvpoi[type='car_rental'][zoom>=15]{
    point-file:url('img/oepnv_rental_car.svg');
    point-allow-overlap:false;
}
.oepnvpoi[type='bicycle_rental'][zoom>=15]{
    point-file:url('img/oepnv_rental_bicycle.svg');
    point-allow-overlap:false;
}
.oepnvpoi[type='car_sharing'][zoom>=16]{
    point-file:url('img/oepnv_car_share.svg');
    point-allow-overlap:false;
}

.airport[type='int_airport'][zoom>=4]{
    point-file:url('img/oepnv_airport.svg');
    point-allow-overlap:false;
}
.airport[type='int_airport'][zoom>=8]{
  	text-name: "[name]";
    text-fill: #004e75;
    text-placement: point;
    text-wrap-width: 65;    
    text-min-distance: 10;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-size: 10;
    text-dy: -14;
}
.airport[type='cont_airport'][zoom>=7]{
    point-file:url('img/oepnv_airport.svg');
    point-allow-overlap:false;
}
.airport[type='cont_airport'][zoom>=10]{
  	text-name: "[name]";
    text-fill: #004e75;
    text-placement: point;
    text-wrap-width: 65;    
    text-min-distance: 10;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-size: 10;
    text-dy: -14;
}
.airport[type='reg_airport'][zoom>=11]{
    point-file:url('img/oepnv_airport.svg');
    point-allow-overlap:false;
}
.airport[type='reg_airport'][zoom>=12]{
  	text-name: "[name]";
    text-fill: #004e75;
    text-placement: point;
    text-wrap-width: 65;    
    text-min-distance: 10;
    text-face-name: @bold-fonts;
    text-halo-radius: 1;
    text-size: 10;
    text-dy: -14;
}
.airport[type='airport'][zoom>=15]{
    point-file:url('img/oepnv_airport.svg');
    point-allow-overlap:false;
}
