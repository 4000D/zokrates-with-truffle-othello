const Reversi = require('clovers-reversi').default;

const game = new Reversi();

let i = 0;

i += 1;

console.log(`before move ${i}`);
game.makeVisualBoard();
console.log(game.visualBoard);

move = game.pickRandomMove();
console.log(`move#${i}`, move);
game.makeMove(move);

game.makeVisualBoard();
console.log(`after move ${i}`);
console.log(game.visualBoard);

i += 1;

console.log(`before move ${i}`);
game.makeVisualBoard();
console.log(game.visualBoard);

move = game.pickRandomMove();
console.log(`move#${i}`, move);
game.makeMove(move);

game.makeVisualBoard();
console.log(`after move ${i}`);
console.log(game.visualBoard);

i += 1;

console.log(`before move ${i}`);
game.makeVisualBoard();
console.log(game.visualBoard);

move = game.pickRandomMove();
console.log(`move#${i}`, move);
game.makeMove(move);

game.makeVisualBoard();
console.log(`after move ${i}`);
console.log(game.visualBoard);
