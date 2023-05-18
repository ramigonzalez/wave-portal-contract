// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.9;

import "hardhat/console.sol";

contract WavePortal {

    uint256 constant PRIZE_AMOUNT = 0.0001 ether;
    uint256 private seed;
    uint256 public totalWaves;

    mapping(address => string) waverNames;
    mapping(address => uint256) public lastWavedAt;
    
    struct Wave {
      address waver;
      string name;
      uint256 timestamp;
      string message;
    }

    Wave[] waves;

    event NewWave(address indexed from, uint256 timestamp, string message, string name);

    constructor() payable {
      seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
      require(lastWavedAt[msg.sender] + 2 minutes < block.timestamp, "Wait more 2 minutes for next wave =D");
      lastWavedAt[msg.sender] = block.timestamp;

      totalWaves += 1;
      console.log("%s wave us with following message: %s!", msg.sender, _message);
      string memory _name = waverNames[msg.sender];
      waves.push(Wave(msg.sender, _name, block.timestamp, _message));
      
      seed = (block.difficulty + block.timestamp + seed) % 100;
      console.log("# Random number generated: %d", seed);
      
      // 50% chance of winning the prize
      if (seed <= 50) {
        console.log("%s wins!", msg.sender);
        require(PRIZE_AMOUNT <= address(this).balance, "Insufficient contract balance");

        (bool success, ) = (msg.sender).call{value: PRIZE_AMOUNT}("");
        require(success, "Failed to send Ether");
      }
      emit NewWave(msg.sender, block.timestamp, _message, _name);
    }

    function getAllWaves() public view returns (Wave[] memory) {
      return waves;
    }

    function setName(string memory _name) public {
      waverNames[msg.sender] = _name;
    }

    function getName() public view returns(string memory) {
      return waverNames[msg.sender];
    }
}