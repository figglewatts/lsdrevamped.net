let yearEl = document.getElementById("footer-year")
yearEl.textContent = new Date().getFullYear().toString()

Array.prototype.sample = function () {
    return this[Math.floor(Math.random() * this.length)];
}

let textureSet = [
    "a", "b", "c", "d"
].sample()
let bgImageSrc = `../img/bg-${textureSet}.png`
document.querySelector("html").setAttribute("style", `background-image: url("${bgImageSrc}")`)