const encode = require('image-encode');
const decode = require('image-decode');

const SquareImageToRGBA = (buff, side) => {
    const Image = decode(buff)
    const RGBA_raw = Image.data;
    const size = RGBA_raw.length
    const pixelsSize = size/4;
    const pixelsArray = []
    for (let i = 0; i < pixelsSize; i++) {
        pixelsArray.push([
            RGBA_raw[4*i],
            RGBA_raw[4*i+1],
            RGBA_raw[4*i+2],
            RGBA_raw[4*i+3],
        ])
    }
    const RGBA = []
    for (let i = 0; i < side; i++) {
        const row = []
        for (let j = 0; j < side; j++) {
            row.push(pixelsArray[side *i + j])
        }
        RGBA.push(row)
    }
    return RGBA
}

const RGBAtoSquareImage = (rgba, ...args) => {
    const flatten = rgba.flat(3);
    if (args.length) {
        return encode(flatten, ...args)
    }
    throw new Error("No encoding arguments")
}

const createSquareBlackRGBA = (side) => {
    const blackImage = []

    for (let i = 0; i < side; i++) {
        const A = []
        for (let j = 0; j < side; j++) {
            A.push([0xff,0x00,0x00,0xff]);
        }
        blackImage.push(A)
    }
    return blackImage
}

module.exports = {
    SquareImageToRGBA,
    RGBAtoSquareImage,
    createSquareBlackRGBA
}

