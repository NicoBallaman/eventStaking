// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./EventManager.sol";

contract EventTiketsOwnership is ERC721, EventManager {

    mapping (uint => address) tiketsApprovals;

    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address aproved, uint256 tokenId);
    
    function balanceOf(address _owner) external view returns (uint256[] memory) {
        return ownerToTikets[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {        
        return tiketToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        requiredState(EventState.Created);
        _remove(_tokenId, ownerToTikets[_from]);
        ownerToTikets[_to].push(_tokenId);
        tiketToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }
    
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require (tiketToOwner[_tokenId] == msg.sender || tiketsApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }
    
    function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
        tiketsApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
    
    function _remove(uint _valueToFindAndRemove, uint[] storage _array) private {
        uint index;
        for (uint i = 0; i < _array.length; i++){
            if(_array[i] != _valueToFindAndRemove) {
                index = i;
                break;
            }
        }
        delete _array[index];
    }

}