// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "@forge-std/Script.sol";
import {Cryptix} from "../src/Cryptix.sol";

contract DeployCryptix is Script {
    uint256 initialSupply = 6000;
    uint256 maxSupply = 10000;

    function run() public returns (Cryptix) {
        vm.startBroadcast();
        Cryptix token = new Cryptix(initialSupply, maxSupply);
        vm.stopBroadcast();
        return token; //return token address where it is deployed
    }
}
