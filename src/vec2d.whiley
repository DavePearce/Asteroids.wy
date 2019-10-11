import uint from std::integer
import sin from js::math
import cos from js::math

/** 
 * This module provides support for manpulating 2dimensional
 * vectors.  
 */

public type Vec2D is { int dx, int dy }

/**
 * Create a unit vector rotated by a given angle.
 */
public function unit(uint angle, int magnitude) -> Vec2D
requires angle <= 360:
    //
    int xp = - sin(angle,magnitude) 
    int yp = cos(angle,magnitude)
    return {dx:xp, dy:yp}

/**
 * Add two vectors together.
 */
public function add(Vec2D v1, Vec2D v2) -> Vec2D:
    v1.dx = v1.dx + v2.dx
    v1.dy = v1.dy + v2.dy
    return v1

