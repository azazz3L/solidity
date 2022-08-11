// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;


contract MultiSigWallet{

    event Deposit(address ,uint);
    event Approve(uint, address);
    event Revoke(uint, address);

    address[] private owners;
    mapping(address => bool) public isOwner;
    uint private required;
    mapping(uint => mapping(address => bool)) private approval;

    struct Transaction{
        address payable to;
        uint value;
        bool executed;
    }

    Transaction[] public transactions;

    constructor(address[] memory _owners, uint _required) payable {
        for(uint i=0; i < _owners.length; i++){
            address owner = _owners[i];

            require(!isOwner[owner],"Already Exists...");
            owners.push(owner);
            isOwner[owner] = true;
        }
        required = _required;
    }

    modifier notApproved(uint _txId) {
        require(!approval[_txId][msg.sender],"Transaction Already Approved...");
        _;
    }

    modifier existTrans(uint _txId) {
        require(_txId <= transactions.length - 1,"Transaction Does not Exist...");
        _;
    }

    modifier onlyOwner{
        require(isOwner[msg.sender] ,"Not the Owner....");
        _;
    }

    modifier isApproved(uint _txId){
        require(approval[_txId][msg.sender], "Transaction Not Approved...");
        _;
    }

    modifier isNotExec(uint _txId){
        Transaction memory transaction = transactions[_txId];
        require(!transaction.executed, "Transaction Already Executed");
        _;
    }

    function canExec(uint _txId) public view returns(uint count){
        for(uint i; i < owners.length ; i++){
            if(approval[_txId][owners[i]]){
                count += 1;
            }
        }
    }

    receive() external payable{
        emit Deposit(msg.sender ,msg.value);
    }

    function makeTransaction(address payable _to, uint _value) external onlyOwner{
        transactions.push(Transaction(_to,_value,false));

    }

    function approveTransaction(uint _txId) external notApproved(_txId) existTrans(_txId) onlyOwner isNotExec(_txId){

        approval[_txId][msg.sender] = true;
        emit Approve(_txId, msg.sender);

    }

    function revokeApproval(uint _txId) external isApproved(_txId) existTrans(_txId) onlyOwner isNotExec(_txId){

        approval[_txId][msg.sender] = false;
        emit Revoke(_txId, msg.sender);
    }

    function executeTransaction(uint _txId) external payable existTrans(_txId) onlyOwner isNotExec(_txId) {
        require(canExec(_txId) >= required, "Not Enough Approvals...");
        Transaction storage transaction = transactions[_txId]; 
        (bool success, ) = transaction.to.call{value: transaction.value}("");
        require(success, "Transaction Failed...");
        transaction.executed = true;
        
    }
}