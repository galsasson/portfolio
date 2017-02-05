console.log("111");

var mx = -50;
var my = -50;
var time = 0;

var stem;
var mousePress;

function setup() {
  var canvas = createCanvas(600, 300);
  canvas.parent('canvas');
  canvas.position(-400, windowHeight-300);

  stem = new Stem(200);
  stem.x = 200;
  stem.y = 270;
}

function draw() {
  clear();
//  background(200);
  stem.update();
  stem.draw(mousePress);
}

function mousePressed() {
  mousePress = true;
}

function mouseReleased() {
  mousePress = false;
}

// var whereAt = (function() {
//   if (window.pageXOffset != undefined) {
//     return function(ev) {
//       return [ev.clientX + window.pageXOffset,
//         ev.clientY + window.pageYOffset
//       ];
//     }
//   } else return function() {
//     var ev = window.event,
//       d = document.documentElement,
//       b = document.body;
//     return [ev.clientX + d.scrollLeft + b.scrollLeft,
//       ev.clientY + d.scrollTop + b.scrollTop
//     ];
//   }
// })()


// document.ondblclick = function(e) {
//   alert(whereAt(e))
// };

// document.onmousemove = function(e) {
//   var coords = whereAt(e);
//   mx = coords[0];
//   my = coords[1];
// }




fract = function(num) {
  return num - floor(num);
}