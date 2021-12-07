// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./EventFactory.sol";

contract EventManager is EventFactory {
    enum TiketStatus { Available, Consumed, Locked }
    uint lastTiketId = 0;
    uint tiketPrice = 0;
    mapping (uint => TiketStatus) tiketsStatus;
    mapping (uint => address) tiketToOwner;
    mapping (address => uint[]) ownerToTikets;

    event addedTikets(bytes name, uint256 price, uint256 maxCapacity);
    event tiketSold(uint tiketId, address buyer);
    event tiketConsumed(uint tiketId, address viewer);
    event tiketLocked(uint tiketId, address viewer);
    

    constructor(uint _tiketPrice){
        tiketPrice = _tiketPrice;
    }
    

    function buyTiket() eventStateIs(EventState.Created) payable external {
        require(tiketPrice == msg.value);
        lastTiketId = lastTiketId + 1;
        tiketsStatus[lastTiketId] = TiketStatus.Available;
        tiketToOwner[lastTiketId] = msg.sender;
        ownerToTikets[msg.sender].push(lastTiketId);
        emit tiketSold(lastTiketId, msg.sender);
    }

    function consumeTiket(uint tiketId, address viewer) onlyOwner eventStateIs(EventState.Created) external {
        require(tiketsStatus[tiketId] == TiketStatus.Available);
        require(tiketToOwner[tiketId] == viewer);
        tiketsStatus[tiketId] = TiketStatus.Consumed;
        emit tiketConsumed(tiketId, viewer);
    }

    function lockTiket(uint tiketId) onlyOwner eventStateIs(EventState.Created) external {
        require(tiketsStatus[tiketId] == TiketStatus.Available);
        tiketsStatus[tiketId] = TiketStatus.Consumed;
        emit tiketLocked(tiketId, tiketToOwner[tiketId]);
    }
    
    function finalizeEvent() onlyOwner eventStateIs(EventState.Started) external {
        // distribute rewards
        changeStateEvent(EventState.Finished);
    }
    
    function cancelEvent() onlyOwner eventStateIs(EventState.Created) external {
        // distribute rewards
        changeStateEvent(EventState.Canceled);
    }
    
    modifier onlyOwnerOf(uint tiketId){
        require(tiketToOwner[tiketId] == msg.sender, "You are not owner of the tiket");
        _;
    }
}