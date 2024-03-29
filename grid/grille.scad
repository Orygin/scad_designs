//handle 115 30
RENDALL=true;
RENDALLSPLIT=0;

PRINTHH=false;
PRINTGRID=true;
PRINTHEX=true;
PRINTREFGRID=false;
PRINTCONNECTOR=true;

PRINTPLUGS=false;
PRINTPLUGA=PRINTPLUGS; // 3
PRINTPLUGB=PRINTPLUGS; // 4
PRINTPLUGC=PRINTPLUGS; // 6

screwHolesR=2;
screwHolesH=20;

overall_length=810;
overall_width=415;
overall_height=10;

HHW=850;
HHH=455;
HHD=400;
HHPly=20;
HHDepth=50;

HHHandlesH=18;

border_margin=HHPly;
panel_margin=6;

panel_height=2.8;

posL=0;
posW=0;
tileL=(HHW+(2*panel_margin))/4;
tileW=(HHH+(2*panel_margin))/2;

fitMargin=0.4;


lipHeight=30;
$fn=80;
fn=$fn;

module smileyface(height){

difference(){
linear_extrude(height) import("smiley1.svg");
//translate([22,22,0])
//cylinder(101,20,20, center=false);

linear_extrude(height) import("smiley2.svg");
linear_extrude(height) import("smiley3.svg");
linear_extrude(height) import("smiley4.svg");
}
}

/*
smiley2=     import("smiley2.svg");
smiley3=     import("smiley3.svg");
smiley4=     import("smiley4.svg");
*/
module sector(radius, angles, fn = 24) {
fn=$fn*2;
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
}

module grillefull(posW,posL){

// Sides

difference(){
    translate([-panel_margin, -panel_margin,0])
    cube([HHW+2*panel_margin, HHH+2*panel_margin, panel_height]);
    
          
    translate([border_margin,border_margin,-1]) 
        cube([HHW-(border_margin*2),
          HHH-(border_margin*2),
          HHD+2]);
}

// Top panel
if(PRINTHEX){

    translate([-3.5,0, 0])
    linear_extrude(height=panel_height)
    {
      lattice(72, 160, 5, 5, 5*1.4);
    }
}
if(PRINTCONNECTOR){
    connector(posW,posL);
    }

    //topPanel();

hole_size=3.6; // best 3.5
hole_distance=1.2;
holesPerL=overall_length/(hole_size+(hole_distance*2));
holesPerW=overall_width/(hole_size+(hole_distance*2));

module topPanel(){
    /*difference(){
        cube([overall_length, overall_width, panel_height]);
        for(i = [0:holesPerL]){
           for(j = [0:holesPerW]){
               translate([i*(hole_size+(hole_distance*2)),
                          j*(hole_size+(hole_distance*2)), 0])
                cube(hole_size);
           }
        }
    }*/
    union(){
        for(i = [0:holesPerL]){
            translate([i*(hole_size+(hole_distance*2)),0, 0])
            cube([hole_distance, overall_width, panel_height]);
        }
        for(j = [0:holesPerW]){
                    translate([0,
                      j*(hole_size+(hole_distance*2)), 0])
            cube([overall_length, hole_distance, panel_height]);
        }
    }
}
}

module rend(all){

    if(all == true){
        for(posL=[0:3]){
            for(posW=[0:1]){
            translate([RENDALLSPLIT*posL, RENDALLSPLIT*posW, 0])
            printGrid(posW,posL);
            }
        }
   } else {
    printGrid(posW,posL);
   }
}

module printGrid(posW,posL){

intersection(){
    union(){
        difference(){
            grillefull(posW,posL);
            translate([0,0, -HHD]) HHCorners(5.5, 8);
            //connector(posW,posL);
                        
            tongue(posW,posL, true);
                    
            if((posL==0||posL==3) && posW==1)
                verticalTongue(posW,posL);
        }
        decorations();
    }

    translate([(posL*tileL)-panel_margin,(posW*tileW)-panel_margin, -60])
    cube([tileL,tileW,80]);
}
    if((posL==0||posL==3) && posW==0)
        verticalTongue(posW,posL);
    
    tongue(posW,posL-1, false);


}
//connector(posW,posL);

tongueMarginFit = .1;
tongueMarginFitZ = .3;

x=6;
y=20;
z=panel_height/2;


module verticalTongue(posW,posL, hole){
tongueMargin=hole ? -tongueMarginFit : tongueMarginFit;
tongueMarginZ=hole ? -tongueMarginFit : tongueMarginFitZ;

tongueX=x-tongueMargin;
tongueY=y-tongueMargin;
tongueZ=z-tongueMarginZ;

    if(posL ==0){
        translate([
             tongueMargin/2,
            tileW-panel_margin-(x/2) + tongueMargin/2,
            //z + tongueMarginZ/2
            0
        ])
        cube([tongueY, tongueX, tongueZ]);
    } else if(posL==3){
        translate([
            4*tileL - y-9 + tongueMargin/2,
            tileW-panel_margin-(x/2) + tongueMargin/2,
            //z + tongueMarginZ/2
            0
        ])
        cube([tongueY, tongueX, tongueZ]);
    }
}

module tongue(posW,posL, hole){

tongueMargin=hole ? -tongueMarginFit : tongueMarginFit;
tongueMarginZ=hole ? -tongueMarginFit : tongueMarginFitZ;

tongueX=x-tongueMargin;
tongueY=y-tongueMargin;
tongueZ=z-tongueMarginZ;
    
    if(posL>=0){
        translate([
            (posL+1)*tileL-panel_margin-(x/2) + tongueMargin/2,
             (posW*2*tileW)+(posW*(-y-12)) + tongueMargin/2, 
            //z + tongueMarginZ/2
            0
        ])
        cube([tongueX,tongueY, tongueZ]);
    }
    
    
}

module connector(posW, posL){

difference(){ // screw holes
union(){
// Print lips
    if(posL==0){
        translate([-6-fitMargin, posW*(tileW)-panel_margin, -lipHeight])
        cube([6,tileW+panel_margin, lipHeight]);
    } else if (posL ==3){
        translate([HHW+fitMargin, posW*(tileW)-panel_margin, -lipHeight])
        cube([HHW,tileW+panel_margin, lipHeight]);
    }
    if(posW==0){
      translate([posL*tileL-panel_margin, -6-fitMargin, -lipHeight])
        cube([tileL, 6, lipHeight]);
    } else {
      translate([posL*tileL-panel_margin, HHH+fitMargin, -lipHeight])
        cube([tileL, 6, lipHeight]);
    }
    
    }
    //110,90
    for(i=[110:70:HHW-100]){   
        translate([i, -500,-screwHolesH])
        rotate([-90,0,0])
        cylinder(2000,screwHolesR, screwHolesR); 
    }
    
    for(i=[110:78:HHH-100]){   
        translate([-800, i,-screwHolesH])
        rotate([0,90,0])
        cylinder(2000,screwHolesR, screwHolesR); 
    }
} // Holes in lips
    
    translate([posL*tileL+(130-posL*15),(2*posW*tileW)+(2-posW*30),-.4])
    linear_extrude(.4) mirror([1,0,0]) text(str(posL,posW), 15);
    
    
    
    // 12in support
    if(posL==1){
    if(posW==1){
    
    //upper
    translate([(posL+1)*tileL-panel_margin-62, posW*(tileW)-panel_margin+70, -HHDepth+panel_height])
    rotate([0,0,30])
    cylinder(HHDepth, 16,18, $fn=3);
    } else {
    //lower
    translate([(posL+1)*tileL-panel_margin-61, 
            (posW+1)*(tileW)-panel_margin-70, -HHDepth+panel_height])
        rotate([0,0,90])
        cylinder(HHDepth, 16,18, $fn=3);
    }
    }
    
    if(posL==3){    
    translate([3*tileL-panel_margin-110, 
            1*(tileW)-panel_margin, panel_height-HHDepth])
    rotate([0,0,-20])
    linear_extrude(HHDepth) arc(310/2, [0,40], 8);
    
    }
}

connSideWidth=20;
connSideHeight=overall_height-4;
connSideDepth=4;
connSidePos=1;

module HH() {
    //Main
    //translate([(overall_length-HHW)/2, (overall_width-HHH)/2, 0])
    difference(){
        cube([HHW,HHH,HHD]);
        translate([HHPly,HHPly, HHD-HHDepth])
        cube([HHW-HHPly*2,HHH-HHPly*2,HHDepth]);
    }
    
    speakerD=310;
    // 12 inch
    color([1,0,0])
    translate([(speakerD/2)+30+HHPly,HHH/2,2])
    cylinder(HHD-40, speakerD/2,speakerD/2);
    // 12 Inch
    color([1,0,0])
    translate([(speakerD*1.5)+35+HHPly,HHH/2,2])
    cylinder(HHD-40, speakerD/2,speakerD/2);
    // hole
    color([0,1,0])
    translate([HHW-50-HHPly-20,50+HHPly+20,2])
    cylinder(HHD-40, 50,50);
    
    //corners
    HHCorners(0, 8);

    HHHandles();
}

module HHHandles(){
translate([125,-15,-HHHandlesH])
cube([40, 30, HHD]);
translate([HHW-125-40,-15,-HHHandlesH])
cube([40, 30, HHD]);
}

module HHCorners(margin, corner){
    difference(){
        corners(margin);
        
        translate([10+margin/4, 10+margin/4, -10])
            cube([HHW-20-margin,HHH-20-margin,HHD+41]);

    }
    marg = margin/4;
    //round bottom left
    translate([10+marg, 10+marg, -10])
        cornerBorder(corner+margin);
        
    //round bottom right
    translate([HHW-margin-10+marg, 10+marg, -10])
        rotate([0,0,90])
        cornerBorder(corner+margin);
        
    //round top right
    translate([HHW-margin-10++marg, HHH-margin-10+marg, -10])
        rotate([0,0,180])
        cornerBorder(corner+margin);

    //round top left
    translate([10+marg, HHH-margin-10+marg, -10])
        rotate([0,0,-90])
        cornerBorder(corner+margin);

}
module corners(margin){
    cornerSize=100+margin;
    cornerHeight=20;
        translate([-6, -6, 0])
        cube([cornerSize,cornerSize,HHD+cornerHeight]);
        
        translate([(HHW)-cornerSize+6, -6, 0])
        cube([cornerSize,cornerSize,HHD+cornerHeight]);
        
        translate([-6, HHH-cornerSize+6, 0])
        cube([cornerSize,cornerSize,HHD+cornerHeight]);
        
        translate([(HHW)-cornerSize+6, HHH-cornerSize+6, 0])
        cube([cornerSize,cornerSize,HHD+cornerHeight]);
    }
    
    

module refgrid(){
height=panel_height;
color([0,0.5,0.8,.2]){

translate([-10, tileW-2.5-panel_margin,0])
cube([overall_length+60, 5, height]);

translate([tileL-2.5-panel_margin,-10,0])
cube([5, overall_width+60, height]);
translate([2*tileL-2.5-panel_margin,-10,0])
cube([5, overall_width+60, height]);
translate([3*tileL-2.5-panel_margin,-10,0])
cube([5, overall_width+60, height]);

}
}

module hexagon(radius)
{
  circle(r=radius,$fn=6);
}

module shell(radius, shell)
{
  difference()
  {
    hexagon(shell); // base
    hexagon(radius*1); // hole
  }
}

function column_to_offset(column, offset) = (column % 2) * offset;

module translate_to_hex(x_coord, y_coord, hex_width)
{
  translate([x_coord*hex_width*1.75, y_coord*hex_width*2+column_to_offset(x_coord, hex_width), 0])
  {
    children(0);
    //hexagon(hex_width);
  }
}

module lattice(rows, columns, radius, hex_width, shell)
{
  for(x = [0:columns-1])
  {
    for(y = [0:rows-1])
    {
      translate_to_hex(x, y, hex_width)
      {
        shell(radius, shell);
      }
    }
  }
}

module printPlug(posi,posj){
plugD=15.5;
fitment=0.12;
    // Visual
    linear_extrude(height=panel_height) lattice(18,32, 5, 5, 7);
    
    // Plug
    
    plugH=5;
    
   
    difference(){
    plug(posi,posj);
    translate([0, 0, panel_height])
    linear_extrude(height=3) lattice(18, 30, 5-fitment, 5, 7);
    
    }
    
//    translate([0, 0, panel_height/2])

}
module plug(posi,posj){
    innerhole=2.64;
    plug_height=panel_height*2;
//    for(i=[2,7,12,17,20,24]){
    for(i=posi){
    for(j=posj){

    linear_extrude(height=plug_height)
      translate_to_hex(i, j+(i%2), 5)
      {        
          difference()
          {
            hexagon(7); // base
            hexagon(innerhole); // hole
          }
      }
      
}
}

}

if(PRINTHH == true){

translate([0,0,-400])
HH();
HHHandles();
}


if(PRINTGRID){
intersection(){
    difference(){
        rend(RENDALL);
        translate([0,0,-HHD])
        HHHandles();
        }
/*        translate([tileL*2-110, 120, -100])
        cube([80,300,200]);*/
    }

}
if(PRINTREFGRID){
refgrid();
}

if(PRINTPLUGA){
    translate([172-9,tileW-24-40-5,-panel_height])
    plugA();
    
    translate([382,tileW-24-35-5,-panel_height])
    plugA();
    
    translate([592,tileW-24-35-5,-panel_height])
    plugA();
}
if(PRINTPLUGB){
    translate([14,tileW-24-45-4.5,-panel_height])
    plugB();
    
    translate([233+9,tileW-24-35-4.5,-panel_height])
    plugB();
    
    translate([443+9,tileW-24-35-4.5,-panel_height])
    plugB();
    
    translate([670,tileW-24-40-4.5,-panel_height])
    plugB();
}
if(PRINTPLUGC){
translate([tileL-37-16, 15, -panel_height])
plugC();
translate([tileL-37-16, tileW+32, -panel_height])
plugC();

translate([2*tileL-37-22, 15, -panel_height])
plugC();
translate([2*tileL-37-22, tileW+32, -panel_height])
plugC();
translate([3*tileL-37-26, 15, -panel_height])
plugC();
translate([3*tileL-37-26, tileW+32, -panel_height])
plugC();
}

module decorations(){
//bottom
for(i=[0:5]){
    translate_to_hex(18*i+3,2,5)
//    translate([139.75,20,0])
    scale([.25,.25,1])
    smileyface(panel_height);
    }
    //top
for(i=[0:5]){
    translate_to_hex(18*i+3,42,5)
    translate([11,11,0])
    rotate([0,0,180])
    scale([.25,.25,1])
    smileyface(panel_height);
    }
}

module plugB2(){

posi=[4,9,16,23,27];
posj=[2,9];
    intersection(){
        printPlug(posi,posj);

        // Intersect with cube 
        translate([28,15,0])
        cube([134-16/*142*/,95,panel_height+3]);
    }
}

module plugB(){

posi=[2,9,16,23,27];
posj=[2,9];
    intersection(){
        printPlug(posi,posj);

        // Intersect with cube 
        translate([12,15,0])
        cube([134/*142*/,95,panel_height+3]);
    }
}
module plugA(){

posi=[2,8,16,23,27];
posj=[2,9];
    intersection(){
        printPlug(posi,posj);

        // Intersect with cube 
        translate([12,15,0])
        cube([64/*142*/,80,panel_height+3]);
    }
}
module plugC(){

posi=[2,9];
posj=[2,6,10,14,27];
    intersection(){
        printPlug(posi,posj);

        // Intersect with cube 
        translate([12,15,0])
        cube([74/*142*/,145,panel_height+3]);
    }
}

module cornerBorder(cornerR){
    difference(){
        cube([cornerR,cornerR,HHD+30]);
        translate([cornerR,cornerR,0])
        cylinder(HHD+30, cornerR, cornerR, false);
    }
}