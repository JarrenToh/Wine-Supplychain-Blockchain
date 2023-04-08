const _deploy_contracts = require("../migrations/2_deploy_contracts.js");
const truffleAssert = require("truffle-assertions");
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

    let productId;

    it('Test add raw material', async () => {
        console.log("Enter here");

        let addGrape = await rawMaterialSupplierInstance.addRawMaterial("Grape", "Middle East", "1/4/2023", "1/4/2024", 100, "Gram", 1000, 2, "Fruit", "Grape Supplier", { from: accounts[1] });

        let addGrape2 = await rawMaterialSupplierInstance.addRawMaterial("Sugar", "Middle East", "1/4/2023", "1/4/2024", 100, "Gram", 1000, 2, "Fruit", "Grape Supplier", { from: accounts[1] });

        console.log(await productInstance.getProductName(0));
        // console.log(await addGrape);

        await assert.notStrictEqual(
            addGrape,
            undefined,
            "Failed to add Grape"
        );

        truffleAssert.eventEmitted(addGrape, "rawMaterialAdded");

        console.log("event emitted");

        await assert.equal(
            web3.utils.keccak256(await productInstance.getProductName(0)),
            web3.utils.keccak256("Grape"),
            "Failed to add Grape - product name is not the same"
        );

        console.log("Test value of product name");

        await assert.equal(
            web3.utils.keccak256(await productInstance.getPlaceOfOrigin(0)),
            web3.utils.keccak256("Middle East"),
            "Failed to add Grape - place of origin is not the same"
        );

        console.log("Test value of place of origin");

        await assert.equal(
            web3.utils.keccak256(await productInstance.getProductionDate(0)),
            web3.utils.keccak256("1/4/2023"),
            "Failed to add Grape - production date is not the same"
        );

        console.log("Test value of production date");

        await assert.equal(
            web3.utils.keccak256(await productInstance.getExpirationDate(0)),
            web3.utils.keccak256("1/4/2024"),
            "Failed to add Grape - expiration date is not the same"
        );

        console.log("Test value of expiration date");

        await assert.strictEqual(
            Number(await productInstance.getUnitQuantity(0)),         
            100,
            "Failed to add Grape - unit quantity is not the same"
        )

        console.log("Test value of unit quantity");

        await assert.equal(
            web3.utils.keccak256(await productInstance.getUnitQuantityType(0)),
            web3.utils.keccak256("Gram"),
            "Failed to add Grape - unit quantity type is not the same"
        );

        console.log("Test value of unit quantity type")

        await assert.strictEqual(
            Number(await productInstance.getBatchQuantity(0)),
            1000,
            "Failed to add Grape - batch quantity is not the same"
        );

        console.log("Test value of batch quantity");

        await assert.strictEqual(
            Number(await productInstance.getUnitPrice(0)),
            2,
            "Failed to add Grape - unit price is not the same"
        );

        console.log("Test unit price");

        await assert.equal(
            web3.utils.keccak256(await productInstance.getCategory(0)),
            web3.utils.keccak256("Fruit"),
            "Failed to add Grape - category is not the same"
        );

        console.log("Test value of category");

        let locationResult = await productInstance.getCurrentLocation(0);
        let location = locationResult[0];

        await assert.strictEqual(
            web3.utils.keccak256(location),
            web3.utils.keccak256("Grape Supplier"),
            "Failed to add Grape - location is not the same"
        );

        console.log("Test value of current location");
    });

    it('Material Ready to ship in RawMaterialSupplier', async () => {
        let rts = await rawMaterialSupplierInstance.materialReadyToShip(0, {from: accounts[1]});

        truffleAssert.eventEmitted(rts, "rawMaterialReadyToShip");

       console.log(await productInstance.getReadyToShip(0, {from: accounts[1]}));

        // await productInstance.setReadyToShip(0, true, {from: accounts[1]});

        assert.strictEqual(
            await productInstance.getReadyToShip(0, {from: accounts[1]}), 
            true, 
            "Failed to set raw materials ready for shipping");
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