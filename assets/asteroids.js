var input = keyboard$init()
    
function keyPressed(event) {
    input[event.keyCode] = true;
}

function keyReleased(event) {
    input[event.keyCode] = false;
}

function run(document,canvas) {
    document.addEventListener("keydown",keyPressed, false);
    document.addEventListener("keyup",keyReleased, false);
    var state = main$init(canvas.width,canvas.height);
    mainLoop(canvas,state);
}

function mainLoop(canvas,state) {      
    state = main$update(input,state);
    main$draw(canvas,state);    
    requestAnimationFrame(() => mainLoop(canvas,state));
}

