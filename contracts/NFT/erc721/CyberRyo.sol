// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Shiniki is Ownable, ERC721A, ReentrancyGuard, Pausable, ERC2981 {
    // Info config
    struct SaleConfig {
        uint128 publicSaleStartTime;
        uint128 publicSaleDuration;
    }

    // Info config mint
    SaleConfig public saleConfig;

    constructor(
        uint256 collectionSize_,
        uint256 maxBatchSize_,
        string memory defaultURI_
    ) ERC721A("CyberRyo", "RYO", collectionSize_, maxBatchSize_) {
        currentIndex[TYPE_1] = 0;
        currentIndex[TYPE_2] = 1000000000;
        currentIndex[TYPE_3] = 2000000000;
        currentIndex[TYPE_4] = 3000000000;
        currentIndex[TYPE_5] = 4000000000;
        revealed = false;
        defaultURI = defaultURI_;
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
    function publicSaleMint(
        bytes32[5] memory typeMints,
        uint256[5] memory quantities
    ) external payable nonReentrant callerIsUser whenNotPaused {
        uint256 totalMint = quantities[0] + quantities[1];
        require(
            totalMint <= maxBatchSize,
            "Shiniki: quantity to mint is less than maxBatchSize"
        );
        require(isPublicSaleOn(), "Shiniki: public sale has not begun yet");
        require(
            totalSupply() + totalMint <= collectionSize,
            "Shiniki: reached max supply"
        );
        for (uint8 i = 0; i < typeMints.length; i++) {
            _safeMint(msg.sender, quantities[i], typeMints[i]);
        }
    }

    /**
     * @notice mint private
     * @param receiver 'address' receiver when mint nft
     * @param quantityType1 'uint256' quantity when mint nft by Type1
     * @param quantityType2 'uint256' quantity when mint nft by Type2
     * @param quantityType3 'uint256' quantity when mint nft by Type3
     * @param quantityType4 'uint256' quantity when mint nft by Type4
     * @param quantityType5 'uint256' quantity when mint nft by Type5
     */
    function privateMint(
        address receiver,
        uint256 quantityType1,
        uint256 quantityType2,
        uint256 quantityType3,
        uint256 quantityType4,
        uint256 quantityType5
    ) public onlyOwner whenNotPaused {
        require(
            totalSupply() + quantityType1 + quantityType2 <= collectionSize,
            "Shiniki: reached max supply"
        );

        //mint with type 1
        if (quantityType1 != 0) {
            require(
                totalSupply(TYPE_1) + quantityType1 <= 1000000000,
                "Shiniki: type1 input is reached max supply"
            );
            _safeMint(receiver, quantityType1, TYPE_1);
        }

        //mint with type 2
        if (quantityType2 != 0) {
            require(
                totalSupply(TYPE_2) + quantityType2 <= 1000000000,
                "Shiniki: type2 input is reached max supply"
            );
            _safeMint(receiver, quantityType2, TYPE_2);
        }
        //mint with type 3
        if (quantityType3 != 0) {
            require(
                totalSupply(TYPE_3) + quantityType3 <= 1000000000,
                "Shiniki: type2 input is reached max supply"
            );
            _safeMint(receiver, quantityType3, TYPE_3);
        }
        //mint with type 4
        if (quantityType4 != 0) {
            require(
                totalSupply(TYPE_4) + quantityType4 <= 1000000000,
                "Shiniki: type4 input is reached max supply"
            );
            _safeMint(receiver, quantityType4, TYPE_4);
        }

        //mint with type 5
        if (quantityType5 != 0) {
            require(
                totalSupply(TYPE_5) + quantityType5 <= 1000000000,
                "Shiniki: type2 input is reached max supply"
            );
            _safeMint(receiver, quantityType5, TYPE_5);
        }
    }

    /**
     * @notice set base uri
     * @param _baseURI array 'string' base uri
     */
    function setBaseURI(string memory _baseURI) external onlyOwner {
        _baseTokenURI = _baseURI;
    }

    /**
     * @notice set default uri
     * @param _defaultURI 'string' default uri
     */
    function setDefaultURI(string memory _defaultURI) external onlyOwner {
        defaultURI = _defaultURI;
    }

    /**
     * @notice set max batch size
     * @param _maxBatchSize 'uint256' number new maxBatchSize
     */
    function setMaxBatchSize(uint256 _maxBatchSize) external onlyOwner {
        maxBatchSize = _maxBatchSize;
    }

    /**
     * @notice check public sale
     * @return 'bool' status public sale
     */
    function isPublicSaleOn() public view returns (bool) {
        return
            block.timestamp >= saleConfig.publicSaleStartTime &&
            block.timestamp <=
            saleConfig.publicSaleStartTime + saleConfig.publicSaleDuration;
    }

    /**
     * @notice set public sale config
     * @param _publicSaleStartTime 'uint128' start time public sale
     * @param _publicSaleDuration 'uint128' duration time of public sale
     */
    function setPublicSaleConfig(
        uint128 _publicSaleStartTime,
        uint128 _publicSaleDuration
    ) external onlyOwner {
        saleConfig.publicSaleStartTime = _publicSaleStartTime;
        saleConfig.publicSaleDuration = _publicSaleDuration;
    }

    /**
     * @notice set revealed
     * @param _revealed 'bool' status revealed
     */
    function setRevealed(bool _revealed) external onlyOwner {
        revealed = _revealed;
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
