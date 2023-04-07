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
    return deployer.deploy(RawMaterialSupplier, Product.address);
  })
  .then(function() {
    return deployer.deploy(WineProducer, Product.address, RawMaterialSupplier.address);
  })
  .then(function() {
    return deployer.deploy(BulkDistributor, Product.address, WineProducer.address);
  })
  .then(function() {
    return deployer.deploy(TransitCellar, Product.address, BulkDistributor.address);
  })
  .then(function() {
    return deployer.deploy(FillerPacker, Product.address, TransitCellar.address);
  })
  .then(function() {
    return deployer.deploy(GoodDistributor, Product.address, FillerPacker.address);
  })
  .then(function() {
    return deployer.deploy(Wholesaler, Product.address, GoodDistributor.address);
  })
  .then(function() {
    return deployer.deploy(Retailer, Product.address, Wholesaler.address);
  });
};