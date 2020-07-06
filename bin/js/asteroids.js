'use strict';
function keyboard$State$type(status) {
   return status.length === 127;
}
const keyboard$SPACEBAR$static = 32;
const keyboard$LEFTARROW$static = 37;
const keyboard$UPARROW$static = 38;
const keyboard$RIGHTARROW$static = 39;
const keyboard$DOWNARROW$static = 40;
const keyboard$ZERO$static = 48;
const keyboard$ONE$static = 49;
const keyboard$TWO$static = 50;
const keyboard$THREE$static = 51;
const keyboard$FOUR$static = 52;
const keyboard$FIVE$static = 53;
const keyboard$SIX$static = 54;
const keyboard$SEVEN$static = 55;
const keyboard$EIGHT$static = 56;
const keyboard$NINE$static = 57;
const keyboard$A$static = 65;
const keyboard$B$static = 66;
const keyboard$C$static = 67;
const keyboard$D$static = 68;
const keyboard$E$static = 69;
const keyboard$F$static = 70;
const keyboard$G$static = 71;
const keyboard$H$static = 72;
const keyboard$I$static = 73;
const keyboard$J$static = 74;
const keyboard$K$static = 75;
const keyboard$L$static = 76;
const keyboard$M$static = 77;
const keyboard$N$static = 78;
const keyboard$O$static = 79;
const keyboard$P$static = 80;
const keyboard$Q$static = 81;
const keyboard$R$static = 82;
const keyboard$S$static = 83;
const keyboard$T$static = 84;
const keyboard$U$static = 85;
const keyboard$V$static = 86;
const keyboard$W$static = 87;
const keyboard$X$static = 88;
const keyboard$Y$static = 89;
const keyboard$Z$static = 90;
function keyboard$init() {
   return Wy.array(false, 127);
}
const main$PRECISION$static = 1000;
function main$State$type($) {
   return $.objects.length > 0;
}
function main$init(width, height) {
   let ship = object$create$Q4uint$Q6Object(object$SHIP$static);
   ship.scale = 5 * main$PRECISION$static;
   ship.origin = new Wy.Record({x: Math.floor((main$PRECISION$static * width) / 2), y: Math.floor((main$PRECISION$static * height) / 2)});
   let objects = std$collections$vector$Vector$V$Q6Vector();
    {
      const $0 = std$collections$vector$push$Q6Vectorv1T$Q6Vector(Wy.copy(objects), Wy.copy(ship));
      objects = $0;
   }
    {
      const $1 = std$collections$vector$push$Q6Vectorv1T$Q6Vector(Wy.copy(objects), main$create_random_asteroid$II$Q6Object(width, height));
      objects = $1;
   }
    {
      const $2 = std$collections$vector$push$Q6Vectorv1T$Q6Vector(Wy.copy(objects), main$create_random_asteroid$II$Q6Object(width, height));
      objects = $2;
   }
    {
      const $3 = std$collections$vector$push$Q6Vectorv1T$Q6Vector(Wy.copy(objects), main$create_random_asteroid$II$Q6Object(width, height));
      objects = $3;
   }
   return new Wy.Record({window: rectangle$create$IIII$Q9Rectangle(0, 0, width * main$PRECISION$static, height * main$PRECISION$static), repeat: 10, objects: Wy.copy(objects)});
}
function main$create_random_asteroid$II$Q6Object(width, height) {
   let asteroid = object$create$Q4uint$Q6Object(object$ASTEROID$static);
   asteroid.scale = 30 * main$PRECISION$static;
   asteroid.origin = new Wy.Record({x: js$math$random(main$PRECISION$static * width), y: js$math$random(main$PRECISION$static * height)});
   asteroid.direction = vec2d$unit$Q4uintQ4uint$Q5Vec2D(js$math$random(360), main$PRECISION$static);
   return Wy.copy(asteroid);
}
function main$update(input, s) {
   if(s.repeat > 0)  {
       {
         const $4 = s.repeat - 1;
         s.repeat = $4;
      }
   }
    {
      const $5 = main$update_ship$Q8keyboard5StateQ5State$Q5State(Wy.copy(input), Wy.copy(s));
      s = $5;
   }
    {
      const $6 = main$clip_bullets$Q5State$Q5State(Wy.copy(s));
      s = $6;
   }
   let i = 0;
   while(i < std$collections$vector$size$Q6Vector$I(Wy.copy(s.objects)))  {
      let o = std$collections$vector$get$Q6VectorI$v1T(Wy.copy(s.objects), i);
       {
         const $7 = object$move$Q6ObjectQ9Rectangle$Q6Object(Wy.copy(o), Wy.copy(s.window));
         o = $7;
      }
       {
         const $8 = std$collections$vector$set$Q6VectorIv1T$Q6Vector(Wy.copy(s.objects), i, Wy.copy(o));
         s.objects = $8;
      }
       {
         const $9 = i + 1;
         i = $9;
      }
   }
   return Wy.copy(s);
}
function main$update_ship$Q8keyboard5StateQ5State$Q5State(input, s) {
   let ship = std$collections$vector$get$Q6VectorI$v1T(Wy.copy(s.objects), 0);
   if(input[keyboard$LEFTARROW$static])  {
       {
         const $10 = (ship.angle - 5) % 360;
         ship.angle = $10;
      }
   } else  {
      if(input[keyboard$RIGHTARROW$static])  {
          {
            const $11 = (ship.angle + 5) % 360;
            ship.angle = $11;
         }
      }
   }
   if(input[keyboard$UPARROW$static])  {
      let vec = vec2d$unit$Q4uintQ4uint$Q5Vec2D(ship.angle, main$PRECISION$static);
       {
         const $12 = vec2d$add$Q5Vec2DQ5Vec2D$Q5Vec2D(Wy.copy(ship.direction), Wy.copy(vec));
         ship.direction = $12;
      }
   }
    {
      const $13 = std$collections$vector$set$Q6VectorIv1T$Q6Vector(Wy.copy(s.objects), 0, Wy.copy(ship));
      s.objects = $13;
   }
   if(input[keyboard$SPACEBAR$static] && (s.repeat === 0))  {
       {
         const $14 = std$collections$vector$push$Q6Vectorv1T$Q6Vector(Wy.copy(s.objects), main$bullet$Q5PointQ4uint$Q6Object(Wy.copy(ship.origin), ship.angle));
         s.objects = $14;
      }
      s.repeat = 10;
   }
   return Wy.copy(s);
}
function main$bullet$Q5PointQ4uint$Q6Object(p, angle) {
   let bullet = object$create$Q4uint$Q6Object(object$BULLET$static);
   bullet.scale = 5 * main$PRECISION$static;
   bullet.origin = Wy.copy(p);
   bullet.direction = vec2d$unit$Q4uintQ4uint$Q5Vec2D(angle, 10 * main$PRECISION$static);
   return Wy.copy(bullet);
}
function main$clip_bullets$Q5State$Q5State(s) {
   let i = 0;
   while(i < std$collections$vector$size$Q6Vector$I(Wy.copy(s.objects)))  {
      let o = std$collections$vector$get$Q6VectorI$v1T(Wy.copy(s.objects), i);
      if((o.type === object$BULLET$static) && (!rectangle$contains$Q9RectangleQ5Point$B(Wy.copy(s.window), Wy.copy(o.origin))))  {
         let last = std$collections$vector$top$Q6Vector$v1T(Wy.copy(s.objects));
          {
            const $15 = std$collections$vector$pop$Q6Vector$Q6Vector(Wy.copy(s.objects));
            s.objects = $15;
         }
          {
            const $16 = std$collections$vector$set$Q6VectorIv1T$Q6Vector(Wy.copy(s.objects), i, Wy.copy(last));
            s.objects = $16;
         }
      } else  {
          {
            const $17 = i + 1;
            i = $17;
         }
      }
   }
   return Wy.copy(s);
}
function main$draw(canvas, state) {
   let ctx = canvas.getContext("2d");
   let window = Wy.copy(state.window);
   let sx = window.x;
   let sy = window.y;
   ctx.clearRect(sx, sy, window.width, window.height);
   let i = 0;
   while(i < std$collections$vector$size$Q6Vector$I(Wy.copy(state.objects)))  {
      let ith = std$collections$vector$get$Q6VectorI$v1T(Wy.copy(state.objects), i);
      let p1 = object$project$Q6Object$Q7Polygon(Wy.copy(ith));
      object$draw$Q24CanvasRenderingContext2DQ6stringQ6stringaQ5Point$V(ctx, "#dddddd", "#00", Wy.copy(p1));
      let bbox = polygon$bounding_box$Q7Polygon$Q9Rectangle(Wy.copy(p1));
      if(bbox.x < window.x)  {
         let p2 = polygon$translate$Q7PolygonQ5Vec2D$Q7Polygon(Wy.copy(p1), new Wy.Record({dx: window.width, dy: 0}));
         object$draw$Q24CanvasRenderingContext2DQ6stringQ6stringaQ5Point$V(ctx, "#dddddd", "#00", Wy.copy(p2));
      } else  {
         if((bbox.x + bbox.width) > (window.x + window.width))  {
            let p2 = polygon$translate$Q7PolygonQ5Vec2D$Q7Polygon(Wy.copy(p1), new Wy.Record({dx: -window.width, dy: 0}));
            object$draw$Q24CanvasRenderingContext2DQ6stringQ6stringaQ5Point$V(ctx, "#dddddd", "#00", Wy.copy(p2));
         }
      }
      if(bbox.y < window.y)  {
         let p2 = polygon$translate$Q7PolygonQ5Vec2D$Q7Polygon(Wy.copy(p1), new Wy.Record({dx: 0, dy: window.width}));
         object$draw$Q24CanvasRenderingContext2DQ6stringQ6stringaQ5Point$V(ctx, "#dddddd", "#00", Wy.copy(p2));
      } else  {
         if((bbox.y + bbox.height) > (window.y + window.height))  {
            let p2 = polygon$translate$Q7PolygonQ5Vec2D$Q7Polygon(Wy.copy(p1), new Wy.Record({dx: 0, dy: -window.width}));
            object$draw$Q24CanvasRenderingContext2DQ6stringQ6stringaQ5Point$V(ctx, "#dddddd", "#00", Wy.copy(p2));
         }
      }
       {
         const $18 = i + 1;
         i = $18;
      }
   }
    {
      const $19 = "#000000";
      ctx.fillStyle = $19;
   }
    {
      const $20 = "30px Lucida Console";
      ctx.font = $20;
   }
   let objects = std$ascii$to_string$I$Q6string(std$collections$vector$size$Q6Vector$I(Wy.copy(state.objects)));
   let status = std$array$replace_all$av1Tav1Tav1T$av1T(Wy.toString("{} objects"), Wy.toString("{}"), Wy.copy(objects));
   ctx.fillText(Wy.fromString(status), 10, 30);
}
const object$SHIP$static = 0;
const object$SHIP_THURSTING$static = 1;
const object$BULLET$static = 2;
const object$ASTEROID$static = 3;
const object$SHAPES$static = [[new Wy.Record({x: -3, y: -3}), new Wy.Record({x: 0, y: 6}), new Wy.Record({x: 3, y: -3})], [new Wy.Record({x: -3, y: -3}), new Wy.Record({x: 0, y: 6}), new Wy.Record({x: 3, y: -3})], [new Wy.Record({x: -1, y: -1}), new Wy.Record({x: -1, y: 1}), new Wy.Record({x: 1, y: 1}), new Wy.Record({x: 1, y: -1})], [new Wy.Record({x: -1, y: 3}), new Wy.Record({x: 2, y: 3}), new Wy.Record({x: 3, y: 0}), new Wy.Record({x: 2, y: -1}), new Wy.Record({x: 2, y: -3}), new Wy.Record({x: -2, y: -2}), new Wy.Record({x: -3, y: 0})]];
function object$Object$type($) {
   return $.angle < 360;
}
function object$create$Q4uint$Q6Object(t) {
   let zero = new Wy.Record({dx: 0, dy: 0});
   let o = new Wy.Record({x: 0, y: 0});
   return new Wy.Record({type: t, origin: Wy.copy(o), direction: Wy.copy(zero), scale: 1, angle: 0});
}
function object$move$Q6ObjectQ9Rectangle$Q6Object(o, window) {
    {
      const $21 = point$translate$Q5PointQ5Vec2D$Q5Point(Wy.copy(o.origin), Wy.copy(o.direction));
      o.origin = $21;
   }
   if(o.type !== object$BULLET$static)  {
       {
         const $22 = rectangle$wrap$Q5PointQ9Rectangle$Q5Point(Wy.copy(o.origin), Wy.copy(window));
         o.origin = $22;
      }
   }
   return Wy.copy(o);
}
function object$project$Q6Object$Q7Polygon(ith) {
   let p = Wy.copy(Wy.copy(object$SHAPES$static)[ith.type]);
    {
      const $23 = polygon$scale$Q7PolygonQ4uint$Q7Polygon(Wy.copy(p), ith.scale);
      p = $23;
   }
    {
      const $24 = polygon$rotate$Q7PolygonQ4uint$Q7Polygon(Wy.copy(p), ith.angle);
      p = $24;
   }
   return polygon$translate$Q7PolygonQ5Point$Q7Polygon(Wy.copy(p), Wy.copy(ith.origin));
}
function object$draw$Q24CanvasRenderingContext2DQ6stringQ6stringaQ5Point$V(ctx, fill, line, points) {
    {
      const $25 = Wy.copy(fill);
      ctx.fillStyle = $25;
   }
    {
      const $26 = Wy.copy(line);
      ctx.strokeStyle = $26;
   }
    {
      const $27 = 3;
      ctx.lineWidth = $27;
   }
   ctx.beginPath();
   ctx.moveTo(Math.floor(points[0].x / main$PRECISION$static), Math.floor(points[0].y / main$PRECISION$static));
   let i = 1;
   while(i < points.length)  {
      ctx.lineTo(Math.floor(points[i].x / main$PRECISION$static), Math.floor(points[i].y / main$PRECISION$static));
       {
         const $28 = i + 1;
         i = $28;
      }
   }
   ctx.closePath();
   ctx.fill();
   ctx.stroke();
}
function point$scale$Q5PointQ4uint$Q5Point(point, magnitude) {
    {
      const $29 = point.x * magnitude;
      point.x = $29;
   }
    {
      const $30 = point.y * magnitude;
      point.y = $30;
   }
   return Wy.copy(point);
}
function point$translate$Q5PointQ5Vec2D$Q5Point(point, delta) {
    {
      const $31 = point.x + delta.dx;
      point.x = $31;
   }
    {
      const $32 = point.y + delta.dy;
      point.y = $32;
   }
   return Wy.copy(point);
}
function point$translate$Q5PointQ5Point$Q5Point(point, origin) {
    {
      const $33 = point.x + origin.x;
      point.x = $33;
   }
    {
      const $34 = point.y + origin.y;
      point.y = $34;
   }
   return Wy.copy(point);
}
function point$rotate$Q5PointQ4uint$Q5Point(point, angle) {
   let rads = js$math$to_radians(angle);
   let cos_rads = js$math$cos(rads) * 100;
   let sin_rads = js$math$sin(rads) * 100;
   let xp = (point.x * cos_rads) - (point.y * sin_rads);
   let yp = (point.y * cos_rads) + (point.x * sin_rads);
   return new Wy.Record({x: Math.floor(xp / 100), y: Math.floor(yp / 100)});
}
function polygon$Polygon$type(points) {
   return points.length > 0;
}
function polygon$scale$Q7PolygonQ4uint$Q7Polygon(polygon, magnitude) {
   let i = 0;
   while(i < polygon.length)  {
       {
         const $35 = point$scale$Q5PointQ4uint$Q5Point(Wy.copy(polygon[i]), magnitude);
         polygon[i] = $35;
      }
       {
         const $36 = i + 1;
         i = $36;
      }
   }
   return Wy.copy(polygon);
}
function polygon$translate$Q7PolygonQ5Point$Q7Polygon(polygon, origin) {
   let i = 0;
   while(i < polygon.length)  {
       {
         const $37 = point$translate$Q5PointQ5Point$Q5Point(Wy.copy(polygon[i]), Wy.copy(origin));
         polygon[i] = $37;
      }
       {
         const $38 = i + 1;
         i = $38;
      }
   }
   return Wy.copy(polygon);
}
function polygon$translate$Q7PolygonQ5Vec2D$Q7Polygon(polygon, delta) {
   let i = 0;
   while(i < polygon.length)  {
       {
         const $39 = point$translate$Q5PointQ5Vec2D$Q5Point(Wy.copy(polygon[i]), Wy.copy(delta));
         polygon[i] = $39;
      }
       {
         const $40 = i + 1;
         i = $40;
      }
   }
   return Wy.copy(polygon);
}
function polygon$rotate$Q7PolygonQ4uint$Q7Polygon(polygon, angle) {
   let i = 0;
   while(i < polygon.length)  {
       {
         const $41 = point$rotate$Q5PointQ4uint$Q5Point(Wy.copy(polygon[i]), angle);
         polygon[i] = $41;
      }
       {
         const $42 = i + 1;
         i = $42;
      }
   }
   return Wy.copy(polygon);
}
function polygon$bounding_box$Q7Polygon$Q9Rectangle(polygon) {
   let min_x = polygon[0].x;
   let max_x = polygon[0].x;
   let min_y = polygon[0].y;
   let max_y = polygon[0].y;
   let i = 1;
   while(i < polygon.length)  {
       {
         const $43 = std$math$min$II$I(min_x, polygon[i].x);
         min_x = $43;
      }
       {
         const $44 = std$math$max$II$I(max_x, polygon[i].x);
         max_x = $44;
      }
       {
         const $45 = std$math$min$II$I(min_y, polygon[i].y);
         min_y = $45;
      }
       {
         const $46 = std$math$max$II$I(max_y, polygon[i].y);
         max_y = $46;
      }
       {
         const $47 = i + 1;
         i = $47;
      }
   }
   let width = (max_x - min_x) + 1;
   let height = (max_y - min_y) + 1;
   return rectangle$create$IIII$Q9Rectangle(min_x, min_y, width, height);
}
function rectangle$create$IIII$Q9Rectangle(x, y, width, height) {
   return new Wy.Record({x: x, y: y, width: width, height: height});
}
function rectangle$wrap$Q5PointQ9Rectangle$Q5Point(point, r) {
    {
      const $48 = rectangle$wrap$III$I(point.x, r.x, r.y + r.width);
      point.x = $48;
   }
    {
      const $49 = rectangle$wrap$III$I(point.y, r.y, r.y + r.height);
      point.y = $49;
   }
   return Wy.copy(point);
}
function rectangle$contains$Q9RectangleQ5Point$B(r, p) {
   if((p.x < r.x) || (p.x > (r.x + r.width)))  {
      return false;
   } else  {
      if((p.y < r.y) || (p.y > (r.y + r.height)))  {
         return false;
      } else  {
         return true;
      }
   }
}
function rectangle$wrap$III$I(x, low, high) {
   if(x < low)  {
       {
         const $50 = high - (low - x);
         x = $50;
      }
   } else  {
      if(x > high)  {
          {
            const $51 = low + (x - high);
            x = $51;
         }
      }
   }
   return x;
}
function vec2d$unit$Q4uintQ4uint$Q5Vec2D(angle, magnitude) {
   let rads = js$math$to_radians(angle);
   let cos_rads = js$math$cos(rads) * magnitude;
   let sin_rads = js$math$sin(rads) * magnitude;
   let xp = -sin_rads;
   let yp = cos_rads;
   return new Wy.Record({dx: xp, dy: yp});
}
function vec2d$add$Q5Vec2DQ5Vec2D$Q5Vec2D(v1, v2) {
    {
      const $52 = v1.dx + v2.dx;
      v1.dx = $52;
   }
    {
      const $53 = v1.dy + v2.dy;
      v1.dy = $53;
   }
   return Wy.copy(v1);
}
