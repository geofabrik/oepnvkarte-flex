@rail: #FF9C00;
@light_rail: #00FF00;
@tram: #0000FF;
@subway: #000088;
@trolleybus: #880000;
@bus: #FF0000;
@ferry: #880088;

.transport.line
{
    [type="rail"]{
      line-cap: round;
      line-join: miter;
      opacity: 0.8;
      line-width: 1;
      line-color: @rail;
      [zoom>=6]{
        line-width: 2;
      }
    }
    [type!="bus"]{
      [zoom>=10]{
        line-cap: round;
        line-join: miter;
	      opacity: 0.8;
        line-width: 3;
        line-color: #606000;
        [type="rail"]{line-color:@rail;}
        [type="light_rail"]{line-color:@light_rail;}
        [type="tram"]{line-color:@tram;}
        [type="subway"]{line-color:@subway;}
        [type="trolleybus"]{line-color:@trolleybus;}
        [type="ferry"]{line-color:@ferry;}

      }
      [zoom>=12]{line-width: 5;}
      [zoom>=14]{line-width: 8;}
      [zoom>=16]{line-width: 10;} 
    }
    [type="ferry"]{
      [zoom>=9]{
        line-cap: round;
        line-join: miter;
	      opacity: 0.8;
        line-width: 2;
        line-color:@ferry;
      }
      [zoom>=14]{
        line-width: 3;
      }
    }
    [type="bus"]{
      [zoom>=11]{
        line-cap: round;
        line-join: miter;
	      opacity: 0.8;
        line-width: 1;
        line-color:@bus;
      }
      [zoom>=12]{line-width: 2;}
      [zoom>=13]{line-width: 3;}
      [zoom>=14]{line-width: 4;}
      [zoom>=16]{line-width: 10;} 
    }
    [role="forward"][zoom>=16]{line-pattern-file: url('img/forward-10.png');}
    [role="backward"][zoom>=16]{line-pattern-file: url('img/backward-10.png');}
}

.transport.label{
  [type="rail"][zoom>=6][zoom<=11]{
    text-name: "[refs]";
    text-placement: line;
    text-halo-radius: 2;
    text-halo-fill: rgba(255,255,255,0.7);
    text-max-char-angle-delta: 20;
    text-min-distance: 10;
    text-spacing: 60;
    text-face-name: @book-fonts;
    text-size: 6;	
    text-fill: @rail;
  }
  [type!="bus"]{
    [zoom>=12]{
      text-name: "[refs]";
      text-placement: line;
      text-halo-radius: 2;
      text-halo-fill:rgba(255,255,255,0.7);
      text-max-char-angle-delta: 20;
      text-min-distance: 10;
      text-spacing: 60;
	    text-face-name: @book-fonts;
      text-fill: #606000;
      text-size: 8;	
      [type="rail"]{text-fill:@rail;}
      [type="light_rail"]{text-fill:@light_rail;}
      [type="tram"]{text-fill:@tram;}
      [type="subway"]{text-fill:@subway;}
      [type="trolleybus"]{text-fill:@trolleybus;}
      [type="ferry"]{text-fill:@ferry;}
    }
    [zoom>=14]{text-size: 8;}
    [zoom>=16]{text-size: 10;}
  }
  [type="bus"]{
    [zoom>=14]{
      text-name: "[refs]";
      text-placement: line;
      text-halo-radius: 2;
      text-halo-fill:rgba(255,255,255,0.7);
      text-max-char-angle-delta: 20;
      text-min-distance: 10;
      text-spacing: 60;
	    text-face-name: @book-fonts;
      text-fill: @bus;
      text-size: 8;
    }
    [zoom>=16]{text-size: 10;}
  }
}






.station.point[type!="bus"][zoom=13]
{
    point-file: url('img/station_small.svg');
    point-ignore-placement: true

}
.station.point[type!="bus"][zoom=14]
{
    point-file: url('img/station_small.svg');
    point-ignore-placement: true

}
.station.point[type="bus"][zoom>=13][zoom<=14]
{
    point-file: url('img/busstop_small.svg');
    point-ignore-placement: true

}

.station.point[zoom>=15][zoom<=16]
{
    point-file: url('img/station.svg');
    point-ignore-placement: true
}
.station.point[type="bus"][zoom>=15][zoom<=16]
{
    point-file: url('img/busstop.svg');
  point-ignore-placement: true
}

.station.point
{

}
.station.point[zoom>=13][zoom<=14][type="rail"]
{
    text-name: "[name]";
    text-halo-radius: 1;
    text-face-name: @bold-fonts;
    text-wrap-width: 80;
    text-fill: #000;
    text-placement: point;
      text-placement-type: simple;
  text-placements: "E,W,N,S";
/*	text-anchorx:-1;
	text-anchory:-1;
*/	text-margin:10;
	text-dx:3;
	text-dy:3;
}
.station.point[zoom>=15] ,
{
    text-name: "[name]";
    text-halo-radius: 1;
    text-face-name: @bold-fonts;
    text-wrap-width: 80;
    text-fill: #000;
    text-placement: point;
    text-placement-type: simple;
  text-placements: "E,W,N,S";
/*	text-anchorx:-1;
	text-anchory:-1;
*/	text-margin:10;
	text-dx:6;
	text-dy:6;
}
.station.point[zoom>=17] 
{
    text-halo-radius: 2;
}

.station.point[type="rail"][zoom=13] {text-name: "[name]";text-size: 8;text-margin: 20;}
.station.point[type="rail"][zoom=14] {text-name: "[name]";text-size: 10;}
.station.point[type="rail"][zoom=15] {text-name: "[name]";text-size: 12;}
.station.point[type="rail"][zoom=16] {text-name: "[name]";text-size: 13;}
.station.point[type="rail"][zoom=17] {text-name: "[name]";text-size: 14;}
.station.point[type="rail"][zoom>=18] {text-name: "[name]";text-size: 15;}
/*.station.point[type!="rail"][type!="bus"][zoom=13] {text-name: "[name]";text-size: 8;}*/
/*.station.point[type!="rail"][type!="bus"][zoom=14] {text-name: "[name]";text-size: 9;}*/
.station.point[type!="rail"][type!="bus"][zoom=15] {text-name: "[name]";text-size: 10;}
.station.point[type!="rail"][type!="bus"][zoom=16] {text-name: "[name]";text-size: 10;}
.station.point[type!="rail"][type!="bus"][zoom=17] {text-name: "[name]";text-size: 12;}
.station.point[type!="rail"][type!="bus"][zoom>=18] {text-name: "[name]";text-size: 13;}
.station.point[type="bus"][zoom=15] {text-name: "[name]";text-size: 9;}
.station.point[type="bus"][zoom=16] {text-name: "[name]";text-size: 10;}
.station.point[type="bus"][zoom=17] {text-name: "[name]";text-size: 12;}
.station.point[type="bus"][zoom>=18] {text-name: "[name]";text-size: 12;}

.station.point[zoom>=17] 
{
    text-name: "[name]";
    text-halo-radius: 2;
/*	text-anchorx:0.5;
	text-anchory:0.5;
*/}

.stationarea.big[zoom=16]
{
    polygon-fill: #FFFF00;
	polygon-opacity: 0.45;
}
.stationarea.all[zoom>=17]
{
    polygon-fill: #FFFF00;
	polygon-opacity: 0.35;
}

.platform.geom["mapnik::geometry_type"=linestring][zoom>=17]
{
    ::outline{
      line-color: #000;
      line-width:9;
      line-cap: round;
      line-join: miter;
    }
	line-color: #FFF;
	line-width:7;
    line-cap: round;
    line-join: miter;
}
.platform.geom["mapnik::geometry_type"=point][zoom>=17]
{
    point-file: url('img/station.svg');
    point-ignore-placement: true;
}
.platform.geom[type="bus"]["mapnik::geometry_type"=point][zoom>=17],
.platform.geom[type="undefined"]["mapnik::geometry_type"=point][zoom>=17]
{
    point-file: url('img/busstop.svg');
    point-ignore-placement: true;
}

.platform.label[zoom>=17] 
{
    text-name: "[ref]";
	  text-size:8;
    text-halo-radius: 1;
    text-face-name: @bold-fonts;
    text-wrap-width: 80;
    text-fill: #000;
    text-placement: point;
/*	text-anchorx:-1;
	text-anchory:-1;
*/	text-dx:5;
	text-dy:5;
}

.platform.geom["mapnik::geometry_type"=polygon][zoom>=17]
{
    polygon-fill: #FFFFFF;
	line-color: #000;
	line-width:1;
}
.platform.label["mapnik::geometry_type"=polygon][zoom>=17]
{
    text-name: "[ref]";
  	text-size:8;
    text-halo-radius: 1;
    text-face-name: @bold-fonts;
    text-wrap-width: 80;
    text-fill: #000;
    text-placement: point;
/*	text-anchorx:-1;
	text-anchory:-1;
*/}


