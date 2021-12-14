const EventFactory = artifacts.require("EventFactory");
const EventManager = artifacts.require("EventManager");
const EventTiketsOwnership = artifacts.require("EventTiketsOwnership");

module.exports = async function(deployer) {
	// Deploy EventFactory
	await deployer.deploy(EventFactory);
	const EventFactoryContract = await EventFactory.deployed();

	// Deploy EventManager
	await deployer.deploy(EventManager, 1);
	const eventManagerContract = await EventManager.deployed();

	// Deploy EventTiketsOwnership
	await deployer.deploy(EventTiketsOwnership, 1);
	const eventTiketsOwnershipContract = await EventTiketsOwnership.deployed();
	
};