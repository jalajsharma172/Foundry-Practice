// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelpConfig} from "./HelpConfig.s.sol";
contract DeployFundMe is Script {
    FundMe public fundMe;
    function run() external returns (FundMe) {
        HelpConfig helpconfig = new HelpConfig();
        address working=helpconfig.activeNetworkConfig();
        vm.startBroadcast();
        fundMe = new FundMe(working);
        vm.stopBroadcast();
        return fundMe;
    }
}
