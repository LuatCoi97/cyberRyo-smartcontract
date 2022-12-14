// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
 *
 * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
 *
 * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
 * uint128 is a number with a maximum value of 2^127-1 or 340,282,366,920,938,463,463,374,607,431,768,211,455.
 *
 * Does not support burning tokens to address(0).
 */
contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    struct AddressData {
        uint128 balance;
        uint128 numberMinted;
    }

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // type NFT
    bytes32 public constant TYPE_1 = keccak256("TYPE_1");
    bytes32 public constant TYPE_2 = keccak256("TYPE_2");
    bytes32 public constant TYPE_3 = keccak256("TYPE_3");
    bytes32 public constant TYPE_4 = keccak256("TYPE_4");
    bytes32 public constant TYPE_5 = keccak256("TYPE_5");

    // metadata URI
    string public _baseTokenURI;

    // collection size with round
    uint256 public collectionSize;

    // curent index by round,type
    mapping(bytes32 => uint256) public currentIndex;

    // Mapping from token ID to ownership details
    // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
    mapping(uint256 => address) internal _ownerships;

    // Mapping owner address to address data
    mapping(address => AddressData) private _addressData;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev
     * `collectionSize_` refers to how many tokens are in the collection.
     * Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 collectionSize_
    ) {
        _name = name_;
        _symbol = symbol_;
        collectionSize = collectionSize_;
    }

    /**
     * @dev See {totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        unchecked {
            return
                currentIndex[TYPE_1] -
                0 +
                currentIndex[TYPE_2] -
                1000000000 +
                currentIndex[TYPE_3] -
                2000000000 +
                currentIndex[TYPE_4] -
                3000000000 +
                currentIndex[TYPE_5] -
                4000000000;
        }
    }

    /**
     * @dev See {totalSupply}.
     * @param type_ 'bytes32' type mint
     */
    function totalSupply(bytes32 type_) public view returns (uint256) {
        unchecked {
            if (type_ == TYPE_1) {
                return currentIndex[type_] - 0;
            } else if (type_ == TYPE_2) {
                return currentIndex[type_] - 1000000000;
            } else if (type_ == TYPE_3) {
                return currentIndex[type_] - 2000000000;
            } else if (type_ == TYPE_4) {
                return currentIndex[type_] - 3000000000;
            } else if (type_ == TYPE_5) {
                return currentIndex[type_] - 4000000000;
            } else {
                return 0;
            }
        }
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC165, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view override returns (uint256) {
        require(
            owner != address(0),
            "ERC721A: balance query for the zero address"
        );
        return uint256(_addressData[owner].balance);
    }

    function _numberMinted(address owner) internal view returns (uint256) {
        require(
            owner != address(0),
            "ERC721A: number minted query for the zero address"
        );
        return uint256(_addressData[owner].numberMinted);
    }

    function ownershipOf(uint256 tokenId)
        internal
        view
        returns (address)
    {
        require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
        address ownership = _ownerships[tokenId];
        unchecked {
            if (ownership != address(0)) {
                return ownership;
            }
            //
            while (true) {
                tokenId--;
                ownership = _ownerships[tokenId];
                if (ownership != address(0)) {
                    return ownership;
                }
            }
        }
        revert("ERC721A: unable to determine the owner of token");
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view override returns (address) {
        return ownershipOf(tokenId);
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return
            bytes(_baseTokenURI).length > 0
                ? string(abi.encodePacked(_baseTokenURI, tokenId.toString()))
                : "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public override {
        address owner = ERC721A.ownerOf(tokenId);
        require(to != owner, "ERC721A: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721A: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId, owner);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId)
        public
        view
        override
        returns (address)
    {
        require(
            _exists(tokenId),
            "ERC721A: approved query for nonexistent token"
        );

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved)
        public
        override
    {
        require(operator != _msgSender(), "ERC721A: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override {
        _transfer(from, to, tokenId);
        require(
            _checkOnERC721Received(from, to, tokenId, _data),
            "ERC721A: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     */
    function _exists(uint256 tokenId) public view returns (bool) {
        if (
            (tokenId < currentIndex[TYPE_1] && tokenId >= 0) ||
            (tokenId < currentIndex[TYPE_2] && tokenId >= 1000000000)  ||
            (tokenId < currentIndex[TYPE_3] && tokenId >= 2000000000)  ||
            (tokenId < currentIndex[TYPE_4] && tokenId >= 3000000000)  ||
            (tokenId < currentIndex[TYPE_5] && tokenId >= 4000000000)
        ) {
            return true;
        }

        return false;
    }

    function _safeMint(
        address to,
        uint256 quantity,
        bytes32 typeMint
    ) internal {
        _safeMint(to, quantity, "", typeMint);
    }

    /**
     * @dev Mints `quantity` tokens and transfers them to `to`.
     *
     * Requirements:
     *
     * - there must be `quantity` tokens remaining unminted in the total collection.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(
        address to,
        uint256 quantity,
        bytes memory _data,
        bytes32 typeMint
    ) internal {
        uint256 startTokenId = currentIndex[typeMint];
        require(to != address(0), "ERC721A: mint to the zero address");
        // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
        require(!_exists(startTokenId), "ERC721A: token already minted");
        require(quantity != 0, "ERC721A: quantity to mint is zero");

        _beforeTokenTransfers(address(0), to, startTokenId, quantity);
        unchecked {
            AddressData memory addressData = _addressData[to];
            _addressData[to] = AddressData(
                addressData.balance + uint128(quantity),
                addressData.numberMinted + uint128(quantity)
            );

            _ownerships[startTokenId] = to;
        
            uint256 updatedIndex = startTokenId;
            //
            for (uint256 i = 0; i < quantity; i++) {
                emit Transfer(address(0), to, updatedIndex);
                require(
                    _checkOnERC721Received(address(0), to, updatedIndex, _data),
                    "ERC721A: transfer to non ERC721Receiver implementer"
                );
                updatedIndex++;
            }

            currentIndex[typeMint] = updatedIndex;
        }

        _afterTokenTransfers(address(0), to, startTokenId, quantity);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) private {
        address prevOwnership = ownershipOf(tokenId);

        bool isApprovedOrOwner = (_msgSender() == prevOwnership ||
            getApproved(tokenId) == _msgSender() ||
            isApprovedForAll(prevOwnership, _msgSender()));

        require(
            isApprovedOrOwner,
            "ERC721A: transfer caller is not owner nor approved"
        );

        require(
            prevOwnership == from,
            "ERC721A: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721A: transfer to the zero address");

        _beforeTokenTransfers(from, to, tokenId, 1);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId, prevOwnership);
        unchecked {
            _addressData[from].balance -= 1;
            _addressData[to].balance += 1;
            _ownerships[tokenId] = to;

            // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
            // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
            uint256 nextTokenId = tokenId + 1;
            if (_ownerships[nextTokenId] == address(0)) {
                if (_exists(nextTokenId)) {
                    _ownerships[nextTokenId] = prevOwnership;
                }
            }
        }

        emit Transfer(from, to, tokenId);
        _afterTokenTransfers(from, to, tokenId, 1);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(
        address to,
        uint256 tokenId,
        address owner
    ) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC721Receiver(to).onERC721Received(
                    _msgSender(),
                    from,
                    tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC721A: transfer to non ERC721Receiver implementer"
                    );
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
     *
     * startTokenId - the first token id to be transferred
     * quantity - the amount to be transferred
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     */
    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual {}

    /**
     * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
     * minting.
     *
     * startTokenId - the first token id to be transferred
     * quantity - the amount to be transferred
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero.
     * - `from` and `to` are never both zero.
     */
    function _afterTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual {}
}
