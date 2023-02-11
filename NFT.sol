//SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface ISupraSValueFeed {
    function checkPrice(string memory marketPair) external view returns (int256 price, uint256 timestamp);
}

contract DynamicNFT is ERC721 {
    uint256 public tokenIds = 1;
    ISupraSValueFeed public sValueFeed;

    int public price = 0;

    constructor() ERC721("Shardeum NFT", "SNFT"){
        sValueFeed = ISupraSValueFeed(0x700a89Ba8F908af38834B9Aba238b362CFfB665F);
    }

    function mint(uint256 number) public payable {
        for(uint i = 0; i < number; i++){
            _safeMint(msg.sender, tokenIds + i);
        }
        tokenIds += number;
    }

    function checkPrice(uint256 _tokenId) public {
        require(_tokenId <= tokenIds, "This token does not exist!");
        (int _price,) = sValueFeed.checkPrice("eth_usdt");
        bool ans = _price < price;
        price = _price;
        if(!ans){
            _burn(_tokenId);
        }
    }
}
