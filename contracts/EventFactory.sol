pragma solidity ^0.8.0;

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
        TiketType[] tiketTypes;
    }
    
    struct Tiket {
        uint32 price;
        TiketType tiketType;
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
        currentEvent = Event(_name, _speaker, new TiketType[](0));
        changeStateEvent(EventState.Initial);
        emit eventCreated(_name, _speaker);
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