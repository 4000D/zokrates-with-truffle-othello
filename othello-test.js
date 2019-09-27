const Reversi = require('clovers-reversi').default;
const { convertBoard } = require('./scripts/utils');

let curGame = new Reversi();
let preGame = new Reversi(curGame);

let i = 0;

console.log(JSON.stringify(curGame.board));
console.log(JSON.stringify(convertBoard(curGame.board)));

console.log('----');
console.log('----');


while (!curGame.complete) {
  i += 1;
  curGame = new Reversi(preGame);

  curGame.makeVisualBoard();
  console.log(`before move ${i}`);
  console.log(curGame.visualBoard);

  const move = curGame.pickRandomMove();
  console.log(`move#${i}`, move);
  curGame.makeMove(move);

  curGame.makeVisualBoard();
  console.log(`after move ${i}`);
  console.log(curGame.visualBoard);

  preGame = new Reversi(curGame);
  curGame.isComplete();
}
