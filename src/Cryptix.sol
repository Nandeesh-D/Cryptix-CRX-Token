// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {ERC20Capped} from "@openzeppelin/token/ERC20/extensions/ERC20Capped.sol";
import {Pausable} from "@openzeppelin/utils/Pausable.sol";

// ERC20Capped token inherits ERC20 token
contract Cryptix is ERC20Capped, Ownable, Pausable {
    address payable public feeAddress; // address to receive transfer fees
    uint256 public transferFee = 1; // 1% transfer fee

    mapping(address => uint256) public locktime;

    constructor(uint256 initialSupply, uint256 maxSupply)
        ERC20("Cryptix", "CRX")
        Ownable(msg.sender)
        ERC20Capped(maxSupply * (10 ** decimals()))
    {
        //initial supply will be minted to owner address ,here the owner is msg.sender who deploys contract
        _mint(msg.sender, initialSupply * (10 ** decimals()));
    }

    event TokensMinted(address indexed account, uint256 amount);
    event TokensBurned(address indexed account, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    // onlyOwner is the modifier defined in the ERC20 standard
    // mint new tokens can be done only by owner
    function mint(address account, uint256 amount) public onlyOwner returns (bool) {
        require(account != address(0) && amount != uint256(0), "erc20 function mint got invalid params");
        _mint(account, amount);
        emit TokensMinted(account, amount);
        return true;
    }

    //only owner can burn the existing tokens
    function burn(address account, uint256 amount) public onlyOwner returns (bool) {
        require(account != address(0) && amount != uint256(0), "erc20 function burn got invalid params");
        _burn(account, amount);
        emit TokensBurned(account, amount);
        return true;
    }

    function transfer(address from, address to, uint256 amount) public {
        uint256 fee = (amount * transferFee) / 100;
        // check to ensure the fee does not exceed the amount
        require(amount > fee, "Transfer amount must be greater than the fee");
        uint256 amountAfterFee = amount - fee;
        super._transfer(from, feeAddress, fee); //transer fee to fee address
        super._transfer(from, to, amountAfterFee); //transed remaining amount to recipient
    }

    function withdraw(uint256 amount) public onlyOwner returns (bool) {
        require(amount <= address(this).balance, "Invalid input");
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
        return true;
    }

    //locks owner tokens
    function lockTokens(uint256 duration) public onlyOwner {
        locktime[msg.sender] = block.timestamp + duration;
    }

    //unlocks the locked tokens
    function unlockTokens() public onlyOwner {
        require(block.timestamp >= locktime[msg.sender], "Tokens are still locked");
        locktime[msg.sender] = 0;
    }

    // pause the contract
    function pause() public onlyOwner {
        _pause();
    }

    //unpause the contract
    function unpause() public onlyOwner {
        _unpause();
    }

    //set the fee address
    function setFeeAddress(address _feeAddress) public onlyOwner {
        feeAddress = payable(_feeAddress);
    }

    function getFeeAddress() public view returns (address) {
        return feeAddress;
    }

    function getTransferFee() public view returns (uint256) {
        return transferFee;
    }

    function getOwner() public view returns (address) {
        return owner();
    }
}
