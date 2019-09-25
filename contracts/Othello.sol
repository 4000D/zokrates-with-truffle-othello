pragma solidity >=0.4.21 <0.6.0;

contract Othello {

  enum SessionState { Created, Ongoing, Finished }

  struct Board{
    uint b00; uint b01; uint b02; uint b03; uint b04; uint b05; uint b06; uint b07;
    uint b10; uint b11; uint b12; uint b13; uint b14; uint b15; uint b16; uint b17;
    uint b20; uint b21; uint b22; uint b23; uint b24; uint b25; uint b26; uint b27;
    uint b30; uint b31; uint b32; uint b33; uint b34; uint b35; uint b36; uint b37;
    uint b40; uint b41; uint b42; uint b43; uint b44; uint b45; uint b46; uint b47;
    uint b50; uint b51; uint b52; uint b53; uint b54; uint b55; uint b56; uint b57;
    uint b60; uint b61; uint b62; uint b63; uint b64; uint b65; uint b66; uint b67;
    uint b70; uint b71; uint b72; uint b73; uint b74; uint b75; uint b76; uint b77;
  }

  struct Session {
    address user1;
    address user2;
    address winner;
    SessionState state;
  }

  Session[] public sessions;

  uint256 public constant FEE = 0.5 ether;

  modifier checkDeposit() {
    require(msg.value == FEE, "Check deposit amount");
    _;
  }

  modifier onlyState(uint256 _sessionId, SessionState _state) {
    require(sessions[_sessionId].state == _state, "Invalid session state");
    _;
  }

  function createSession() external payable checkDeposit {
    Session storage s = sessions[sessions.length++];
    s.user1 = msg.sender;
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

  function move(uint256 _sessionId) {

  }
}