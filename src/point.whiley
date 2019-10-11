// Provides various functions for manipulating polygons
import std::ascii
import uint from std::integer
import Vec2D from vec2d
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

public function translate(Point point, Vec2D delta) -> Point:
    point.x = point.x + delta.dx
    point.y = point.y + delta.dy
    return point

public function translate(Point point, Point origin) -> Point:
    point.x = point.x + origin.x
    point.y = point.y + origin.y
    return point

public function rotate(Point point, uint angle) -> Point:
    int xp = (point.x * cos(angle,100)) - (point.y * sin(angle,100)) 
    int yp = (point.y * cos(angle,100)) + (point.x * sin(angle,100)) 
    return {x:(xp/100),y:(yp/100)}
