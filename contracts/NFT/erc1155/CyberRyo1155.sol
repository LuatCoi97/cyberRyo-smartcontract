// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CyberRyo1155 is Ownable, ERC1155, ERC1155Burnable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => uint256) private _totalSupply;

    string public name;
    string public symbol;

    string private _baseUri;

    constructor(string memory name_, string memory symbol_, string memory baseUri) ERC1155("") {
        name = name_;
        name = symbol_;
        setBaseUri(baseUri);
    }

     function setBaseUri(string memory newuri) public virtual {
        _baseUri = newuri;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply[1];
    }

    function exists() public view virtual returns (bool) {
        return totalSupply() > 0;
    }

    function mint(address owner, uint256 amount) public {
        _mint(owner, 1, amount, '');  
    }

    function uri(uint256)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      exists(),
      "ERC1155Metadata: URI query for nonexistent token"
    );
    return bytes(_baseUri).length > 0
        ? string(abi.encodePacked(_baseUri, '1'))
        : "";
  }

    function _mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual override {
        super._mint(account, id, amount, data);
        _totalSupply[id] += amount;
    }
}
