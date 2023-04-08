const _deploy_contracts = require("../migrations/2_deploy_contracts.js");
const truffleAssert = require('truffle-assertions');
var assert = require("assert");


var Product = artifacts.require("../contracts/Product.sol");
var RawMaterialSupplier = artifacts.require("../contracts/RawMaterialSupplier.sol");
var WineProducer = artifacts.require("../contracts/WineProducer.sol");
var BulkDistributor = artifacts.require("../contracts/BulkDistributor.sol");
var TransitCellar = artifacts.require("../contracts/TransitCellar.sol");
var FillerPacker = artifacts.require("../contracts/FillerPacker.sol");
var GoodsDistributor = artifacts.require("../contracts/GoodsDistributor.sol");
var Wholesaler = artifacts.require("../contracts/Wholesaler.sol");
var Retailer = artifacts.require("../contracts/Retailer.sol");

contract('Refund', function (accounts) {
    before(async () => {
        productInstance = await Product.deployed();
        rawMaterialSupplierInstance = await RawMaterialSupplier.deployed();
        wineProducerInstance = await WineProducer.deployed();
        bulkDistributorInstance = await BulkDistributor.deployed();
        transitCellarInstance = await TransitCellar.deployed();
        fillerPackerInstance = await FillerPacker.deployed();
        goodsDistributorInstance = await GoodsDistributor.deployed();
        wholesalerInstance = await Wholesaler.deployed();
        retailerInstance = await Retailer.deployed();
    });

    console.log("Testing Refund");

    it('Raw material supplier adds raw materials', async () => {
        let grapes = await rawMaterialSupplierInstance.addRawMaterial(
            "Riesling Grapes",
            "Rhine, Germany",
            "April 1, 2023",
            "April 8, 2023",
            20,
            "pounds",
            1,
            3,
            "Fruits",
            "The Rheingau",
            { from: accounts[1] });

        // let sugar = await rawMaterialSupplierInstance.addRawMaterial(
        //     "Granulated Sugar",
        //     "Rhine, Germany",
        //     "April 1, 2023",
        //     "April 1, 2024",
        //     20,
        //     "pounds",
        //     10,
        //     3,
        //     "Sugar",
        //     "The Rheingau",
        //     { from: accounts[1] });

        // let yeast = await rawMaterialSupplierInstance.addRawMaterial(
        //     "Yeast",
        //     "Rhine, Germany",
        //     "April 1, 2023",
        //     "April 1, 2024",
        //     20,
        //     "pounds",
        //     10,
        //     3,
        //     "Yeast",
        //     "The Rheingau",
        //     { from: accounts[1] });

        const owner = await productInstance.getCurrentOwner(0);

        await assert.notStrictEqual(
            grapes,
            undefined,
            "Failed to Add Grapes"
        );

        // await assert.notStrictEqual(
        //     sugar,
        //     undefined,
        //     "Failed to Add Grapes"
        // );

        // await assert.notStrictEqual(
        //     yeast,
        //     undefined,
        //     "Failed to Add Grapes"
        // );

        await assert.strictEqual(
            owner,
            accounts[1],
            "Raw material owner is incorrect"
        );

        // truffleAssert.eventEmitted(grapes, "ProductCreated");
        truffleAssert.eventEmitted(grapes, "rawMaterialAdded");
        // truffleAssert.eventEmitted(sugar, "rawMaterialAdded");
        // truffleAssert.eventEmitted(yeast, "rawMaterialAdded");
    });

    it('Raw materials set as ready to ship', async () => {
        let readyToShipGrapes = await rawMaterialSupplierInstance.materialReadyToShip(0, { from: accounts[1] });
        const booleanGrapes = await productInstance.getReadyToShip(0, { from: accounts[1] });

        // let readyToShipSugar = await rawMaterialSupplierInstance.materialReadyToShip(1, { from: accounts[1] });
        // let readyToShipYeast = await rawMaterialSupplierInstance.materialReadyToShip(2, { from: accounts[1] });

        await assert.strictEqual(
            booleanGrapes,
            true,
            "Raw material not set as ready to ship"
        );

        truffleAssert.eventEmitted(readyToShipGrapes, "rawMaterialReadyToShip");
        // truffleAssert.eventEmitted(readyToShipSugar, "rawMaterialReadyToShip");
        // truffleAssert.eventEmitted(readyToShipYeast, "rawMaterialReadyToShip");
    });

    it('Wine producer buys raw materials from raw material supplier', async () => {
        const balance = await web3.eth.getBalance(accounts[1]);
        const balance2 = await web3.eth.getBalance(accounts[2]);
        let buyGrapes = await wineProducerInstance.buy(0, { from: accounts[2], value: 1E18 });

        const afterBalance = await web3.eth.getBalance(accounts[1]);
        const afterBalance2 = await web3.eth.getBalance(accounts[2]);
        console.log(`Account balance of accounts[1]: ${balance}`);
        console.log(`Account balance of accounts[1]: ${afterBalance}`);
        console.log(`Account balance of accounts[2]: ${balance2}`);
        console.log(`Account balance of accounts[2]: ${afterBalance2}`);

        truffleAssert.eventEmitted(buyGrapes, "buyRawMaterial");
    });

    it('Raw material supplier dispatches raw materials to wine producer', async () => {
        let dispatch = await rawMaterialSupplierInstance.disbatchRawMaterial(0, "April 4, 2023", accounts[2], wineProducerInstance.address, { from: accounts[1] });

        const owner = await productInstance.getCurrentOwner(0);

        await assert.strictEqual(
            owner,
            accounts[2],
            "Raw material owner is incorrect"
        );

        const prevOwner = await productInstance.getPreviousOwner(0);

        await assert.strictEqual(
            prevOwner,
            accounts[1],
            "Raw material previous owner is incorrect"
        );

        truffleAssert.eventEmitted(dispatch, "rawMaterialDisbatched");
    });

    it('Wine producer receives raw materials from raw material distributor', async () => {
        let receive = await wineProducerInstance.received(0, "Von Winning Winery, Pfalz", "April 8, 2023", { from: accounts[2] });

        let result = await productInstance.getCurrentLocation(0);
        assert.equal(result[0], "Von Winning Winery, Pfalz", "Location is not the same");
        assert.equal(result[1], "", "Dispatch date is not the same");
        assert.equal(result[2], "April 8, 2023", "Arrival date is not the same");

        const booleanReceived = await productInstance.getReceived(0);

        await assert.strictEqual(
            booleanReceived,
            true,
            "Raw material not received by wine producer"
        );


        truffleAssert.eventEmitted(receive, "rawMaterialReceived");
    });

    it('Return raw materials to raw material supplier', async () => { 
        let returnGrapes = await wineProducerInstance.returnRawMaterials(0, { from: accounts[2] });

        truffleAssert.eventEmitted(returnGrapes, "returnedRawMaterial");
        
    });

    it('Refund money to wine producer', async () => {
        const balance = await web3.eth.getBalance(accounts[1]);
        const balance2 = await web3.eth.getBalance(accounts[2]);

        let refund = await rawMaterialSupplierInstance.refundWineProducer(0, { from: accounts[1], value : 1E18 })
        const afterBalance = await web3.eth.getBalance(accounts[1]);
        const afterBalance2 = await web3.eth.getBalance(accounts[2]);
        console.log(`Account balance of accounts[1]: ${balance}`);
        console.log(`Account balance of accounts[1]: ${afterBalance}`);
        console.log(`Account balance of accounts[2]: ${balance2}`);
        console.log(`Account balance of accounts[2]: ${afterBalance2}`);

        // await assert.strictEqual(
        //     balance - afterBalance,
        //     3,
        //     "Money not subtracted from raw material supplier"
        // );

        await assert.strictEqual(
            Number(afterBalance2) - Number(balance2),
            3,
            "Money not refunded back to wine producer"
        );

        assert.equal(Number(afterBalance2) - Number(balance2), 3, "Money not refunded back to wine producer");


        truffleAssert.eventEmitted(refund, "refundRawMaterial");
    });

    // it('Test', async () => {

    // });

    // it('Test', async () => {

    // });

    // it('Test', async () => {

    // });

    // it('Test', async () => {

    // });

    // it('Test', async () => {

    // });

    // it('Test', async () => {

    // });

    // it('Test', async () => {

    // });

    // it('Test', async () => {

    // });

})