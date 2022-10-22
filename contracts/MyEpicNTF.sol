// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    string prefixSvgBeforeColor = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string prefixSvgAfterColor = "' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string suffixSvg = "</text></svg>";

    string[] firstWords = ["Fantastic","Epic","Terrible","Crazy","Wild","Terrifying","Spooky","Horrible","Giant","Loudy","Insane","Talkative","Curious","Hungry","Sleepy"];
    string[] secondWords = ["Pizza","Cupcake","Kebab","Pasta","Tiramisu","Hamburger","Popcorn","Icecream","Hotdog","Hummus","Cheese","Bread","Sushi","Lamen","Croissant"];
    string[] thirdWords = ["Gollum","Bilbo","Gandalf","Sauron","Galadriel","Elrond","Gimli","Frodo","Sam","Aragorn","Arathorn","Elendil","Saruman","Legolas","Pippin"];
    string[] bgColors = ["black","darkgreen","darkblue","darkred","darkgray","darkorange"];

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract! Whoa!");
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickFirstRandomWord(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickSecondRandomWord(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickThirdRandomWord(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
        rand = rand % bgColors.length;
        return bgColors[rand];
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        string memory firstWord = pickFirstRandomWord(newItemId);
        string memory secondWord = pickSecondRandomWord(newItemId);
        string memory thirdWord = pickThirdRandomWord(newItemId);
        string memory color = pickRandomColor(newItemId);

        string memory text = string(abi.encodePacked(firstWord, secondWord, thirdWord));
        
        string memory svg = createSvgDinamically(color, text);
        string memory encodedJson = createEncodedJsonDinamically(svg, text);

        console.log("Token URI is %s", encodedJson);

        _setTokenURI(newItemId, encodedJson);

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        _tokenIds.increment();

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function createSvgDinamically(string memory color, string memory text) internal view returns (string memory) {
        return string(abi.encodePacked(prefixSvgBeforeColor, color, prefixSvgAfterColor, text, suffixSvg));
    }

    function createEncodedJsonDinamically(string memory svg, string memory text) internal pure returns (string memory) {
        string memory base64Svg = Base64.encode(
            bytes(
                svg
            )
        );

        string memory json = string(abi.encodePacked(
            '{"name":"',text,'",',
            '"description": "A highly acclaimed collection of squares.",',
            '"image":"data:image/svg+xml;base64,',base64Svg,'"}'
        ));

        string memory base64Json = Base64.encode(
            bytes(
                json
            )
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                base64Json
            )
        );
    }

    function createBase64TokenURI() internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                "ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStSWEJwWTB4dmNtUklZVzFpZFhKblpYSThMM1JsZUhRK0Nqd3ZjM1puUGc9PSIKfQ=="
            )
        );
    }

}