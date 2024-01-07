// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol"; 

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_sadSvg;
    string private s_happySvg;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    // errors
    error MoodNft__CantFlipMoodIfNotOwner();

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("Mood NFT", "MN"){
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(
            _msgSender() == owner || getApproved(tokenId) == _msgSender(),
            "ERC721: caller is not owner nor approved"
        );

        Mood currentMood = s_tokenIdToMood[tokenId];
        if(currentMood == Mood.HAPPY){
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }  

    function _baseURI() internal pure override returns(string memory){
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory svgImageUri;

        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            svgImageUri = s_happySvgImageUri;
        } else {
            svgImageUri = s_sadSvgImageUri;
        }

        return
        string(
            abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": ", name(), "description": "An NFT that reflects the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "', svgImageUri,'"}'
                            )
                        )
                    )
            )
        );
    }

}