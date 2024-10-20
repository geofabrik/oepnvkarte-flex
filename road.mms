/********************
* Gemeinsamkeiten
*********************/

//transparent layer is drawn first
.way[type="primary"][zoom>=8][zoom<=10] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 1; }
.way[type="residential"][zoom>=10][zoom<=13] ::transparent{ line-join: miter;line-cap: round;line-color:#909090;opacity: 0.37;line-width: 1; }
.way[type="residential"][zoom=14] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 2; }
.way[type="track"][zoom=15] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 3; }
.way[type="track"][zoom=16] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 6; }
.way[type="track"][zoom>=17] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 8; }

.way
{
	/*tunnel*/
	[tunnel="true"][zoom>=15]::outline{line-width:0;line-cap:butt;line-dasharray: 3, 3;}

 	/********************
	* Autobahnen
	*********************/
 	[type="motorway"]{
		/*Farben*/
		::outline{
   		[zoom>=8] { 
        line-color: #6d6d6d;
        line-width: 4; 
        line-cap: round;
        line-join: miter;
	      .bridge{
        	line-cap: butt;
        }
      }
			[zoom=13] { line-width: 7; }
			[zoom=14] { line-width: 9; }
			[zoom=15] { line-width: 13; }
			[zoom=16] { line-width: 17; }
			[zoom>=17] { line-width: 19; }
    }
 		[zoom>=8] {
      line-color: #dddddd;
      line-width: 2; 
      line-cap: round;
      line-join: miter;
    }
 		[zoom=13] { line-width: 5; }
		[zoom=14] { line-width: 7; }
		[zoom=15] { line-width: 11; }
		[zoom=16] { line-width: 14; }
		[zoom>=17] { line-width: 15; }
  }

  /********************
   * Autobahnauffahrten
   *********************/
  [type="motorway_link"]{
    ::outline{
      [zoom>=13]{
        line-join: miter;
        line-color: #6d6d6d;
        line-width: 4;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=15] { line-width: 6; }
      [zoom>=16] { line-width: 10; }
      [zoom>=17] { line-width: 12; }
    }
    [zoom>=13]{
      line-join: miter;
      line-color: #dddddd;
      line-width: 2;
      line-cap: round;
    }
    [zoom>=15] { line-width: 4; }
    [zoom>=16] { line-width: 8; }
    [zoom>=17] { line-width: 10; }
  }

  /********************
  * Autobahn-aehliche
  *********************/
  [type="trunk"]{
    ::outline{
      [zoom>=11]{
        line-join: miter;
        line-color: #a1968b;
        line-width: 4;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=13] { line-width: 7; }
      [zoom>=14] { line-width: 9; }
      [zoom>=15] { line-width: 13; }
      [zoom>=16] { line-width: 15; }
      [zoom>=17] { line-width: 17; }
    }
  /*TODO like primary rendering in lowzoom?*/
    [zoom>=11]{
      line-join: miter;
      line-color: #dddddd;
      line-width: 2;
      line-cap: round;
    }
    [zoom>=13] { line-width: 5; }
    [zoom>=14] { line-width: 7; }
    [zoom>=15] { line-width: 11; }
    [zoom>=16] { line-width: 13; }
    [zoom>=17] { line-width: 15; }
  }

  /********************
  * Autobahn-aehnlich auffahrten
  *********************/
  [type="trunk_link"]{
    ::outline{
      [zoom>=13]{
        line-join: miter;
        line-color: #a1968b;
        line-width: 4;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=15] { line-width: 6; }
      [zoom>=16] { line-width: 10; }
      [zoom>=17] { line-width: 12; }
    }
    [zoom>=13]{
      line-join: miter;
      line-color: #dddddd;
      line-width: 2;
      line-cap: round;
    }
    [zoom>=15] { line-width: 4; }
    [zoom>=16] { line-width: 8; }
    [zoom>=17] { line-width: 10; }
  }


  /********************
  * Bundesstrassen
  *********************/

  [type="primary"]{
    ::outline{
      [zoom>=11]{
        line-join: miter;
        line-color: #a1968b;
        line-width: 4;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=13] { line-width: 7; }
      [zoom>=14] { line-width: 9; }
      [zoom>=15] { line-width: 13; }
      [zoom>=16] { line-width: 15; }
      [zoom>=17] { line-width: 17; }
    }
    [zoom>=8][zoom<=10] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 1; }
    [zoom>=11]{
      line-join: miter;
      line-color: #dddddd;
      line-width: 2;
      line-cap: round;
    }
    [zoom>=13] { line-width: 5; }
    [zoom>=14] { line-width: 7; }
    [zoom>=15] { line-width: 11; }
    [zoom>=16] { line-width: 13; }
    [zoom>=17] { line-width: 15; }
  }


  /********************
  * Bundesstrassen auffahrt
  *********************/
  [type="primary_link"]{
    ::outline{
      [zoom>=13]{
        line-join: miter;
        line-color: #a1968b;
        line-width: 4;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=15] { line-width: 6; }
      [zoom>=16] { line-width: 10; }
      [zoom>=17] { line-width: 12; }
    }
    [zoom>=13]{
      line-join: miter;
      line-color: #dddddd;
      line-width: 2;
      line-cap: round;
    }
    [zoom>=15] { line-width: 4; }
    [zoom>=16] { line-width: 8; }
    [zoom>=17] { line-width: 10; }
  }

  /********************
  * Landstrassen 
  *********************/

  [type="secondary"]{
    ::outline{
      [zoom>=11]{
        line-join: miter;
        line-color: #a5a880;
        line-width: 4;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=13] { line-width: 7; }
      [zoom>=14] { line-width: 9; }
      [zoom>=15] { line-width: 13; }
      [zoom>=16] { line-width: 15; }
      [zoom>=17] { line-width: 17; }
    }
    [zoom>=8][zoom<=10] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 1; }
    [zoom>=11]{
      line-join: miter;
      line-color: #dddddd;
      line-width: 2;
      line-cap: round;
    }
    [zoom>=13] { line-width: 5; }
    [zoom>=14] { line-width: 7; }
    [zoom>=15] { line-width: 11; }
    [zoom>=16] { line-width: 13; }
    [zoom>=17] { line-width: 15; }
  }



  /********************
  * Landstrassen auffahrt
  *********************/
  [type="secondary_link"]{
    ::outline{
      [zoom>=13]{
        line-join: miter;
        line-color: #a5a880;
        line-width: 4;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=15] { line-width: 6; }
      [zoom>=16] { line-width: 10; }
      [zoom>=17] { line-width: 12; }
    }
    [zoom>=13]{
      line-join: miter;
      line-color: #dddddd;
      line-width: 2;
      line-cap: round;
    }
    [zoom>=15] { line-width: 4; }
    [zoom>=16] { line-width: 8; }
    [zoom>=17] { line-width: 10; }
  }



  /********************
  * Kreisstrassen
  *********************/
  [type="tertiary"]{
    ::outline{
      [zoom>=12]{
        line-join: miter;
        line-color: #c3c3c3;
        line-width: 4;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=13] { line-width: 7; }
      [zoom>=14] { line-width: 9; }
      [zoom>=15] { line-width: 13; }
      [zoom>=16] { line-width: 15; }
      [zoom>=17] { line-width: 17; }
    }
    [zoom>=9][zoom<=11] ::transparent{ line-join: miter;line-cap: round;line-color:#909090;opacity: 0.37;line-width: 1; }
    [zoom>=12]{
      line-join: miter;
      line-color: #dddddd;
      line-width: 2;
      line-cap: round;
    }
    [zoom>=13] { line-width: 5; }
    [zoom>=14] { line-width: 7; }
    [zoom>=15] { line-width: 11; }
    [zoom>=16] { line-width: 13; }
    [zoom>=17] { line-width: 15; }
  }




  /********************
  * Unklassifizierte Strassen
  *********************/
  [type="unclassified"]{
    ::outline{
      [zoom>=15]{
        line-join: miter;
        line-color: #cccccc;
        line-width: 6;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=16] { line-width: 10; }
      [zoom>=17] { line-width: 17; }
    }
    [zoom>=10][zoom<=13] ::transparent{ line-join: miter;line-cap: round;line-color:#909090;opacity: 0.37;line-width: 1; }
    [zoom=14] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 2; }
    [zoom>=15]{
      line-join: miter;
      line-color: #FFFFFF;
      line-width: 4;
      line-cap: round;
    }
    [zoom>=16] { line-width: 8; }
    [zoom>=17] { line-width: 15; }
  }

  /********************
  * Wohnstrassen
  *********************/
  [type="residential"]{
    ::outline{
      [zoom>=15]{
        line-join: miter;
        line-color: #cccccc;
        line-width: 6;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=16] { line-width: 10; }
      [zoom>=17] { line-width: 17; }
    }
    [zoom>=10][zoom<=13] ::transparent{ line-join: miter;line-cap: round;line-color:#909090;opacity: 0.37;line-width: 1; }
    [zoom=14] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 2; }
    [zoom>=15]{
      line-join: miter;
      line-color: #FFFFFF;
      line-width: 4;
      line-cap: round;
    }
    [zoom>=16] { line-width: 8; }
    [zoom>=17] { line-width: 15; }
  }

  /********************
  * Fussgaengerzone
  *********************/
  [type="pedestrian"]{
    ::outline{
      [zoom>=15]{
        line-join: miter;
        line-color: #a0a0a0;
        line-width: 6;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=16] { line-width: 10; }
      [zoom>=17] { line-width: 17; }
    }
    [zoom>=10][zoom<=13] ::transparent{ line-join: miter;line-cap: round;line-color:#909090;opacity: 0.37;line-width: 1; }
    [zoom=14] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 2; }
    [zoom>=15]{
      line-join: miter;
      line-color: #d0d0d0;
      line-width: 4;
      line-cap: round;
    }
    [zoom>=16] { line-width: 8; }
    [zoom>=17] { line-width: 15; }
  }
  [type="pedestrian_area"]{
    ::outline{
      [zoom>=15]{
        line-join: miter;
        line-color: #a0a0a0;
        line-width: 6;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=16] { line-width: 10; }
      [zoom>=17] { line-width: 17; }
    }
    [zoom>=10][zoom<=14] ::transparent{ opacity: 0.37;polygon-fill: #5f6e6d; }
    [zoom>=15]{
      line-join: miter;
      line-color: #d0d0d0;
      line-width: 4;
      line-cap: round;
      polygon-fill: #d0d0d0;
    }
    [zoom>=16] { line-width: 8; }
    [zoom>=17] { line-width: 15; }
  }



  /********************
  * Kleine Nebenstrassen
  *********************/
  [type="minor"]{
    ::outline{
      [zoom>=15]{
        line-join: miter;
        line-color: #cccccc;
        line-width: 4;
        line-cap: round;
	      .bridge{
        	line-cap: butt;
        }
      }
      [zoom>=16] { line-width: 8; }
      [zoom>=17] { line-width: 12; }
    }
    [zoom=14] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 2; }
    [zoom>=15]{
      line-join: miter;
      line-color: #FFFFFF;
      line-width: 2;
      line-cap: round;
    }
    [zoom>=16] { line-width: 6; }
    [zoom>=17] { line-width: 10; }
  }


  /********************
  * Feldwege
  *********************/

  [type="track"]{
    [zoom=14] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 2; }
    [zoom=15] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 3; }
    [zoom=16] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 6; }
    [zoom>=17] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 8; }
  }

  /********************
  * Fuss/Radwege
  *********************/
  [type="path"]{
    [zoom=14] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 1; }
    [zoom=15] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 2; }
    [zoom=16] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 3; }
    [zoom>=17] ::transparent{ line-join: miter;line-cap: round;line-color:#5f6e6d;opacity: 0.37;line-width: 4; }
  }


  /********************
  * Treppen
  *********************/
  [type="steps"]{
    [zoom=14] ::transparent{ line-cap: butt;line-join: miter;line-color:#5f6e6d;opacity: 0.37;line-width: 1; }
    [zoom=15] ::transparent{ line-cap: butt;line-join: miter;line-color:#5f6e6d;opacity: 0.37;line-width: 2; }
    [zoom=16] ::transparent{ line-cap: butt;line-join: miter;line-dasharray: 1, 1;line-color:#5f6e6d;opacity: 0.37;line-width: 6; }
    [zoom>=17] ::transparent{ line-cap: butt;line-join: miter;line-dasharray: 2, 2;line-color:#5f6e6d;opacity: 0.37;line-width: 8; }
  }


  /********************
  * Flughäfen
  *********************/
  [type="runway"]{
    [zoom>=9]{
      line-color: #d0d0d0;
      line-opacity: 1;
      line-width: 2;
      line-cap: butt;
      line-join: miter;
    }
    [zoom>=12]{line-width: 3; }
    [zoom>=13]{line-width: 5; }
    [zoom>=14]{line-width: 11; }
    [zoom>=15]{line-width: 20; }
    [zoom>=16]{line-width: 30; }
    [zoom>=17]{line-width: 50; }
  }
  [type="taxiway"]{
    [zoom>=11]{
      line-color: #d0d0d0;
      line-opacity: 1;
      line-width: 2;
      line-cap: butt;
      line-join: miter;
    }
    [zoom>=13]{line-width: 2; }
    [zoom>=14]{line-width: 3; }
    [zoom>=15]{line-width: 6; }
    [zoom>=16]{line-width: 10; }
    [zoom>=17]{line-width: 18; }
  }
  /* Einbahnstrassen-pfeil*/
  [oneway="true"][type!="motorway"][zoom>=14]{line-pattern-file: url('img/oneway-arrow.png');}
}
/*name*/
.waylabel[type!="motorway"][type!="motorway_link"][zoom>=13]
{
    text-name: "[name]";
    text-face-name: @book-fonts;
    text-size: 8;
    text-fill: #000;
    text-placement: line;
    text-halo-radius: 2;
    text-halo-fill: #f1f1f1;
    text-max-char-angle-delta: 20;
    text-min-distance: 10;
    text-spacing: 400;
}
.waylabel[type!="motorway"][type!="motorway_link"][zoom>=17]
{
    text-name: "[name]";
    text-size: 12;
}

/*Mittellinie*/
.waylabel[type="motorway"][zoom>=15]{ line-cap: round;line-join: miter;line-width: 1; line-color: #FFFFFF;  line-dasharray: 12, 12;}
/*Schilder*/
.waylabel[type="motorway"][zoom>9][ref_length>=2][ref_length<=9]
{
  shield-name:"[ref_content]";
  shield-face-name: @bold-fonts;
  shield-min-distance: 100;
  shield-min-padding:10;
  shield-size: 8;
  shield-fill: #FFF;
  shield-file: url('img/ab_shield-2.png');
  [ref_length=2] {shield-file: url('img/ab_shield-2.png'); }
  [ref_length=3] {shield-file: url('img/ab_shield-3.png'); }
	[ref_length=4] {shield-file: url('img/ab_shield-4.png'); }
	[ref_length=5] {shield-file: url('img/ab_shield-5.png'); }
	[ref_length=6] {shield-file: url('img/ab_shield-6.png'); }
	[ref_length=7] {shield-file: url('img/ab_shield-7.png'); }
	[ref_length=8] {shield-file: url('img/ab_shield-8.png'); }
	[ref_length=9] {shield-file: url('img/ab_shield-9.png'); }
}



