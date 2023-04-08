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

        let addGrape = await rawMaterialSupplierInstance.addRawMaterial("Grape", "Middle East", "1/4/2023", "1/4/2024", 1, "Gram", 10, 2, "Fruit", "Grape Supplier", { from: accounts[1] });

       // let addGrape2 = await rawMaterialSupplierInstance.addRawMaterial("Sugar", "Middle East", "1/4/2023", "1/4/2024", 1, "Gram", 10, 2, "Fruit", "Grape Supplier", { from: accounts[1] });

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
            1,
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
            10,
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

        assert.strictEqual(
            await productInstance.getReadyToShip(0, {from: accounts[1]}), 
            true, 
            "Failed to set raw materials ready for shipping");
    });


    it('Wine producer buy wine from raw materials supplier', async () => {
        let ownerBalanceBefore = web3.utils.toBN(await web3.eth.getBalance(accounts[1]));
        let buyFromRms = await wineProducerInstance.buy(0, {from: accounts[2], value: 21});

        truffleAssert.eventEmitted(buyFromRms, "buyRawMaterial");

        let ownerBalanceAfter = web3.utils.toBN(await web3.eth.getBalance(accounts[1]));

        assert(ownerBalanceAfter.sub(ownerBalanceBefore).eq(web3.utils.toBN(20)), "Owner did not receive the correct amount");

    });


    it('Dispatch raw materials to wine producer', async () => {
        let dispatchToWineProducer = await rawMaterialSupplierInstance.dispatchRawMaterial(0, "8/4/2023", accounts[2], wineProducerInstance.address, { from: accounts[1] });

        truffleAssert.eventEmitted(dispatchToWineProducer, "rawMaterialDisbatched");

        let dispatchDateResult = await productInstance.getCurrentLocation(0);
        let dispatchDate = dispatchDateResult[1];

        console.log(dispatchDate);

        await assert.equal(
            web3.utils.keccak256(dispatchDate),
            web3.utils.keccak256("8/4/2023"),
            "Failed to dispatch raw materials to wine producer - dispatch date is not the same"
        );

        console.log("dispatch date");

        await assert.equal(
            await productInstance.getCurrentOwner(0),
            accounts[2],
            "Failed to dispatch raw materials to wine producer - owner address is not the same"
        );

        console.log("owner address");

        await assert.equal(
            await productInstance.getCurrentContractAddress(0),
            wineProducerInstance.address,
            "Failed to dispatch raw materials to wine producer - contract address is not the same"
        );

        console.log("contract address");
    });

    it('Wine Producer received the raw materials', async () => {
        let receiveRm = await wineProducerInstance.received(0, "Wine Factory", "9/4/2023", { from: accounts[2] })

        truffleAssert.eventEmitted(receiveRm, "rawMaterialReceived");

        let locationResult = await productInstance.getCurrentLocation(0);
        let location = locationResult[0];

        await assert.strictEqual(
            web3.utils.keccak256(location),
            web3.utils.keccak256("Wine Factory"),
            "Failed to add Grape - current location is not the same"
        );

        let arrivalDate = locationResult[2];

        console.log(arrivalDate);

        await assert.equal(
            web3.utils.keccak256(arrivalDate),
            web3.utils.keccak256("9/4/2023"),
            "Failed to dispatch raw materials to wine producer - arrival date is not the same"
        );

        assert.strictEqual(
            await productInstance.getReceived(0), 
            true, 
            "Failed to receive raw materials from raw materials supplier");

    });

    it('Process wine in wine producer', async () => {
        // uint256[] memory productIds,
        // string memory placeOfOrigin,
        // string memory productionDate,
        // string memory expirationDate, 
        // uint256 unitQuantity, 
        // string memory unitQuantityType, 
        // uint256 batchQuantity, 
        // uint256 unitPrice, 
        // string memory category, 
        // string memory currentPhysicalLocation
        // let p1 = await wineProducerInstance.process
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