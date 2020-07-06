// Provides various functions for manipulating polygons
import std::ascii
import uint from std::integer
import Vec2D from vec2d
import cos,sin,to_radians from js::math
import number from js::core

// =====================================================
// Points
// =====================================================

public type Point is { int x, int y }

public function scale(Point point, uint magnitude) -> Point:    
    point.x = point.x * magnitude
    point.y = point.y * magnitude
    return point

public function translate(Point point, Vec2D delta) -> Point:
    point.x = point.x + delta.dx
    point.y = point.y + delta.dy
    return point

public function translate(Point point, Point origin) -> Point:
    point.x = point.x + origin.x
    point.y = point.y + origin.y
    return point

public function rotate(Point point, uint angle) -> Point:
    // Exploit native JavaScript methods
    number rads = to_radians((number) angle)
    number cos_rads = cos(rads)*100
    number sin_rads = sin(rads)*100
    // Back to Whiley land
    int xp = (point.x * cos_rads) - (point.y * sin_rads) 
    int yp = (point.y * cos_rads) + (point.x * sin_rads) 
    return {x:xp/100,y:yp/100}
