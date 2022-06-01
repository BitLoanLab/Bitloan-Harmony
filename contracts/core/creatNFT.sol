// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity  0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interface/IRbtDeposit721.sol";
import "../library/TransferHelper.sol";

contract creatNFT  {
   IRbtDeposit721 token_21_;
    event creat721(address to, uint month, uint value, string  name);
    address public token_20_;
    address public admin;

    modifier onlyAdmin(){
        require(msg.sender == admin , "not admin");
        _;
    }

    constructor () {
        admin = msg.sender;
    }

    function initialize(address _token_20, address token_21) public onlyAdmin {
        token_20_ = _token_20;
        token_21_  = IRbtDeposit721(token_21);
    }

    function creat(address to, uint month, uint value , string  memory name) public { 
        require(month == 0 || month == 3 || month == 6 || month == 12 || month == 24 || month == 36 , "Deposit month error");
        IERC20(token_20_).transferFrom(to, address(this), value);
        token_21_.mint(to, value, month, name);
        emit creat721(to, month, value, name);
    }

    function withdraw(uint tokenId) public {
        require(token_21_.ownerOf(tokenId) == msg.sender ,"not owner");
        require(token_21_.expire(tokenId) <= block.timestamp , "not expire");
        IERC20(token_20_).transfer(msg.sender, token_21_.amount(tokenId));
        token_21_.burn(tokenId);
    }

}