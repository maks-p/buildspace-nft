// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Import OpenZeppelin Contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract GenerativeCocktail is ERC721URIStorage {
    uint16 public constant maxTokens = 8888;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSVG =
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: monospace; font-size: 18px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

    string[] private wordsA = [
        "Whiskey",
        "Rum",
        "Gin",
        "Vodka",
        "Mezcal",
        "Tequila",
        "Scotch",
        "Cognac",
        "Genever",
        "Rye",
        "Bourbon",
        "Old Tom Gin",
        "Apple Brandy",
        "Irish Whisky",
        "Japanese Whiskey",
        "Cachaca"
    ];

    string[] private wordsB = [
        "Campari",
        "Green Chartreuse",
        "Yellow Chartreuse",
        "Cherry Heering",
        "Sweet Vermouth",
        "Dry Vermouth",
        "Blanc Vermouth",
        "Lemon",
        "Lime",
        "Cynar",
        "Cocchi Americano",
        "Fernet Branca",
        "Grapefruit",
        "Orange Juice",
        "Aperol",
        "Amontillado Sherry",
        "Port",
        "Black Strap Rum",
        "Quinquina",
        "Apricot Eau de Vie",
        "Cream",
        "Whole Egg"
    ];

    string[] private wordsC = [
        "Sugar",
        "Maraschino",
        "Orange Curacao",
        "Creme de Menthe",
        "Benedictine",
        "Pedro Ximenez Sherry",
        "Watermelon",
        "Grenadine",
        "Agave",
        "Soda",
        "Maple Syrup",
        "Honey",
        "Ginger Syrup",
        "Orgeat",
        "Raspberry Syrup",
        "Creme de Mure",
        "Creme de Cacao",
        "Tonic"
    ];

    string[] private wordsD = [
        "Mint",
        "Cinnamon",
        "Rosemary",
        "Angostura Bitters",
        "Orange Bitters",
        "Cacao Nib",
        "Lapsang Tea",
        "Green Tea",
        "Earl Grey Tea",
        "Sage",
        "Nutmeg",
        "Bergamot",
        "Absinthe",
        "Creme de Violette",
        "Coffee Bean",
        "Vanilla",
        "Orange Flower Water",
        "Allspice",
        "Sparkling Wine",
        "Salt"
    ];

    event nftMinted(address sender, uint256 tokenId);

    constructor() ERC721("Generative Cocktails", "CKTL") {
        // Set first NFT to #1;
        _tokenIds.increment();
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomWord(string[] memory arr, uint256 tokenId)
        public
        pure
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked(arr[0], Strings.toString(tokenId)))
        );
        rand = rand % arr.length;
        return arr[rand];
    }

    function createSVG(uint256 tokenId) public view returns (string memory) {
        string memory first = pickRandomWord(wordsA, tokenId);
        string memory second = pickRandomWord(wordsB, tokenId);
        string memory third = pickRandomWord(wordsC, tokenId);
        string memory fourth = pickRandomWord(wordsD, tokenId);
        string memory fifth = pickRandomWord(
            wordsD,
            tokenId + (tokenId % (wordsD.length - 1))
        );

        string[11] memory parts;

        parts[0] = baseSVG;
        parts[1] = string(abi.encodePacked(first, " +"));
        parts[2] = '</text><text x="10" y="40" class="base">';
        parts[3] = string(abi.encodePacked(second, " +"));
        parts[4] = '</text><text x="10" y="60" class="base">';
        parts[5] = string(abi.encodePacked(third, " +"));
        parts[6] = '</text><text x="10" y="80" class="base">';
        parts[7] = string(abi.encodePacked(fourth, " +"));
        parts[8] = '</text><text x="10" y="100" class="base">';
        parts[9] = fifth;
        parts[10] = "</text></svg>";

        string memory output = string(
            abi.encodePacked(
                parts[0],
                parts[1],
                parts[2],
                parts[3],
                parts[4],
                parts[5],
                parts[6],
                parts[7],
                parts[8],
                parts[9],
                parts[10]
            )
        );
        return output;
    }

    function getMintCount() public view returns (uint256) {
        return _tokenIds.current() - 1;
    }

    function mintNFT() public {
        // Get current tokenId
        uint256 tokenId = _tokenIds.current();

        require(tokenId <= maxTokens, "All NFTs minted");

        string memory finalSVG = createSVG(tokenId);
        string memory nftName = string(
            abi.encodePacked("Cocktail #", Strings.toString(tokenId))
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        nftName,
                        '", "description": "A generative cocktail collection", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSVG)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenURI);
        console.log("--------------------\n");

        // Mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, tokenId);

        // Set the NFTs data
        _setTokenURI(tokenId, finalTokenURI);

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            tokenId,
            msg.sender
        );

        // Increment the counter for when the next NFT is minted
        _tokenIds.increment();

        emit nftMinted(msg.sender, tokenId);
    }
}
