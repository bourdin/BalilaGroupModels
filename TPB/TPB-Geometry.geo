SetFactory("OpenCASCADE");

mm=1e-3;
W = 120*mm;
H = 20*mm;
a = 4*mm;
eps = 0.1*mm;
span = 100*mm;
Wl = 1*mm;

// Size of the target of area
Wb = 10*mm;
Hb = 15*mm;

// Fine mesh size
hf = 0.05*mm;
//Size of the coarse mesh
hc  = 1*mm;

// Create the main beam geometry
// Points
x = {0., eps, Wb/2, span/2, span/2, Wl/2, -Wl/2, -span/2, -span/2, -Wb/2, -eps};
y = {a,0, 0,0, H, H, H, H, 0, 0, 0};
n = #x[];
For i In {0:#x[]-1}
    Point(i) = {x[i], y[i], 0, hc};
EndFor
For i In {0:n-1}
    Line(i) = {i, (i+1)%n};
EndFor
Line Loop(1) = {0:n-1};
Plane Surface(1) = {1};

// Create the region of interest in which we will solve for fracture
Rectangle(2) = {-Wb/2,0,0,Wb,Hb};
BooleanFragments{Surface{1};Delete;}{Surface{2}; Delete;}
Recursive Delete {
  Surface{3}; 
}

Rectangle(3) = {-W/2,0,0,(W-span)/2,H};
Rectangle(4) = {span/2,0,0,(W-span)/2,H};
Physical Surface(1) = {1,3,4};

Physical Surface(2) = {2};
Physical Line(20) = {11};
//Physical Line(30) = {1,7};
Physical Point(100) = {8};
Physical Point(101) = {13};


Field[1] = Box;
Field[1].VIn  = hf;
Field[1].VOut = hc;
Field[1].XMin = -Wb/2;
Field[1].XMax = Wb/2;
Field[1].YMin = 0;
Field[1].YMax = Hb;
Field[1].Thickness = 10*hc;
Background Field = 1;

Coherence;