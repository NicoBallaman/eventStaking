module.exports = {
  networks: {
    development: {
      host: "192.168.0.36",
      port: 7545,
      network_id: "*", // Match any network id
      gas: 5000000
    }
  },
  compilers: {
    solc: {
      version: "0.8.10",
      settings: {
        optimizer: {
          enabled: true, // Default: false
          runs: 200      // Default: 200
        },
      }
    }
  }
};
