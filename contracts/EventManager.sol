pragma solidity ^0.8.0;

import "./EventFactory.sol";

contract EventManager is EventFactory {
    Tiket[] availabletikets;
    mapping (uint => address) tiketToOwner;
    mapping (address => uint[]) viewers;

    event addedTikets(bytes name, uint256 price, uint256 maxCapacity);
    
    function addTiketType(bytes memory name, uint256 price, uint256 maxCapacity) onlyOwner eventStateIs(EventState.Created) external {
        TiketType memory tiketType = TiketType(name, price, maxCapacity, 0);
        currentEvent.tiketTypes.push(tiketType);
        emit addedTikets(name, price, maxCapacity);
    }

    function showUp() onlyOwner eventStateIs(EventState.Created) external {
        require(currentEvent.tiketTypes.length > 0, "The event needs to have at least one topic.");
        changeStateEvent(EventState.Started);
    }
    
    function finalizeEvent() onlyOwner eventStateIs(EventState.Started) external {
        // distribute rewards
        changeStateEvent(EventState.Finished);
    }
    
    function cancelEvent() onlyOwner eventStateIs(EventState.Created) external {
        changeStateEvent(EventState.Canceled);
        // distribute rewards
    }
    
    modifier onlyOwnerOf(uint tiketId){
        require(tiketToOwner[tiketId] == msg.sender, "You are not owner of the tiket");
        _;
    }
}