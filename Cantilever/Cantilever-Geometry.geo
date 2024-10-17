SetFactory("OpenCASCADE");

mm=1e-3;
H1   = 20*mm;
H2   = 40*mm;
span = 100*mm;
W1   = 20*mm;
xc   = 40*mm;
xl   = 80*mm;
a    = 8*mm;
eps  = 1*mm;
r    = 5*mm;

wb = 10*mm;
wl = 1*mm;
// Fine mesh size
hf = 0.25*mm;
//Size of the coarse mesh
hc  = 2*mm;

// Main beam geometry

x = {W1, W1, 0, 0., xc-eps, xc, xc+eps, xl-wl/2, xl+wl/2, span,
     span, W1+r};
y = {-H1-r, -H2, -H2, 0., 0., -eps, 0, 0., 0., 0.,
     -H1, -H1};

n = #x[];
For i In {0:#x[]-1}
    Point(i) = {x[i], y[i], 0, hc};
EndFor
For i In {0:n-2}
    Line(i) = {i, i+1};
EndFor
Point(n) = {W1+r, -H1-r, 0, hc};
Circle(n-1) = {n-1, n, 0};

Line Loop(1) = {0:n-1};
Plane Surface(1) = {1};

// Add two locally refined areas: One around the crack and the other around the loading point.
Rectangle(2) = {xc-wb, -H1, 0., 2*wb, H1};
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
Field[1].YMin = -H1;
Field[1].YMax = 0;
Field[1].Thickness = 10*hc;


Field[2] = Box;
Field[2].VIn  = hf;
Field[2].VOut = hc;
Field[2].XMin = xl-2*wl;
Field[2].XMax = xl+2*wl;
Field[2].YMin = -2*wl;
Field[2].YMax = 0;
Field[2].Thickness = 10*hc;

Field[3] = Min;
Field[3].FieldsList = {1, 2};

Background Field = 3;
