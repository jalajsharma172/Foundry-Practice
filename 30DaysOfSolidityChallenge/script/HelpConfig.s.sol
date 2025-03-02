// SPDX-License-Identifier: MIT
// 1. Depoloy mocks when we are on the local avil chain
// Keep track of contract Address accross diffrenet cahins
// Sepolia Eth/USD
//MAinent ETH/USD
pragma solidity ^0.8.19;
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {Script} from "forge-std/Script.sol";
contract HelpConfig is Script {
    //If we are on local avil, wedeploy mocks
    // otherwise use the live address
    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }
    NetworkConfig public activeNetworkConfig;
    constructor() {
        if (block.chainid == 11155111) {
            //VISIT https://chainlist.org/ TO GET THE CHAIN ID
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            //VISIT https://chainlist.org/ TO GET THE CHAIN ID
            activeNetworkConfig = getMainEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }
    function getMainEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return sepoliaConfig;
    }
// WHILE vm.startBroadcasting(); // start broadcasting =>> We don't work in view/pure function
    function getAnvilEthConfig() public  returns (NetworkConfig memory) {
        
        vm.startBroadcast();
        MockV3Aggregator  mock = new MockV3Aggregator(5, 100000000000);
        vm.stopBroadcast();


        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: address(mock)
        });
        return sepoliaConfig;
    }
}
