// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.9;

import "hardhat/console.sol";

contract WavePortal {

    uint256 constant PRIZE_AMOUNT = 0.0001 ether;

    uint256 public totalWaves;

    mapping(address => string) waverNames;

    struct Wave {
        address waver;
        string name;
        uint256 timestamp;
        string message;
    }

    Wave[] waves;

    event NewWave(address indexed from, uint256 timestamp, string message);

    constructor() payable {}

    function wave(string memory _message) public {
      totalWaves += 1;
      console.log("%s wave us witho following message: %s!", msg.sender, _message);
      string memory _name = waverNames[msg.sender];
      waves.push(Wave(msg.sender, _name, block.timestamp, _message));
      emit NewWave(msg.sender, block.timestamp, _message);

      require(PRIZE_AMOUNT <= address(this).balance, "Insufficient contract balance");

      (bool success, ) = (msg.sender).call{value: PRIZE_AMOUNT}("");
      require(success, "Failed to send Ether");
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