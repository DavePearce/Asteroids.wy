import uint from std::integer
import string from std::ascii
import CanvasRenderingContext2D from w3c::dom
import from_string from js::util

import main
import point
import rectangle
import Point from point
import Vec2D from vec2d
import Polygon from polygon
import Rectangle from rectangle

/**
 * An object is something in space which has an origin, a direction
 * and angle. The object is drawn as a series of one or more polygons.
 */
public type Object is {
    Polygon polygon,
    Point origin,
    Vec2D direction,
    uint angle,
    uint scale
} where angle < 360

/**
 * Construct a new object from a given polygon.  This will initially
 * be at the original with zero angle and no direction of movement.
 */
public function create(Polygon p) -> Object:
    Vec2D zero = {dx:0,dy:0}
    Point o = {x:0,y:0}    
    return {polygon:p,origin:o,direction:zero,scale:1,angle:0}

/**
 * Move an object within a given window.  Specifically, the object
 * will wrap around the window.
 */
public function move(Object o, Rectangle window) -> Object:
    o.origin = point::translate(o.origin,o.direction)
    o.origin = rectangle::wrap(o.origin, window)
    return o

/**
 * Draw a given polygon onto a given canvas context.
 */
public method draw(CanvasRenderingContext2D ctx, string fill, string line, Point[] points)
requires |points| > 0:
    ctx->fillStyle = from_string(fill)
    ctx->strokeStyle = from_string(line)
    ctx->lineWidth = 3
    ctx->beginPath()
    // Move to start
    ctx->moveTo(points[0].x / main::PRECISION, points[0].y / main::PRECISION)
    uint i = 1
    while i < |points|:
        ctx->lineTo(points[i].x / main::PRECISION, points[i].y / main::PRECISION)
        i = i + 1
    ctx->closePath()
    // Fill contents
    ctx->fill()
    // Draw outline
    ctx->stroke()
