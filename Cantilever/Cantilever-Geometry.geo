SetFactory("OpenCASCADE");

//um=1e-6;
um   = 1;    // usin Micron as the unit of length
W    = 4*um; // Thickness of the beam
H2   = 8*um;
W1   = 5*um; // Width of the support
xc   = W1+10*um; // Crack location
l    = 20*um;    // distance between the crack and the loading point
span = xc+l+W1;

a    = 1*um; // depth of the crack
eps  = a/10.; // width of the crack
r    = 1*um; // radius of the filet

wb = 2.5*um;
wl = 0.5*um;
// Fine mesh size
hf = 0.01*um;
//Size of the coarse mesh
hc  = 0.1*um;

// Main beam geometry

// x = {W1, W1, 0, 0., W1, xc-eps, xc, xc+eps, xc+l-wl/2, xc+l+wl/2, span,
//      span, W1+r};
// y = {-W-r, -H2, -H2, 0., 0., 0., -a, 0., 0., 0., 0.,
//      -W, -W};

x = {W1+r, span, span, xc+l+wl/2, xc+l-wl/2, xc+eps, xc, xc-eps, W1, 0., 0., W1, W1};
y = {-W, -W, 0., 0., 0., 0., -a, 0., 0., 0., -H2, -H2, -W-r};
n = #x[];
For i In {0:#x[]-1}
    Point(i) = {x[i], y[i], 0, hc};
EndFor
For i In {0:n-2}
    Line(i) = {i, i+1};
EndFor
Point(n) = {W1+r, -W-r, 0, hc};
Circle(n-1) = {n-1, n, 0};

Line Loop(1) = {0:n-1};
Plane Surface(1) = {-1};

// Add two locally refined areas: One around the crack and the other around the loading point.
Rectangle(2) = {xc-wb, -W, 0., 2*wb, W};
BooleanFragments{Surface{1};Delete;}{Surface{2}; Delete;}
Recursive Delete {
  Surface{4}; 
}
Coherence;

Field[1] = Box;
Field[1].VIn  = hf;
Field[1].VOut = hc;
Field[1].XMin = xc-wb;
Field[1].XMax = xc+wb;
Field[1].YMin = -W;
Field[1].YMax = 0;
Field[1].Thickness = 10*hc;


Field[2] = Box;
Field[2].VIn  = hf;
Field[2].VOut = hc;
Field[2].XMin = xc+l-2*wl;
Field[2].XMax = xc+l+2*wl;
Field[2].YMin = -wl;
Field[2].YMax = 0;
Field[2].Thickness = 10*hc;

Field[3] = Min;
Field[3].FieldsList = {1, 2};

Background Field = 3;

Physical Surface (1) = {1,3}; // Elastic part
Physical Surface (2) = {2};   // Brittle part

Physical Line(30) = {5,6,7,8}; // Clamped area
Physical Line(40) = {18};      // Loading point
Physical Line(50) = {10,11};   // Crack