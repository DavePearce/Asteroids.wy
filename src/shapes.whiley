// Provides various functions for manipulating polygons
import std::ascii
import uint from std::integer

import sin from js::math
import cos from js::math

// =====================================================
// Points
// =====================================================

public type Point is { int x, int y }

public function scale(Point point, uint magnitude) -> Point:
    point.x = point.x * magnitude
    point.y = point.y * magnitude
    return point

public function translate(Point point, Point delta) -> Point:
    point.x = point.x + delta.x
    point.y = point.y + delta.y
    return point

public function rotate(Point point, uint angle) -> Point:
    int xp = (point.x * cos(angle,100)) - (point.y * sin(angle,100)) 
    int yp = (point.y * cos(angle,100)) + (point.x * sin(angle,100)) 
    return {x:(xp/100),y:(yp/100)}

public function wrap(int x, int low, int high) -> int:
    if x < low:
        x = high - (low-x)
    else if x > high:
        x = low + (x-high)
    //
    return x

public function wrap(Point point, Rectangle r) -> Point:
    //
    point.x = wrap(point.x,r.origin.x,r.origin.y + r.width)
    point.y = wrap(point.y,r.origin.y,r.origin.y + r.height)    
    return point

// =====================================================
// Rectangles
// =====================================================

public type Rectangle is {
    Point origin,
    int width,
    int height
}

// =====================================================
// Polygons
// =====================================================

// A polygon is simply an array of one or more points.
public type Polygon is (Point[] points)
// Must be at least one point!
where |points| > 0
   
function scale(Polygon polygon, uint magnitude) -> Polygon:
    uint i = 0
    while i < |polygon|:
        polygon[i] = scale(polygon[i],magnitude)
        i = i + 1
    //
    return polygon

function translate(Polygon polygon, Point delta) -> Polygon:
    uint i = 0
    while i < |polygon|:
        polygon[i] = translate(polygon[i],delta)
        i = i + 1
    //
    return polygon

function rotate(Polygon polygon, uint angle) -> Polygon
// Angle is an angle :)
requires angle <= 360:
    //
    uint i = 0
    while i < |polygon|:
        polygon[i] = rotate(polygon[i],angle)
        i = i + 1
    //
    return polygon