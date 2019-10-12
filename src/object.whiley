import uint from std::integer
import string from std::ascii
import CanvasRenderingContext2D from w3c::dom
import from_string from js::util

import main
import point
import rectangle
import polygon
import Point from point
import Vec2D from vec2d
import Polygon from polygon
import Rectangle from rectangle

public final int SHIP = 0
public final int SHIP_THURSTING = 1
public final int BULLET = 2
public final int ASTEROID = 3

public final Polygon[] SHAPES = [
    // Ship
    [{x:-3,y:-3},{x:0,y:6},{x:3,y:-3}],    
    // Ship Thrusting
    [{x:-3,y:-3},{x:0,y:6},{x:3,y:-3}],
    // Bullet
    [{x:-1,y:-1},{x:-1,y:1},{x:1,y:1},{x:1,y:-1}],
    // Asteroid 1
    [{x:-1,y:3},{x:2,y:3},{x:3,y:0},{x:2,y:-1},{x:2,y:-3},{x:-2,y:-2},{x:-3,y:0}]
]

/**
 * An object is something in space which has an origin, a direction
 * and angle. The object is drawn as a series of one or more polygons.
 */
public type Object is {
    uint type,
    Point origin,
    Vec2D direction,
    uint angle,
    uint scale
} where angle < 360

/**
 * Construct a new object from a given polygon.  This will initially
 * be at the original with zero angle and no direction of movement.
 */
public function create(int t) -> Object:
    Vec2D zero = {dx:0,dy:0}
    Point o = {x:0,y:0}    
    return {type:t,origin:o,direction:zero,scale:1,angle:0}

/**
 * Move an object within a given window.  Specifically, the object
 * will wrap around the window.
 */
public function move(Object o, Rectangle window) -> Object:
    o.origin = point::translate(o.origin,o.direction)    
    if o.type != BULLET:
        // Bullets don't wrap
        o.origin = rectangle::wrap(o.origin, window)
    //
    return o

/**
 * Project the polygons of a given object onto the screen.
 */
public function project(Object ith) -> Polygon:
   Polygon p = SHAPES[ith.type]
   // Scale polygon to required size        
   p = polygon::scale(p,ith.scale)
   // Rotate about origin
   p = polygon::rotate(p,ith.angle)
   // Translate to actual location
   return polygon::translate(p,ith.origin)



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
