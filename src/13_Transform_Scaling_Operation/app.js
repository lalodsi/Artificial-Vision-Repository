const fs = require("fs")
const {
    SquareImageToRGBA,
    RGBAtoSquareImage,
    createSquareBlackRGBA
} = require("../../js/ImageFunctions");

const ImageBuffer = fs.readFileSync(__dirname + "\\foto100px.jpg");

// Decoding image to a RGBA matrix
const OriginalSize = 100
const zoom = 5
const NewSize = OriginalSize * zoom
const RGBA = SquareImageToRGBA(ImageBuffer, OriginalSize)

function getAverageBetweenSquares(row, col, oldImage) {
    const beforeRowIndex = Math.floor(row / zoom);
    const afterRowIndex = (beforeRowIndex + 1) >= OriginalSize ? OriginalSize - 1 : beforeRowIndex + 1;
    const beforeColIndex = Math.floor(col / zoom);
    const afterColIndex = (beforeColIndex + 1) >= OriginalSize ? OriginalSize - 1 : beforeColIndex + 1;

    const pixelTopLeft = oldImage[beforeRowIndex][beforeColIndex]
    const pixelTopRight = oldImage[beforeRowIndex][afterColIndex]
    const pixelBottomLeft = oldImage[afterRowIndex][beforeColIndex]
    const pixelBottomRight = oldImage[afterRowIndex][afterColIndex]

    const average = []
    for (let i = 0; i < 3; i++) {
        // console.log(pixelTopLeft[i], pixelTopRight[i], pixelBottomLeft[i], pixelBottomRight[i], row, col)
        const sum = Math.floor((pixelTopLeft[i] + pixelTopRight[i] + pixelBottomLeft[i] + pixelBottomRight[i]) / 4)
        average.push(sum)
    }
    average.push(0xff)
    return average
}

//Aplying x2 zoom with a bad algoritmh
const pixelatedImage = createSquareBlackRGBA(NewSize);
for (let row = 0; row < NewSize; row++) {
    for (let col = 0; col < NewSize; col++) {
        const floor = Math.floor
        pixelatedImage[row][col] = RGBA[floor(row/zoom)][floor(col/zoom)]
    }
}

function hexSum(a, b) {
    return (parseInt(a, 16) + b).toString(16)
}

// Applying x2 zoom with an average algorithm
const newRGBA = createSquareBlackRGBA(NewSize);
for (let row = 0; row < NewSize; row++) {
    for (let col = 0; col < NewSize; col++) {
        const floor = Math.floor
        if (row%zoom === 0 && col%zoom === 0) {
            newRGBA[row][col] = RGBA[floor(row/zoom)][floor(col/zoom)]
        }
        const average = getAverageBetweenSquares(row, col, RGBA)
        newRGBA[row][col] = [...average]
        
        if (row%zoom !== 0 && col%zoom !== 0) {
            // newRGBA[row][col] = [0x00, 0xff, 0xff, 0xff]
        }
    }
}



// Encode image
const pixelatedFile = new Buffer.from(RGBAtoSquareImage(pixelatedImage, [NewSize, NewSize], 'png'))
const newImageFile = new Buffer.from(RGBAtoSquareImage(newRGBA, [NewSize, NewSize], 'png'))


fs.writeFileSync('./src/13_Transform_Scaling_Operation/resultadoPromedios.png', newImageFile)
fs.writeFileSync('./src/13_Transform_Scaling_Operation/resultadoPixelado.png', pixelatedFile)