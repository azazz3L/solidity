// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract EthersWallet {

    event Transfered(bool,bytes);
    event Transferring(address,address,uint);

    address private owner;
    mapping(address => uint) internal balances;

    modifier isOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
        }

    modifier suffBal(uint _value, address _from) {
        require(_value <= balances[_from], "Insufficient Balance");
        _;
    }

    constructor() {
        owner = msg.sender;
    }


    receive() external payable{
        balances[msg.sender] += msg.value;
    }


    function changeBalance(address _to,address _from,uint _value) internal suffBal(_value,_from) {

        balances[_to] += _value;
        balances[_from] -= _value;

        emit Transferring(_to,_from,msg.value);

    }

    function withdraw(address _to,address _from, uint _value) external isOwner {

       (bool success, bytes memory data) = _to.call{value: _value}("");
       changeBalance(_to,_from,_value);
        emit Transfered(success,data);

    }

    function userBalance() external view returns(uint){
        return balances[msg.sender];
    }
}