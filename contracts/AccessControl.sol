// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10;

contract AccessControl {

    event grantRole(bytes32 indexed role, address indexed account);
    event revokedRole(bytes32 indexed role, address indexed account);

    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 public constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    //0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 public constant USER = keccak256(abi.encodePacked("USER"));
    //0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96

    constructor() {
        roles[ADMIN][msg.sender] = true;
    }

    modifier onlyRole(bytes32 _role) {
        require( roles[_role][msg.sender] , "Not the Admin");
        _;

    }

    function _setRole(bytes32 _role, address _to) internal{
        roles[_role][_to] = true;
        emit grantRole(_role,_to);
    }

    function _revokeRole(bytes32 _role, address _to) internal{
        roles[_role][_to] = false;
        emit revokedRole(_role,_to);

    }

    function setRole(bytes32 _role, address _to) external onlyRole(ADMIN){
        _setRole(_role, _to);
    }
     function revokeRole(bytes32 _role, address _to) external onlyRole(ADMIN){
        _revokeRole(_role, _to);
    }
}