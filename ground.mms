@water: #bfd3ef;
@border: #389;
@city1: #d0d0d0;
@city2: #d8d8d8;
@city3: #e0e0e0;
@park: #c2d89a;
@forest: #b9c5a3;
@farm: mix(#dadbad, @land, 30%);
@cemetery: #a9c19a;
@parking: #ddd;
@building: #aaaaaa;

.lakes[zoom<=4]{
    polygon-fill: @ozean;
}
.lakes[zoom>=5][zoom<=7]{
    line-width: 1;
    line-color: #b0b0b0;
    polygon-fill: @ozean;
}


.land{
  ::outline[zoom<=7]{
    line-width: 1;
    line-color: #808080;
  }
  ::outline[zoom>=8]{
    line-width: 2;
    line-color: #808080;
  }
  
  polygon-opacity:1;
  polygon-fill:@land;
}


.stateborder.line[zoom=2]{
    line-width: 0.7;
    line-color: @border;
    opacity:0.5;
}
.stateborder.line[zoom=3]{
    line-width: 1;
    line-color: @border;
    opacity:0.5;
}
.stateborder.line[zoom>=4][zoom<=5]{
    line-width: 1.5;
    line-color: @border;
    opacity:0.5;
}
.stateborder.line[zoom<=1]{
    line-width: 0.5;
    line-color: #c0c0c0;
}
.stateborder.line[zoom>=6][zoom<=7]{
    line-width: 2;
    line-color: @border;
    opacity:0.5;
}
.border.line[level>=1][level<=2][type=administrative][zoom=8]{
    line-width: 3;
    line-color: @border;
    opacity:0.5;
}
.border.line[level>=1][level<=2][type="administrative"][zoom>=9][zoom<=22]{
    line-width: 4;
    line-color: @border;
    opacity:0.5;
}
.border.line[level>=3][level<=4][type="administrative"][zoom>=9][zoom<=10]{
    line-width: 3;
    line-color: @border;
    opacity:0.5;
    line-dasharray: 3, 3;
}
.border.line[level>=3][level<=4][type="administrative"][zoom>=11][zoom<=22]{
    line-width: 3;
    line-color: @border;
    opacity:0.5;
}
.border.line[level>=5][level<=8][type="administrative"][zoom>=11][zoom<=13]{
    line-width: 2;
    line-color: @border;
    opacity:0.5;
    line-dasharray: 3, 3;
}
.border.line[level>=5][level<=8][type="administrative"][zoom>=14][zoom<=22]{
    line-width: 2;
    line-color: @border;
    opacity:0.5;
    line-dasharray: 6, 6;
}
.border.line[level>=9][type="administrative"][zoom>=14][zoom<=22]{
    line-width: 2;
    line-color: @border;
    opacity:0.5;
    line-dasharray: 3, 3;
}

.area[type="water"][zoom>=8]
{
    polygon-fill: @water;
    polygon-smooth:0.3;
}
.waterway[type="river"][zoom>=12][zoom<=13],
.waterway[type="canal"][zoom>=12][zoom<=13]
{
    line-width: 4;
    line-color: @water;
}
.waterway[type="river"][zoom=14],
.waterway[type="canal"][zoom=14]
{
    line-width: 8;
    line-color: @water;
}
.waterway[type="river"][zoom>=15],
.waterway[type="canal"][zoom>=15]
{
    line-width: 12;
    line-color: @water;
}
.waterway[type="stream"][zoom>=13][zoom<=14]
{
    line-width: 2;
    line-color: @water;
}
.waterway[type="stream"][zoom=15]
{
    line-width: 4;
    line-color: @water;
}
.waterway[type="stream"][zoom>=16]
{
    line-width: 6;
    line-color: @water;
}

.citylike[zoom>=2][zoom<=7]
{
    polygon-fill: @city1;
}

.area[type="city"][zoom>=8][zoom<=10]
{
    polygon-fill: @city1;
}
.area[type="city"][zoom=11]
{
    polygon-fill: @city2;
}
.area[type="city"][zoom>=12]
{    
    polygon-fill: @city3;
}
.area[type="park"][zoom>=12]
{
    polygon-fill: @park;
}
.area[type="forest"][zoom>=4]
{
    polygon-fill: @forest;
    polygon-smooth:0.3;
}
.area[type="farm"][zoom>=9]
{
    polygon-fill: @farm;
}
.area[type="cemetery"][zoom>=13]
{
    polygon-fill: @cemetery;
}
.area[type="cemetery"][zoom>=16]
{
    polygon-pattern-file: url('img/graveyard-z.png');
}

.area[type="parking"][zoom>=12]
{
    line-width: 1;
    line-color: @parking;
}

.area[type="building"][zoom>=16]
{
    polygon-fill: @building;
}

.area[type="building"][zoom>=16]
{
    line-width: 1;
    line-color: #808080;
}
