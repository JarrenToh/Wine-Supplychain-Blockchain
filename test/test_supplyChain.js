const _deploy_contracts = require("../migrations/2_deploy_contracts.js");
const truffleAssert = require('truffle-assertions');
var assert = require("assert");


var Product = artifacts.require("../contracts/Product.sol");
var RawMaterialSupplier = artifacts.require("../contracts/RawMaterialSupplier.sol");
var WineProducer = artifacts.require("../contracts/WineProducer.sol");
var BulkDistributor = artifacts.require("../contracts/BulkDistributor.sol");
var TransitCellar = artifacts.require("../contracts/TransitCellar.sol");
var FillerPacker = artifacts.require("../contracts/FillerPacker.sol");
var GoodDistributor = artifacts.require("../contracts/GoodsDistributor.sol");
var Wholesaler = artifacts.require("../contracts/Wholesaler.sol");
var Retailer = artifacts.require("../contracts/Retailer.sol");

contract('SupplyChain', function (accounts) {
    before(async () => {
        productInstance = await Product.deployed();
        rawMaterialSupplierInstance = await RawMaterialSupplier.deployed();
        wineProducerInstance = await WineProducer.deployed();
        bulkDistributorInstance = await BulkDistributor.deployed();
        transitCellarInstance = await TransitCellar.deployed();
        fillerPackerInstance = await FillerPacker.deployed();
        goodDistributorInstance = await GoodDistributor.deployed();
        wholesalerInstance = await Wholesaler.deployed();
        retailerInstance = await Retailer.deployed();
    });

    console.log("Testing Supply Chain");

    it('Test add raw material', async () => {

    });

    it('Test ', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

    it('Test', async () => {

    });

})