// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "./SignatureVerifier.sol";

contract StakingRyo is
    Initializable,
    OwnableUpgradeable,
    SignatureVerifier,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable
{

    struct Order {
        address seller;
        uint256[] tokenIds;
        uint256 value;
        uint256 nonce;
        uint256 start;
        uint256 end;
    }

    // Info nft
    IERC721Upgradeable public RYO_NFT;

    function initialize(address _trusted) external initializer {
        __Ownable_init_unchained();
        __ReentrancyGuard_init();
        __Pausable_init();

        TRUSTED_PARTY = _trusted;

        RYO_NFT = IERC721Upgradeable(0x98922A7b6b88465d34dc9a7D4D8C5eE3B5757752);
    }

    /**
    @notice buy/sell
     */
    function run(Order calldata order)
        public payable
        whenNotPaused  nonReentrant
    {
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
