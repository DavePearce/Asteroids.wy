import main
import Point from point

/**
 * Represents a rectangle in 2-Dimensional space.
 */
public type Rectangle is {
    int x,
    int y,
    int width,
    int height
}

/**
 * Construct a new rectangle with given position and dimensions.
 */
public function create(int x, int y, int width, int height) -> Rectangle:
    return {x:x,y:y,width:width,height:height}

/**
 * Wrap a given point in a given rectangle.
 */
public function wrap(Point point, Rectangle r) -> Point:
    //
    point.x = wrap(point.x,r.x,r.y + r.width)
    point.y = wrap(point.y,r.y,r.y + r.height)    
    return point

/**
 * Check whether a given point is within a rectangle.
 */
function contains(Rectangle r, Point p) -> bool:
    //
    if p.x < r.x || p.x > (r.x + r.width):
        return false
    else if p.y < r.y || p.y > (r.y + r.height):
        return false
    else:
        return true

// Helpers

function wrap(int x, int low, int high) -> int:
    if x < low:
        x = high - (low-x)
    else if x > high:
        x = low + (x-high)
    //
    return x

