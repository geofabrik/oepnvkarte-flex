.place
{
    [type="continent"][zoom<=2]{
      [zoom>=1]{
        text-name: "[name]";
        text-size: 12;
        text-face-name: @bold-fonts;
        text-halo-radius: 2;
        text-fill: #222;
        text-halo-fill: #eee;
        text-placement: point;
        text-wrap-width: 65;    
        text-min-distance: 10;
      }
      [zoom>=2]{text-size: 14;}
    }
    [type="country"][zoom<=3]{
      [zoom>=2]{
        text-name: "[name]";
        text-size: 10;
        text-face-name: @book-fonts;
        text-halo-radius: 2;
        text-fill: #222;
        text-halo-fill: #eee;
        text-placement: point;
        text-wrap-width: 65;    
        text-min-distance: 10;
      }
      [zoom>=4]{
        text-face-name: @bold-fonts;
        text-size: 12;
      }
    }
    [type="city"][zoom<=14]{
      [zoom>=4]{
        text-placement: point;
        text-wrap-width: 65;    
        text-min-distance: 10;
        text-name: "[name]";
        text-face-name: @bold-fonts;
        text-halo-radius: 2;
        text-fill: #222;
        text-size: 10;
        text-halo-fill: #eee;
      }
      [zoom>=9]{text-size: 12;}
      [zoom>=14]{text-size: 14;}
    }
    [type="town"][zoom<=15]
    {
      [zoom>=9]{
        text-placement: point;
        text-wrap-width: 65;    
        text-min-distance: 10;
        text-size: 10;
        text-name: "[name]";
        text-face-name: @bold-fonts;
        text-halo-radius: 2;
        text-fill: #222;
        text-size: 10;
        text-halo-fill: #eee;
      }
      [zoom>=11] { text-halo-fill: #fff; }
      [zoom>=13]{
        text-size: 12;
      }
    }
    [type="village"][zoom<=16]{
      [zoom>=12]{
        text-face-name: @book-fonts;
        text-fill: #000;
        text-placement: point;
        text-wrap-width: 65;    
        text-min-distance: 10;
        text-halo-radius: 2;
        text-halo-fill: #fff;
        text-name: "[name]";
        text-size: 10;
      }
      [zoom>=14]{text-size: 12;}
    }
    [type="suburb"][zoom<=13]{
      [zoom>=12]{
        text-face-name: @book-fonts;
        text-fill: #000;
        text-placement: point;
        text-wrap-width: 65;    
        text-min-distance: 10;
        text-halo-radius: 2;
        text-halo-fill: #fff;
        text-name: "[name]";
        text-size: 10;
      }
    }
    [type="hamlet"][zoom<=16]{
      [zoom>=14]{
        text-face-name: @book-fonts;
        text-fill: #000;
        text-placement: point;
        text-wrap-width: 65;    
        text-min-distance: 10;
        text-halo-radius: 2;
        text-halo-fill: #fff;
        text-name: "[name]";
        text-size: 10;
      }
    }
}



