pragma solidity >=0.4.21 <0.6.0;

import {othelloDecide_Verifier as OthelloDecideVerifier} from "./verifiers/othelloDecide_Verifier.sol";
import {othelloMove_Verifier as OthelloMoveVerifier} from "./verifiers/othelloMove_Verifier.sol";


contract Othello {

  enum SessionState { Created, Ongoing, Finished }

  struct Session {
    address user1;
    address user2;
    address winner;
    SessionState state;
    uint8[8][8] board;
  }

  Session[] public sessions;

  uint256 public constant FEE = 0.5 ether;

  OthelloDecideVerifier public othelloDecideVerifier;
  OthelloMoveVerifier public othelloMoveVerifier;

  modifier checkDeposit() {
    require(msg.value == FEE, "Check deposit amount");
    _;
  }

  modifier onlyState(uint256 _sessionId, SessionState _state) {
    require(sessions[_sessionId].state == _state, "Invalid session state");
    _;
  }

  constructor(OthelloDecideVerifier _othelloDecideVerifier, OthelloMoveVerifier _othelloMoveVerifier
  ) public {
     othelloDecideVerifier = _othelloDecideVerifier;
     othelloMoveVerifier = _othelloMoveVerifier;
  }

  function createSession() external payable checkDeposit {
    Session storage s = sessions[sessions.length++];

    s.user1 = msg.sender;
    s.board[3][3] = 2;
    s.board[3][4] = 1;
    s.board[4][3] = 1;
    s.board[4][4] = 2;
    s.state = SessionState.Created;
  }

  function joinSession(uint256 _sessionId)
    external
    payable
    checkDeposit
    onlyState(_sessionId, SessionState.Created)
  {
    Session storage s = sessions[_sessionId];
    require(s.user1 != msg.sender, "Players have to be distinct");

    s.user2 = msg.sender;
    s.state = SessionState.Ongoing;
  }

  function move(uint256 _sessionId) external {

  }
}