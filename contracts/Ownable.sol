// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Ownable {

    address public owner;

    constructor() payable {
        owner = msg.sender;
    }


    modifier isOwner()  {
        if(msg.sender != owner){
            revert("Only Owner can call this function");
        }
        _;
    }

    function checkBalance(address _address) view public isOwner returns(uint){
        return _address.balance;
    }

    function switchOwner(address _address) public isOwner {
        require(_address != address(0),"Invalid Address...");
        owner = _address;
    }

    
}