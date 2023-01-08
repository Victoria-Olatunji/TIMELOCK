// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract TimeLock {
    //Using SafeMath for uint;
    using SafeMath for uint; 

    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

//function to increase locktime
    function increaseLockTime(uint _time) public {
        //lockTime[msg.sender] += _time;
        //lockTime[msg.sender] = lockTime[msg.sender] + _time;
        lockTime[msg.sender] = lockTime[msg.sender].add(_time); //add function from SafeMath takes care of uint overflow
    }
//function to withdraw
    function withdraw() public {
        require(balances[msg.sender] > 0, "You do not have enough ether");
         require(block.timestamp > lockTime[msg.sender], "The locktime has not expired");

         uint balance = balances[msg.sender];
         balances[msg.sender] = 0; //balance of the msg.sender, to nullify the amount the person has

         (bool sent,) = msg.sender.call{value: balance}("");
         require(sent,"It did not go through");
    }
}