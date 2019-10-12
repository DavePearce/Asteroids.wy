import std::ascii
import std::array
import string from std::ascii
import uint from std::integer

import std::vector
import Vector from std::vector

import from_string from js::util
import Document from w3c::dom
import HTMLCanvasElement from w3c::dom
import CanvasRenderingContext2D from w3c::dom

import keyboard
import vec2d
import Vec2D from vec2d

import Point from point

import object
import Object from object

import polygon
import Polygon from polygon

import rectangle
import Rectangle from rectangle

/** 
 * Precision determines the accuracy to which fixed decimal
 * calculations are performed.  This matters because we don't 
 * have floating point numbers in Whiley.
 */
final int PRECISION = 1000

public type State is {
    // playing area
    Rectangle window,
    // Bullet repeat count
    int repeat,
    // Space objects
    Vector<Object> objects
} where objects.length > 0

/**
 * Construct a bullet being fired in a given angle
 */
function bullet(Point p, int angle) -> Object:
    Object bullet = object::create(object::BULLET)
    // Set scale
    bullet.scale = 5 * PRECISION
    // Set location
    bullet.origin = p
    // Detemine direction vector
    bullet.direction = vec2d::unit(angle,10*PRECISION)
    //
    return bullet

/**
 * Intialise the game in a window with given dimensions.
 */
public export function init(uint width, uint height) -> State:
    Object obj1 = object::create(object::SHIP)
    obj1.scale = 5 * PRECISION
    obj1.origin = {x:(PRECISION*width)/2,y:(PRECISION*height)/2}
    //
    return {
        window: rectangle::create(0,0,width*PRECISION,height*PRECISION),
        repeat: 10,
        objects: vector::push(vector::Vector<Object>(),obj1)
    }

/**
 * Update the game based on the current keyboard state.
 */
public export function update(keyboard::State input, State s)->State:
    //
    if s.repeat > 0:
        s.repeat = s.repeat - 1
    // Update ship based on user input
    s = update_ship(input,s)
    // Clip any bullets out of the window
    s = clip_bullets(s)
    // Move all objects within the system    
    int i = 0
    while i < vector::size(s.objects) where i >= 0:
        Object o = vector::get(s.objects,i)
        o = object::move(o,s.window)
        s.objects = vector::set(s.objects,i,o)
        i = i + 1
    //
    return s

/**
 * Update the ship based on user input.  For example, rotate the ship
 * if the user has pressed the left or right arrow keys.  Likewise,
 * create new bullets if the spacebar is pressed.
 */
function update_ship(keyboard::State input, State s)->State:
    Object ship = vector::get(s.objects,0)
    // Update angle (if left or right pressed_
    if input[keyboard::LEFTARROW]:
        ship.angle = (ship.angle - 5) % 360
    else if input[keyboard::RIGHTARROW]:
        ship.angle = (ship.angle + 5) % 360
    // Add thrust (if uparrow pressed)
    if input[keyboard::UPARROW]:
        // Detemine unit vector in direction ship is facing.
        Vec2D vec = vec2d::unit(ship.angle,PRECISION)
        // Translate direction vector by this amount
        ship.direction = vec2d::add(ship.direction,vec)
    // Update ship
    s.objects = vector::set(s.objects,0,ship)
    // Check for firing
    if input[keyboard::SPACEBAR] && s.repeat == 0:
        // Add new bullet object to system
        s.objects = vector::push(s.objects,bullet(ship.origin,ship.angle))
        s.repeat = 10
    // Done
    return s

/**
 * Remove any bullets which have moved beyond the bounds of the
 * window.
 */
function clip_bullets(State s) -> State:
    uint i = 0
    while i < vector::size(s.objects):
        Object o = vector::get(s.objects,i)
        // Check whether bullet still visible.  Technically, we should
        // use the bounding box for this operation.  However, I just* use
        // the origin since, for bullets, it doesn't really matter.
        if o.type == object::BULLET && !rectangle::contains(s.window,o.origin):
            // Swap bullet with last object
            Object last = vector::top(s.objects)
            // remove last object
            s.objects = vector::pop(s.objects)
            // Replace this object with last
            s.objects = vector::set(s.objects,i,last)
        else:
            i = i + 1
    //
    return s


/**
 * Draw the current state of the game to a given canvas element.
 */
public export method draw(HTMLCanvasElement canvas, State state):
    CanvasRenderingContext2D ctx = canvas->getContext(from_string("2d"))
    // Clear the screen
    int sx = state.window.x
    int sy = state.window.y
    ctx->clearRect(sx,sy,state.window.width,state.window.height)
    // Draw each object on the screen
    int i=0
    while i < vector::size(state.objects) where i >= 0:
        Object ith = vector::get(state.objects,i)
        // Determine polygon for object
        Polygon p = object::SHAPES[ith.type]
        // Scale polygon to required size        
        p = polygon::scale(p,ith.scale)
        // Rotate about origin
        p = polygon::rotate(p,ith.angle)
        // Translate to actual location
        p = polygon::translate(p,ith.origin)
        // Finally, draw it
        object::draw(ctx,"#dddddd","#00",p)
        i = i + 1
    //
    // Write debugging text (if applicable)
    ctx->fillStyle = from_string("#000000")
    ctx->font = from_string("30px Lucida Console")
    // Determine string
    ascii::string objects = ascii::to_string(vector::size(state.objects))
    ascii::string status = array::replace_all("{} objects","{}",objects)
    ctx->fillText(from_string(status),10,30)

