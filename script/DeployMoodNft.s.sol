// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns(MoodNft) {

        string memory sadSvgImageUri = svgToImageURI(sadSvg());
        string memory happySvgImageUri = svgToImageURI(happySvg());

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(sadSvgImageUri, happySvgImageUri);
        vm.stopBroadcast();
        return moodNft;

    }

    function svgToImageURI(string memory svg) internal pure returns(string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

}