.rail.line[zoom>=17]
{
    line-pattern-file: url('img/rail-wide.png');
}

.rail.line[type="rail"][tunnel="false"][zoom>=15][zoom<=16]
{
    out/line-cap:square;
    out/line-color:#868686;out/line-width: 4;
    line-cap: butt;
    line-join: round;
	line-color:#eee;
	line-width: 2;
	line-dasharray: 12, 12;
}

.rail.line[zoom>=11][zoom<=14]
{
    out/line-cap:square;
    out/line-color:#868686;out/line-width: 3;
    line-cap: butt;
    line-join: round;
	line-color:#eee;
	line-width: 1;
	line-dasharray: 12, 12;
}

.rail.line[type="rail"][zoom>=8][zoom<=10]
{
    line-cap: butt;
    line-join: round;
	line-color:#868686;
	line-width: 2;
}

.rail.line[type="rail"][zoom>=6][zoom<=7]
{
    line-cap: butt;
    line-join: round;
	line-color:#868686;
	line-width: 1;
}
