Array.prototype.sample = function(){
    return this[Math.floor(Math.random()*this.length)];
}

let imageNum = [
    "001", "002", "003", "004", "005", "006", "007", "008", "009"
].sample()
let imageThumbSrc = `./img/game/${imageNum}-thumb.png`
let imageSrc = `./img/game/${imageNum}.png`

document.getElementById("index-pic").setAttribute("src", imageThumbSrc)
document.getElementById("index-pic-link").setAttribute("href", imageSrc)