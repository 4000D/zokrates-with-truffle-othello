const { expectEvent } = require('openzeppelin-test-helpers');
const Reversi = require('clovers-reversi').default;

const chai = require('chai');

const {
  convertBoard,
  copy,
} = require('../scripts/utils');

const {
  initialized,
  getOthelloMoveProof,
} = require('../scripts/docker');

const { expect } = chai;

const OthelloDecideVerifier = artifacts.require('othelloDecide_Verifier.sol');
const OthelloMoveVerifier = artifacts.require('othelloMove_Verifier.sol');
const Othello = artifacts.require('Othello.sol');

contract('Othello', ([user1, user2, ...accounts]) => {
  before(async function () {
    await initialized();

    this.game = new Reversi();
    this.othelloDecideVerifier = await OthelloDecideVerifier.new();
    this.othelloMoveVerifier = await OthelloMoveVerifier.new();
    this.othello = await Othello.new(
      this.othelloDecideVerifier.address,
      this.othelloMoveVerifier.address,
    );
    this.fee = await this.othello.FEE();
  });

  describe('#sessions', () => {
    const sessionId = 0;

    it('can create a session', async function () {
      await this.othello.createSession({ from: user1, value: this.fee });
      const session = await this.othello.sessions(sessionId);
      expect(session.user1).to.be.equal(user1);
    });

    it('should join sessions', async function () {
      await this.othello.joinSession(sessionId, { from: user2, value: this.fee });
      const session = await this.othello.sessions(sessionId);
      expect(session.user2).to.be.equal(user2);
    });

    it('play a game', async function () {
      const users = [user1, user2];
      const pickUser = (player) => users[player - 1];

      let prePlayer = 2;
      let curPlayer = 1;

      this.game.makeVisualBoard();
      console.log(this.game.visualBoard);

      let move;
      while ((move = this.game.pickRandomMove())) {
        const [x, y] = move;

        const preBoard = convertBoard(this.game.board);

        console.log(`Player ${curPlayer} move: ${move}`);
        this.game.makeMove(move);

        const curBoard = convertBoard(this.game.board);

        this.game.makeVisualBoard();
        console.log(this.game.visualBoard);

        const proof = await getOthelloMoveProof(curPlayer, x, y, preBoard, curBoard);

        console.log('Proof', proof);

        [prePlayer, curPlayer] = [curPlayer, prePlayer];
      }

      const winner = prePlayer;


    });
  });
});
