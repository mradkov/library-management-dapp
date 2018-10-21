const SafeMath = artifacts.require("../contracts/libs/SafeMath.sol");
const Destructible = artifacts.require("../contracts/common/Destructible.sol");
const Ownable = artifacts.require("../contracts/common/Ownable.sol");
const LibraryManagement = artifacts.require("../contracts/LibraryManagement.sol");
module.exports = (deployer) => {
   //deploy

    deployer.deploy(SafeMath);
    deployer.deploy(Destructible);

    deployer.link(SafeMath, LibraryManagement);
    deployer.link(Destructible, LibraryManagement);
    deployer.deploy(LibraryManagement);

};