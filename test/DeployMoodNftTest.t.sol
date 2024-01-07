// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;
    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testDeployMoodNft() public {
        MoodNft moodNft = deployer.run();
        assertEq(moodNft.name(), "Mood NFT");
        assertEq(moodNft.symbol(), "MN");
    }
}