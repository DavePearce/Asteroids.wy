import string from std::ascii

import uint from std::integer
import from_string from js::util
import Document from w3c::dom
import HTMLCanvasElement from w3c::dom
import CanvasRenderingContext2D from w3c::dom

import Rectangle from shapes
import Polygon from shapes
import Point from shapes
import translate from shapes
import wrap from shapes
import scale from shapes
import rotate from shapes

public type Object is {
    Polygon polygon,
    Point origin,
    Point direction,
    uint angle,
    uint scale
} where angle < 360

public function Object(Polygon p) -> Object:
    Point zero = {x:0,y:0}
    return {polygon:p,origin:zero,direction:zero,scale:1,angle:0}

public function move(Object o, Rectangle window) -> Object:
    o.origin = translate(o.origin,o.direction)
    o.origin = wrap(o.origin, window)
    return o

public type State is {
    // playing area
    Rectangle window,
    // Space objects
    Object[] objects
} where |objects| > 0

public final Polygon SHIP = [{x:-3,y:-3},{x:0,y:6},{x:3,y:-3}]

public export function init(uint width, uint height) -> State:
    Object obj1 = Object(SHIP)
    obj1.scale = 5
    obj1.direction = {x:3,y:5}
    obj1.origin = {x:width/2,y:height/2}
    //
    return {
        window:{origin:{x:0,y:0},width:width,height:height},
        objects:[obj1]
    }

public export function update(State s)->State:
    //
    Object ship = s.objects[0]
    ship.angle = (ship.angle + 2) % 360
    ship = move(ship,s.window)
    s.objects[0] = ship    
    return s

public export method draw(HTMLCanvasElement canvas, State state):
    CanvasRenderingContext2D ctx = canvas->getContext(from_string("2d"))
    // Clear the screen
    int sx = state.window.origin.x
    int sy = state.window.origin.y
    ctx->clearRect(sx,sy,state.window.width,state.window.height)
    // Draw each object on the screen
    int i=0
    while i < |state.objects| where i >= 0:
        Object ith = state.objects[i]
        // Scale polygon to required size
        Polygon p = scale(ith.polygon,ith.scale)
        // Rotate about origin
        p = rotate(p,ith.angle)
        // Translate to actual location
        p = translate(p,ith.origin)
        // Finally, draw it
        draw_polygon(ctx,"#dddddd","#00",p)
        i = i + 1
    //

method draw_polygon(CanvasRenderingContext2D ctx, string fill, string line, Point[] points)
requires |points| > 0:
    ctx->fillStyle = from_string(fill)
    ctx->strokeStyle = from_string(line)
    ctx->lineWidth = 3
    ctx->beginPath()
    // Move to start
    ctx->moveTo(points[0].x, points[0].y)
    uint i = 1
    while i < |points|:
        ctx->lineTo(points[i].x, points[i].y)
        i = i + 1
    ctx->closePath()
    // Fill contents
    ctx->fill()
    // Draw outline
    ctx->stroke()
    