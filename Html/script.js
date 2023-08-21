
window.addEventListener("message", function(event) {
    var eventData = event.data;

    if (eventData.type === "mostramessaggio") {
        mostramessaggio(eventData.image, eventData.text, eventData.duration);
    } else if (eventData.type === "toglinui") {
        document.querySelector(".container-mess").style.display = "none";
    } else if (eventData.type === "mostramessaggio2") {
        mostramessaggio2(eventData.image, eventData.text, eventData.duration);
    }
});

function mostramessaggio(imageSrc, text, duration) {
    const messageImage = document.getElementById("immaginemessaggio");
    const messageText = document.getElementById("testomessaggio");

    messageImage.src = imageSrc;
    typewriterEffect(messageText, text, 1000);

    document.querySelector(".container-mess").style.display = "block";
}

function mostramessaggio2(imageSrc, text, duration) {
    const messageImage = document.getElementById("immaginemessaggio");
    const messageText = document.getElementById("testomessaggio");

    messageImage.src = imageSrc;
    messageText.textContent = text;

    document.querySelector(".container-mess").style.display = "block";
}


function mostratesto(text, duration) {
    const messageText = document.getElementById("testomessaggio");
    document.querySelector(".container-mess").style.display = "block";
    typewriterEffect(messageText, text, duration);

}

function typewriterEffect(element, text, duration) {
    let currentIndex = 0;
    const interval = duration / text.length; 

    element.textContent = ""; 

    const typingInterval = setInterval(function() {
        if (currentIndex < text.length) {
            element.textContent += text[currentIndex];
            currentIndex++;
        } else {
            clearInterval(typingInterval); 
        }
    }, interval);
}

