import std::math
import uint from std::integer
import rectangle with Rectangle
import point with Point
import Vec2D from vec2d

/**
 * Provides basic functions for manipulating and drawing 
 * polygons.  A polygon is a sequence of one or more points, 
 * where the last joins back to the first. For example, the 
 * polygon (0,3),(0,0),(3,0) describes the following area:
 *
 *  3|A|_|_|_|
 *  2|#|#|_|_|
 *  1|#|#|#|_|
 *  0|B|#|#|C|
 *    0 1 2 3
 *
 * Here, we see the three points in the order they are 
 * drawn and where the interior of the polygon is denoted 
 * with # symbols.
 */

// A polygon is simply an array of one or more points.
public type Polygon is (Point[] points)
// Must be at least one point!
where |points| > 0

/**
 * Scale a polygon by a given magnitude.  In other words, 
 * make it bigger (or smaller).
 */
public function scale(Polygon polygon, uint magnitude) -> Polygon:
    uint i = 0
    while i < |polygon|:
        polygon[i] = point::scale(polygon[i],magnitude)
        i = i + 1
    //
    return polygon

/**
 * Translate (i.e. move) a given polygon to a given point
 * (usually a physical on the screen).
 */
public function translate(Polygon polygon, Point origin) -> Polygon:
    uint i = 0
    while i < |polygon|:
        polygon[i] = point::translate(polygon[i],origin)
        i = i + 1
    //
    return polygon

/**
 * Translate (i.e. move) a given polygon along a given vector.
 */
public function translate(Polygon polygon, Vec2D delta) -> Polygon:
    uint i = 0
    while i < |polygon|:
        polygon[i] = point::translate(polygon[i],delta)
        i = i + 1
    //
    return polygon

/**
 * Rotate a given polygon by a given angle (in degrees).
 */
public function rotate(Polygon polygon, uint angle) -> Polygon
// Angle is an angle :)
requires angle <= 360:
    //
    uint i = 0
    while i < |polygon|:
        polygon[i] = point::rotate(polygon[i],angle)
        i = i + 1
    //
    return polygon

/**
 * Determine the smallest bounding box for a given polygon.
 */
public function bounding_box(Polygon polygon) -> Rectangle:
    int min_x = polygon[0].x
    int max_x = polygon[0].x
    int min_y = polygon[0].y
    int max_y = polygon[0].y
    //
    int i = 1
    while i < |polygon|:
        min_x = math::min(min_x,polygon[i].x)
        max_x = math::max(max_x,polygon[i].x)
        min_y = math::min(min_y,polygon[i].y)
        max_y = math::max(max_y,polygon[i].y)
        i = i + 1
    //
    int width = (max_x-min_x) + 1
    int height = (max_y-min_y) + 1
    //
    return rectangle::create(min_x,min_y,width,height)