import std::ascii
import std::array
import random from js::math
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
 * Intialise the game in a window with given dimensions.
 */
public export method init(uint width, uint height) -> State:
    // Create ship (fixed location)
    Object ship = object::create(object::SHIP)
    ship.scale = 5 * PRECISION
    ship.origin = {x:(PRECISION*width)/2,y:(PRECISION*height)/2}
    // Create asteroid 1 (random location)
    Object asteroid_1 = object::create(object::ASTEROID)
    asteroid_1.scale = 30 * PRECISION
    asteroid_1.origin = {x:random(width),y:random(width)}
    asteroid_1.direction = vec2d::unit(random(360),PRECISION)
    // Create asteroid 2 (random location)
    Object asteroid_2 = object::create(object::ASTEROID)
    asteroid_2.scale = 30 * PRECISION
    asteroid_2.origin = {x:random(width),y:random(height)}
    asteroid_2.direction = vec2d::unit(random(360),PRECISION)    
    // Construct object vector
    Vector<Object> objects = vector::Vector<Object>()
    // Ship always first entry
    objects = vector::push(objects,ship)
    // Asteroids come next
    objects = vector::push(objects,asteroid_1)
    objects = vector::push(objects,asteroid_2)
    //
    return {
        window: rectangle::create(0,0,width*PRECISION,height*PRECISION),
        repeat: 10,
        objects: objects
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
    Rectangle window = state.window
    // Clear the screen
    int sx = window.x
    int sy = window.y
    ctx->clearRect(sx,sy,window.width,window.height)
    // Draw each object on the screen
    int i=0
    while i < vector::size(state.objects) where i >= 0:
        Object ith = vector::get(state.objects,i)
        // Determine polygon for object
        Polygon p1 = object::project(ith)
        // Finally, draw it
        object::draw(ctx,"#dddddd","#00",p1)
        // Determine bounding box
        Rectangle bbox = polygon::bounding_box(p1)
        // Draw X shadow (if applicable)
        if bbox.x < window.x:
            Polygon p2 = polygon::translate(p1,{dx:window.width,dy:0})
            object::draw(ctx,"#dddddd","#00",p2)
        else if (bbox.x+bbox.width) > (window.x+window.width):
            Polygon p2 = polygon::translate(p1,{dx:-window.width,dy:0})
            object::draw(ctx,"#dddddd","#00",p2)
        // Draw Y shaow (if applicable)
        if bbox.y < window.y:
            Polygon p2 = polygon::translate(p1,{dx:0,dy:window.width})
            object::draw(ctx,"#dddddd","#00",p2)
        else if (bbox.y+bbox.height) > (window.y+window.height):
            Polygon p2 = polygon::translate(p1,{dx:0,dy:-window.width})
            object::draw(ctx,"#dddddd","#00",p2)        
        //
        i = i + 1
    //
    // Write debugging text (if applicable)
    ctx->fillStyle = from_string("#000000")
    ctx->font = from_string("30px Lucida Console")
    // Determine string
    ascii::string objects = ascii::to_string(vector::size(state.objects))
    ascii::string status = array::replace_all("{} objects","{}",objects)
    ctx->fillText(from_string(status),10,30)

