const WrappedNative = artifacts.require("WrappedNative");

module.exports = function(deployer) {
  console.log(process.argv);

  // assuming `truffle migrate --network networkname`
  const network = process.argv[4];

  if (network == "volta") {
    console.log("Deploying Wrapped Volta Token");
    deployer.deploy(WrappedNative, "Wrapped Volta Token", "WVT");
  } else if (network == "ewc") {
      console.log("Deploying Wrapped Energy Web Token");
    deployer.deploy(WrappedNative, "Wrapped Energy Web Token", "WEWT");    
  } else {
      console.log("No migration config for this network yet.")
  }
};
