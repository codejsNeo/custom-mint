// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CustomMint is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;

    // mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    // Base URI
    string private _baseURIextended;

    constructor() ERC721("CustomMint","CMT") {}
    // constructor(string memory name, string memory symbol) ERC721(name, symbol) {} 
    
    /**
     * @dev  maxSupply set to mint only 100 tokens
     *  mintFee variable declared so that it could be updated anytime
     */
    uint256 public constant maxSupply = 100;
    uint256 mintFee = 0.001 ether;

    // function _baseURI() internal pure override returns (string memory) {
    //     return "https://gateway.pinata.cloud/ipfs/";
    // }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
        require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    // withdrawal function to transfer all the sent ETH to the owner
    function withdraw() external payable onlyOwner {
        address _owner = address(uint160(owner()));
        payable(_owner).transfer(address(this).balance);
    }

    // function to update the mint fee for the future time
    function setMintFee(uint256 _fee) external onlyOwner {
        mintFee = _fee;
    }

    function safeMint(address to,uint256 _tokenId,string memory tokenURI_) public payable virtual returns (uint256) {
        require(msg.value >= mintFee, "Not enough ETH, check the price !");
        require(totalSupply() < maxSupply,"Max limit for Tokens already minted !");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(_tokenId, tokenURI_);

        return tokenId;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
