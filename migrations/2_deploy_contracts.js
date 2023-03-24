const Product = artifacts.require("Product");
const RawMaterialSupplier = artifacts.require("RawMaterialSupplier");
const WineProducer = artifacts.require("WineProducer");
const BulkDistributor = artifacts.require("BulkDistributor");
const TransitCellar = artifacts.require("TransitCellar");
const FillerPacker = artifacts.require("FillerPacker");
const GoodDistributor = artifacts.require("GoodsDistributor");
const Wholesaler = artifacts.require("Wholesaler");
const Retailer = artifacts.require("Retailer");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Product)
  .then(function() {
    return deployer.deploy(RawMaterialSupplier);
  })
  .then(function() {
    return deployer.deploy(WineProducer);
  })
  .then(function() {
    return deployer.deploy(BulkDistributor);
  })
  .then(function() {
    return deployer.deploy(TransitCellar);
  })
  .then(function() {
    return deployer.deploy(FillerPacker);
  })
  .then(function() {
    return deployer.deploy(GoodDistributor);
  })
  .then(function() {
    return deployer.deploy(Wholesaler);
  })
  .then(function() {
    return deployer.deploy(Retailer);
  });
};