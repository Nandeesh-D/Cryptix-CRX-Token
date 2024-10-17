// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import{Test} from "@forge-std/Test.sol";
import {DeployCryptix} from "../script/DeployCryptix.s.sol";
import {Cryptix} from "../src/Cryptix.sol";
import{console} from "@forge-std/console.sol";

contract CryptixTest is Test{
    DeployCryptix deployer;
    Cryptix cryptix;

    address owner;
    address user1=makeAddr("user1");
    address feeAddress=makeAddr("feeAddress");

    function setUp() external{
        deployer=new DeployCryptix();
        cryptix=deployer.run();
        //here owner will be the msg.sender
        owner=cryptix.getOwner();
        vm.prank(owner);
        cryptix.setFeeAddress(feeAddress);
    }

    function testFeeAddressIsNotZero() public view{
        assert(cryptix.getFeeAddress()!=address(0));
        console.log("fee address is: ",feeAddress);
    }

    function testTransferFeeIsNotZero() public view{
        uint256 transferFee=cryptix.getTransferFee();
        assert(transferFee!=uint256(0));
        console.log(transferFee);
    }

    function testOwnerGotInitialTokens() public view {
        uint256 expectedInitialSupply = 6000 * 10**cryptix.decimals();
        uint256 ownerBalance = cryptix.balanceOf(owner);
        console.log("Expected initial supply:", expectedInitialSupply);
        console.log("Actual owner balance:", ownerBalance);
        assertEq(ownerBalance, expectedInitialSupply, "Owner balance should equal initial supply");
    }

    function testMintFailsWhenNotOwnerIsCalled() public{
        vm.prank(user1);
        vm.expectRevert();
        cryptix.mint(owner,2);
    }

    function testBurnFailsWhenNotOwnerIsCalled() public{
        vm.prank(user1);
        vm.expectRevert();
        cryptix.burn(owner,2);
    }

    function testTransferAmountAfterFee() public{
        uint256 amountToTransfer=100;
        uint256 transferFee=cryptix.getTransferFee();
        uint256 expectedFee= (amountToTransfer*transferFee)/100;
        uint256 expectedAmountAfterFee=amountToTransfer-expectedFee;


        //transfer token from owner to user1
        vm.prank(owner);
        cryptix.transfer(owner, user1, amountToTransfer);

        //chekc user1 balance
        uint256 userBalance=cryptix.balanceOf(user1);
        assertEq(userBalance, expectedAmountAfterFee,"user1 received the correct amount after fee");


        uint256 feeAddressBalance=cryptix.balanceOf(feeAddress);
        assertEq(feeAddressBalance, expectedFee,"fee address received the correct  fee");
    }

    // test that transfer fails if amount is less than fee
    function testTransferFailsIfAmountLessThanFee() public {
        uint256 amountToTransfer = 0;  // amount to transfer that is less than the fee
        vm.prank(owner);  

        // expect the transfer to revert
        vm.expectRevert("Transfer amount must be greater than the fee");
        cryptix.transfer(owner, user1, amountToTransfer);
    }
}