// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract EventFactory {
    enum EventState { Initial, Created, Started, Canceled, Finished }

    struct TiketType {
        bytes name;
        uint256 price;
        uint256 maxCapacity;
        uint256 tiketsSelled;
    }

    struct Event {
        bytes name;
        address speaker;
    }
    
    struct Tiket {
        uint32 price;
        uint tiketTypeId;
    }

    address eventOwner;
    Event currentEvent;
    EventState currentState;

    
    event eventInit(address owner);
    event eventCreated(bytes name, address speaker);
    event eventChangedState(EventState newState, bytes name);
    

    constructor() {
        eventOwner = msg.sender;
        changeStateEvent(EventState.Initial);
        emit eventInit(eventOwner);
    }

    function createEvent(bytes memory _name, address _speaker) onlyOwner eventStateIs(EventState.Initial) external {
        currentEvent = Event(_name, _speaker);
        changeStateEvent(EventState.Initial);
        emit eventCreated(_name, _speaker);
    }

    function showUp() onlyOwner eventStateIs(EventState.Created) external {
        changeStateEvent(EventState.Started);
    }

    function changeStateEvent(EventState newState) internal {
        currentState = newState;
        emit eventChangedState(currentState, currentEvent.name);
    }

    function requiredState(EventState state) internal view{
        require(state == currentState);
    }

    modifier eventStateIs(EventState state){
        requiredState(state);
        _;
    }

    modifier onlyOwner(){
        require(eventOwner == msg.sender);
        _;
    }
}