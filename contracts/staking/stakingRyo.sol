// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract StakingRyo is
    Initializable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable
{

    // Info nft
    IERC721Upgradeable public RYO_NFT;

    // Info collection
    mapping(uint256 => address) public staked;

    function initialize() external initializer {
        __Ownable_init_unchained();
        __ReentrancyGuard_init();
        __Pausable_init();

        RYO_NFT = IERC721Upgradeable(0x98922A7b6b88465d34dc9a7D4D8C5eE3B5757752);
    }

    /**
    @notice staking nft to pool
     */
    function staking(uint256[] memory tokenIds)
        public
        whenNotPaused  nonReentrant
    {
        require(
            tokenIds.length != 0,
            "ShinikiCamPaign: input tokenIds is invalid"
        );
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            require(RYO_NFT.ownerOf(tokenId) == msg.sender, 'caller not owner');
            require(staked[tokenId] == address(0), 'staked');
            staked[tokenId] = msg.sender;
            RYO_NFT.safeTransferFrom(
                msg.sender,
                address(this),
                tokenId
            );
        }
    }

    /**
    @notice unstaking nft in pool
    */
    function unstaking(uint256[] memory tokenIds)
        public
        whenNotPaused  nonReentrant
    {
        require(
            tokenIds.length != 0,
            "ShinikiCamPaign: input tokenIds is invalid"
        );
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            require(RYO_NFT.ownerOf(tokenId) == msg.sender, 'caller not owner');
            require(staked[tokenId] == msg.sender, 'not staked');
            staked[tokenId] = address(0);
            RYO_NFT.safeTransferFrom(
                address(this),
                msg.sender,
                tokenId
            );
        }
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

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
