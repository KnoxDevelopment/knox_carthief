let job = "none"
let jobaccepted = "none"
let acceptwork = false

let Elettricista_Status = false
let completedLights = [0, 0, 0, 0]
let completedTimes = 0
let tempo = 34
const positions = {
	drag1: {positions: [0, 188, 376, 564]},
	drag2: {positions: [-188, 0, 188, 376]},
	drag3: {positions: [-376, -188, 0, 188]},
	drag4: {positions: [-564, -376, -188, 0]}
}
const colors = {
	blue: {inner: "#25378d", outer: "#324d9c"},
	red: {inner: "#a71916", outer: "#e52320"},
	yellow: {inner: "#aa9f17", outer: "#ffeb13"},
	purple: {inner: "#90378c", outer: "#a6529a"},
}

// shuffleColors()
// startTimeout()

window.addEventListener("message", function(e) {
	if(e.data.show === true) {
		$('#stocazzo').fadeIn()
		$('#stocazzo2').fadeIn()
		shuffleColors()
		startTimeout()
	}
})

function shuffleColors() {
    Elettricista_Status = false;

	let generatedIndexes = []
    
	while(generatedIndexes.length < 4){
        let r = Math.floor(Math.random() * 4);
		if(generatedIndexes.indexOf(r) === -1) generatedIndexes.push(r);
	}
    
    $(".drag-*").prop("disabled", false);
    $(".line-*").prop("disabled", false);

	console.log(generatedIndexes)

	new Draggable('.drag-1', {
		onDrag: function () {
			updateLine('.line-1', this.x + 120, this.y + 185);
		},
	
		onRelease: function () {
			if (this.x !== 670 || this.y !== positions.drag1.positions[generatedIndexes[0]] ) {
				reset('.drag-1', '.line-1', 70, 185);
				toggleLight(generatedIndexes[0] + 1, false);
			} else if (this.x === 670 && this.y === positions.drag1.positions[generatedIndexes[0]]) toggleLight(generatedIndexes[0] + 1, true)
		},
	
		liveSnap: {points: [{x: 670, y: positions.drag1.positions[generatedIndexes[0]]}], radius: 20}
	});

	if(positions.drag1.positions[generatedIndexes[0]] == 0) {
		$('.o').css("fill", colors.blue.inner);
		$('.p').css("fill", colors.blue.outer);
	} 
	if(positions.drag1.positions[generatedIndexes[0]] == 188) {
		$('.m').css("fill", colors.blue.inner);
		$('.n').css("fill", colors.blue.outer);
	} 
	if(positions.drag1.positions[generatedIndexes[0]] == 376) {
		$('.q').css("fill", colors.blue.inner);
		$('.r').css("fill", colors.blue.outer);
	} 
	if(positions.drag1.positions[generatedIndexes[0]] == 564) {
		$('.s').css("fill", colors.blue.inner);
		$('.t').css("fill", colors.blue.outer);
	}
	
	new Draggable('.drag-2', {
		onDrag: function () {
			updateLine('.line-2', this.x + 120, this.y + 375);
		},
	
		onRelease: function () {
			if (this.x !== 670 || this.y !== positions.drag2.positions[generatedIndexes[1]] ) {
				reset('.drag-2', '.line-2', 60, 375);
				toggleLight(generatedIndexes[1] + 1, false);
			} else if (this.x === 670 && this.y === positions.drag2.positions[generatedIndexes[1]]) toggleLight(generatedIndexes[1] + 1, true)
		},
	
		liveSnap: {points: [{x: 670, y: positions.drag2.positions[generatedIndexes[1]]}], radius: 20}
	});
	
	if(positions.drag2.positions[generatedIndexes[1]] == -188) {
		$('.o').css("fill", colors.red.inner);
		$('.p').css("fill", colors.red.outer);
	} 
	if(positions.drag2.positions[generatedIndexes[1]] == 0) {
		$('.m').css("fill", colors.red.inner);
		$('.n').css("fill", colors.red.outer);
	} 
	if(positions.drag2.positions[generatedIndexes[1]] == 188) {
		$('.q').css("fill", colors.red.inner);
		$('.r').css("fill", colors.red.outer);
	} 
	if(positions.drag2.positions[generatedIndexes[1]] == 376) {
		$('.s').css("fill", colors.red.inner);
		$('.t').css("fill", colors.red.outer);
	}
	
	new Draggable('.drag-3', {
		onDrag: function () {
			updateLine('.line-3', this.x + 120, this.y + 560);
		},
	
		onRelease: function () {
			if (this.x !== 670 || this.y !== positions.drag3.positions[generatedIndexes[2]] ) {
				reset('.drag-3', '.line-3', 60, 560);
				toggleLight(generatedIndexes[2] + 1, false);
			} else if (this.x === 670 && this.y === positions.drag3.positions[generatedIndexes[2]]) toggleLight(generatedIndexes[2] + 1, true)
		},
	
		liveSnap: {points: [{x: 670, y: positions.drag3.positions[generatedIndexes[2]]}], radius: 20}
	});
	
	if(positions.drag3.positions[generatedIndexes[2]] == -376) {
		$('.o').css("fill", colors.yellow.inner);
		$('.p').css("fill", colors.yellow.outer);
	}
	if(positions.drag3.positions[generatedIndexes[2]] == -188) {
		$('.m').css("fill", colors.yellow.inner);
		$('.n').css("fill", colors.yellow.outer);
	}
	if(positions.drag3.positions[generatedIndexes[2]] == 0) {
		$('.q').css("fill", colors.yellow.inner);
		$('.r').css("fill", colors.yellow.outer);
	}
	if(positions.drag3.positions[generatedIndexes[2]] == 188) {
		$('.s').css("fill", colors.yellow.inner);
		$('.t').css("fill", colors.yellow.outer);
	}
	
	new Draggable('.drag-4', {
		onDrag: function () {
			updateLine('.line-4', this.x + 120, this.y + 745);
		},
	
		onRelease: function () {
			if (this.x !== 670 || this.y !== positions.drag4.positions[generatedIndexes[3]] ) {
				reset('.drag-4', '.line-4', 60, 745);
				toggleLight(generatedIndexes[3] + 1, false);
			} else if (this.x === 670 && this.y === positions.drag4.positions[generatedIndexes[3]]) toggleLight(generatedIndexes[3] + 1, true)
		},
	
		liveSnap: {points: [{x: 670, y: positions.drag4.positions[generatedIndexes[3]]}], radius: 20}
	});
	
	if(positions.drag4.positions[generatedIndexes[3]] == -564) {
		$('.o').css("fill", colors.purple.inner);
		$('.p').css("fill", colors.purple.outer);
	}
	if(positions.drag4.positions[generatedIndexes[3]] == -376) {
		$('.m').css("fill", colors.purple.inner);
		$('.n').css("fill", colors.purple.outer);
	}
	if(positions.drag4.positions[generatedIndexes[3]] == -188) {
		$('.q').css("fill", colors.purple.inner);
		$('.r').css("fill", colors.purple.outer);
	}
	if(positions.drag4.positions[generatedIndexes[3]] == 0) {
		$('.s').css("fill", colors.purple.inner);
		$('.t').css("fill", colors.purple.outer);
	}

    Elettricista_Status = true;
}

function startTimeout() {
	$('#progressbar').css("animation-name", "progbar")
	let interval = setInterval(() => {
		$('#tempo').text(tempo)
		tempo -= 1;

		if(tempo < 0) {
			clearInterval(interval)
			if(completedTimes == 3) {
				completedTimes = 0
				$.post('https://knox_carthief/hacking_finished', JSON.stringify({result: true}))
				$('#stocazzo').fadeOut()
				$('#stocazzo2').fadeOut()
				setTimeout(() => {
					location.reload()
				}, 300);
			} else if(completedTimes < 3) {
				completedTimes = 0
				$('#stocazzo').fadeOut()
				$('#stocazzo2').fadeOut()
				setTimeout(() => {
					$.post('https://knox_carthief/hacking_finished', JSON.stringify({result: false}))
					location.reload()
				}, 300);
			}
		}
	}, 1000);
}

function updateLine(selector, x, y) {
	gsap.set(selector, {
		attr: {
			x2: x,
			y2: y
		}
	});
}

function toggleLight(selector, visibility) {
	if (visibility) {
		completedLights[selector - 1] = 1;
		if (completedLights[0] === 1 && completedLights[1] === 1 && completedLights[2] === 1 && completedLights[3] === 1 && Elettricista_Status==true) {
			Elettricista_Status = false;
            audioTask.play();
			completedTimes += 1;
			$('#voltecompletate').text(completedTimes)
            $(".drag-*").prop("disabled", true);
            $(".line-*").prop("disabled", true);
			window.setTimeout(() => {
				reset('.drag-1', '.line-1', 70, 185);
				reset('.drag-2', '.line-2', 60, 375);
				reset('.drag-3', '.line-3', 60, 560);
				reset('.drag-4', '.line-4', 60, 745);
				toggleLight(2, false);
				toggleLight(1, false);
				toggleLight(3, false);
				toggleLight(4, false);

				shuffleColors()
				
				if(completedTimes == 3) {
					completedTimes = 0
					$.post('https://knox_carthief/hacking_finished', JSON.stringify({result: true}))
					$('#stocazzo').fadeOut()
					$('#stocazzo2').fadeOut()
					setTimeout(() => {
						location.reload()
					}, 300);
				}
			}, 2000);
		}
	} else {
		completedLights[selector - 1] = 0;
	}

	gsap.to(`.light-${selector}`, {
		opacity: visibility ? 1 : 0,
		duration: 0.3
	});
}

function reset(drag, line, x, y) {
	gsap.to(drag, {
		duration: 0.3,
		ease: 'power2.out',
		x: 0,
		y: 0
	});
	gsap.to(line, {
		duration: 0.3,
		ease: 'power2.out',
		attr: {
			x2: x,
			y2: y
		}
	});
}

const audioTask = new Audio('https://assets.codepen.io/127738/Among_Us-Task-complete.mp3');
