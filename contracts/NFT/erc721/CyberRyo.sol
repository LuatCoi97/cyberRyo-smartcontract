// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Shiniki is Ownable, ERC721A, ReentrancyGuard, Pausable, ERC2981 {

    constructor(
        uint256 collectionSize_
    ) ERC721A("CyberRyo", "RYO", collectionSize_) {
        currentIndex[TYPE_1] = 0;
        currentIndex[TYPE_2] = 1000000000;
        currentIndex[TYPE_3] = 2000000000;
        currentIndex[TYPE_4] = 3000000000;
        currentIndex[TYPE_5] = 4000000000;
    }

    /**
     * @notice Validate caller
     */
    modifier callerIsUser() {
        require(
            tx.origin == msg.sender,
            "Shiniki: The caller is another contract"
        );
        _;
    }

    /**
     * @notice mint public sale
     * @param typeMints array 'bytes32' type mint
     * @param quantities array 'uint256' quantity for each type
     */
    function publicMint(
        bytes32[5] memory typeMints,
        uint256[5] memory quantities,
        uint256 total
    ) external payable nonReentrant callerIsUser whenNotPaused {
        require(
            numberMinted(msg.sender) + total <= 5,
            "Shiniki: reached max supply");
        for (uint8 i = 0; i < typeMints.length; i++) {
            require(
            totalSupply(typeMints[i]) + quantities[i] <= 600,
            "Shiniki: reached max supply"
            );
            _safeMint(msg.sender, quantities[i], typeMints[i]);
        }
    }

    /**
     * @notice mint private
     * @param receiver 'address' receiver when mint nft
     * @param total 'uint256' quantity when mint nft by Type1
     */
    function privateMint(
        address receiver,
        uint256 total
    ) public onlyOwner whenNotPaused {
        require(
            totalSupply() + total <= collectionSize,
            "Shiniki: reached max supply"
        );

        uint256 quantity = total / 5;

        //mint with type 1
        _safeMint(receiver, quantity, TYPE_1);
        
        //mint with type 2
        _safeMint(receiver, quantity, TYPE_2);
        
        //mint with type 3
        _safeMint(receiver, quantity, TYPE_3);
        
        //mint with type 4
        _safeMint(receiver, quantity, TYPE_4);

        //mint with type 5
        _safeMint(receiver, quantity, TYPE_5);
        
    }

    /**
     * @notice set base uri
     * @param _baseURI array 'string' base uri
     */
    function setBaseURI(string memory _baseURI) external onlyOwner {
        _baseTokenURI = _baseURI;
    }

    /**
     * @notice number minted
     * @param owner 'address' user
     */
    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    /**
     * @notice get ownership data of a nft
     * @param tokenId 'uint256' id of nft
     * @return 'TokenOwnership' detail a nft
     */
    function getOwnershipData(uint256 tokenId) external view returns (address) {
        return ownershipOf(tokenId);
    }

    /**
    @dev Pause the contract
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
    @dev Unpause the contract
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
    @notice Sets the contract-wide royalty info.
     */
    function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
        external
        onlyOwner
    {
        _setDefaultRoyalty(receiver, feeBasisPoints);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721A, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
