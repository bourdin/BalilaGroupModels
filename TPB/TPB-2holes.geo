Include "TPB-Geometry.geo";

// Create circular holes list the holes centers coordinates in the lines below.
r = 0.5*mm;
xc = {0};
yc = {a+5*mm};

nc = #xc[];
For i In {0:nc-1}
    Disk(200+i) = {xc[i],yc[i],0,r};
    BooleanDifference{Surface{1}; Delete; }{Surface{200+i}; Delete;}
EndFor

//Create elliptical holes
we = 0.5*mm;   // half-width of elliptical holes
he = 0.05*mm;  // half-height of elliptical holes
xe = {we};
ye = {a+5*mm+2*r+1*mm+he/2};

ne = #xe[];
For i In {0:ne-1}
    Disk(300+i) = {xe[i],ye[i],0,we,he};
    BooleanDifference{Surface{1}; Delete; }{Surface{300+i}; Delete;}
EndFor

// The physical line corresponding to the crack must be defined last since the curve numbering in the region of interest will change every time a hole is added
//Physical Line(30) = {21,23};
Coherence;

Physical Surface(1) = {103};
Physical Surface(2) = {101,102,104};

Physical Curve(20) = {41};
Physical Curve(30) = {30, 31};