import uint from std::integer
import number from js::core
import sin, cos, to_radians from js::math

/** 
 * This module provides support for manpulating 2dimensional
 * vectors.  
 */

public type Vec2D is { int dx, int dy }

/**
 * Create a unit vector rotated by a given angle.
 */
public function unit(uint angle, uint magnitude) -> Vec2D
requires angle <= 360:
    // Exploit native JavaScript methods
    number rads = to_radians((number) angle)
    number cos_rads = cos(rads) * magnitude
    number sin_rads = sin(rads) * magnitude
    // Back to Whiley land
    int xp = -sin_rads
    int yp = cos_rads
    return {dx:xp, dy:yp}

/**
 * Add two vectors together.
 */
public function add(Vec2D v1, Vec2D v2) -> Vec2D:
    v1.dx = v1.dx + v2.dx
    v1.dy = v1.dy + v2.dy
    return v1

