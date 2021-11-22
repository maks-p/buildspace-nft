// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Import OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

contract MyNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("First NFT contract");
    }

    function mintNFT() public {
        
        // Get current tokenId
        uint256 tokenId = _tokenIds.current();

        // Mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, tokenId);

        // Set the NFTs data
        _setTokenURI(tokenId, "https://jsonkeeper.com/b/0YYA");
        console.log("An NFT w/ ID %s has been minted to %s", tokenId, msg.sender);

        // Increment the counter for when the next NFT is minted
        _tokenIds.increment();
    }
}
