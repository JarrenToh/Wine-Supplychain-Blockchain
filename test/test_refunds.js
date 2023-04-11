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

    it('Raw material supplier adds raw materials (grapes, sugar, yeast and expired yeast)', async () => {
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

        let sugar = await rawMaterialSupplierInstance.addRawMaterial(
            "Granulated Sugar",
            "Rhine, Germany",
            "April 1, 2023",
            "April 1, 2024",
            20,
            "pounds",
            1,
            3,
            "Sugar",
            "The Rheingau",
            { from: accounts[1] });

        let yeast = await rawMaterialSupplierInstance.addRawMaterial(
            "Yeast",
            "Rhine, Germany",
            "April 1, 2023",
            "April 1, 2024",
            20,
            "pounds",
            1,
            3,
            "Yeast",
            "The Rheingau",
            { from: accounts[1] });

        let expiredYeast = await rawMaterialSupplierInstance.addRawMaterial(
            "Yeast",
            "Rhine, Germany",
            "April 1, 2022",
            "April 1, 2023",
            20,
            "pounds",
            1,
            3,
            "Yeast",
            "The Rheingau",
            { from: accounts[1] });

        const owner = await productInstance.getCurrentOwner(0);

        await assert.notStrictEqual(
            grapes,
            undefined,
            "Failed to Add Grapes"
        );

        // await assert.notStrictEqual(
        //     sugar,
        //     undefined,
        //     "Failed to Add Sugar"
        // );

        // await assert.notStrictEqual(
        //     yeast,
        //     undefined,
        //     "Failed to Add Yeast"
        // );

        await assert.strictEqual(
            owner,
            accounts[1],
            "Raw material owner is incorrect"
        );

        truffleAssert.eventEmitted(grapes, "rawMaterialAdded");
        truffleAssert.eventEmitted(sugar, "rawMaterialAdded");
        truffleAssert.eventEmitted(yeast, "rawMaterialAdded");
        truffleAssert.eventEmitted(expiredYeast, "rawMaterialAdded");
    });

    it('Raw materials set as ready to ship', async () => {
        let readyToShipGrapes = await rawMaterialSupplierInstance.materialReadyToShip(0, { from: accounts[1] });
        let readyToShipSugar = await rawMaterialSupplierInstance.materialReadyToShip(1, { from: accounts[1] });
        let readyToShipYeast = await rawMaterialSupplierInstance.materialReadyToShip(2, { from: accounts[1] });
        let readyToShipExpiredYeast = await rawMaterialSupplierInstance.materialReadyToShip(3, { from: accounts[1] });
        const booleanGrapes = await productInstance.getReadyToShip(0, { from: accounts[1] });

        await assert.strictEqual(
            booleanGrapes,
            true,
            "Raw material not set as ready to ship"
        );

        truffleAssert.eventEmitted(readyToShipGrapes, "rawMaterialReadyToShip");
        truffleAssert.eventEmitted(readyToShipSugar, "rawMaterialReadyToShip");
        truffleAssert.eventEmitted(readyToShipYeast, "rawMaterialReadyToShip");
        truffleAssert.eventEmitted(readyToShipExpiredYeast, "rawMaterialReadyToShip");
    });

    it('Wine producer buys raw materials from raw material supplier', async () => {
        const balance = await web3.eth.getBalance(accounts[1]);
        const balance2 = await web3.eth.getBalance(accounts[2]);
        let buyGrapes = await wineProducerInstance.buy(0, { from: accounts[2], value: 1E18 });
        let buySugar = await wineProducerInstance.buy(1, { from: accounts[2], value: 1E18 });
        let buyYeast = await wineProducerInstance.buy(2, { from: accounts[2], value: 1E18 });
        let buyExpiredYeast = await wineProducerInstance.buy(3, { from: accounts[2], value: 1E18 });

        const afterBalance = await web3.eth.getBalance(accounts[1]);
        const afterBalance2 = await web3.eth.getBalance(accounts[2]);
        console.log(`Account balance of raw material supplier: ${balance}`);
        console.log(`Account balance of raw material supplier: ${afterBalance}`);
        console.log(`Account balance of wine producer: ${balance2}`);
        console.log(`Account balance of wine producer: ${afterBalance2}`);

        truffleAssert.eventEmitted(buyGrapes, "buyRawMaterial");
        truffleAssert.eventEmitted(buySugar, "buyRawMaterial");
        truffleAssert.eventEmitted(buyYeast, "buyRawMaterial");
        truffleAssert.eventEmitted(buyExpiredYeast, "buyRawMaterial");
    });

    it('Raw material supplier dispatches raw materials to wine producer', async () => {
        let dispatch = await rawMaterialSupplierInstance.dispatchRawMaterial(0, "April 4, 2023", accounts[2], wineProducerInstance.address, { from: accounts[1] });
        let dispatch2 = await rawMaterialSupplierInstance.dispatchRawMaterial(1, "April 4, 2023", accounts[2], wineProducerInstance.address, { from: accounts[1] });
        let dispatch3 = await rawMaterialSupplierInstance.dispatchRawMaterial(2, "April 4, 2023", accounts[2], wineProducerInstance.address, { from: accounts[1] });
        let dispatch4 = await rawMaterialSupplierInstance.dispatchRawMaterial(3, "April 4, 2023", accounts[2], wineProducerInstance.address, { from: accounts[1] });
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

        truffleAssert.eventEmitted(dispatch, "rawMaterialDispatched");
        truffleAssert.eventEmitted(dispatch2, "rawMaterialDispatched");
        truffleAssert.eventEmitted(dispatch3, "rawMaterialDispatched");
        truffleAssert.eventEmitted(dispatch4, "rawMaterialDispatched");
    });

    it('Wine producer receives raw materials from raw material distributor', async () => {
        let receive = await wineProducerInstance.received(0, "Von Winning Winery, Pfalz", "April 8, 2023", { from: accounts[2] });
        let receive2 = await wineProducerInstance.received(1, "Von Winning Winery, Pfalz", "April 8, 2023", { from: accounts[2] });
        let receive3 = await wineProducerInstance.received(2, "Von Winning Winery, Pfalz", "April 8, 2023", { from: accounts[2] });
        let receive4 = await wineProducerInstance.received(3, "Von Winning Winery, Pfalz", "April 8, 2023", { from: accounts[2] });

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
        truffleAssert.eventEmitted(receive2, "rawMaterialReceived");
        truffleAssert.eventEmitted(receive3, "rawMaterialReceived");
        truffleAssert.eventEmitted(receive4, "rawMaterialReceived");
    });

    it('Return expired yeast to raw material supplier', async () => { 
        let returnYeast = await wineProducerInstance.returnRawMaterials(3, { from: accounts[2] });

        const owner = await productInstance.getCurrentOwner(3);
        const prevOwner = await productInstance.getPreviousOwner(3);
        const contract = await productInstance.getCurrentContractAddress(3);
        const prevContract = await productInstance.getPreviousContractAddress(3);

        await assert.strictEqual(
            owner,
            accounts[1],
            "Raw material owner is incorrect"
        );

        await assert.strictEqual(
            prevOwner,
            accounts[2],
            "Raw material previous owner is incorrect"
        );

        await assert.strictEqual(
            contract,
            rawMaterialSupplierInstance.address,
            "Raw material contract address is incorrect"
        );

        await assert.strictEqual(
            prevContract,
            wineProducerInstance.address,
            "Raw material previous contract address is incorrect"
        );

        truffleAssert.eventEmitted(returnYeast, "returnedRawMaterial");
        
    });

    it('Refund money to wine producer', async () => {
        const balance = await web3.eth.getBalance(accounts[1]);
        const balance2 = await web3.eth.getBalance(accounts[2]);

        let refund = await rawMaterialSupplierInstance.refundWineProducer(3, { from: accounts[1], value : 1E18 })
        const afterBalance = await web3.eth.getBalance(accounts[1]);
        const afterBalance2 = await web3.eth.getBalance(accounts[2]);
        const diff = web3.utils.toBN(afterBalance2).sub(web3.utils.toBN(balance2));
        console.log(`Account balance of raw material supplier: ${balance}`);
        console.log(`Account balance of raw material supplier: ${afterBalance}`);
        console.log(`Account balance of wine producer: ${balance2}`);
        console.log(`Account balance of wine producer: ${afterBalance2}`);


        await assert.strictEqual(
            diff.toString(),
            "3",
            "Money not refunded back to wine producer"
        );

        truffleAssert.eventEmitted(refund, "refundRawMaterial");
    });

    it('Remove raw material (Expired yeast)', async () => {
        let remove = await rawMaterialSupplierInstance.removeRawMaterial(3, {from: accounts[1]});

        const owner = await productInstance.getCurrentOwner(3);

        await assert.strictEqual(
            owner,
            '0x0000000000000000000000000000000000000000',
            "Raw material not removed"
        );


        truffleAssert.eventEmitted(remove, "rawMaterialRemoved");
    });

    it('Process Wine', async () => {
            let process = await wineProducerInstance.processWine([0, 1, 2], "Germany", "12 April 2023", "12 April 2024", 1, "barrels", 1, 1, "White wine", "Location", { from: accounts[2] });
            const owner = await productInstance.getCurrentOwner(4);
            const componentIds = await productInstance.getComponentProductIds(4);

        await assert.notStrictEqual(
            process,
            undefined,
            "Failed to create wine"
        );

        await assert.strictEqual(
            owner,
            accounts[2],
            "Wine owner is incorrect"
        );
       
            truffleAssert.eventEmitted(process, "processedWine");
    });

    it('Wine set as ready to ship', async () => {
        let readyToShip = await wineProducerInstance.wineReadyToShip(4, { from: accounts[2] });
        const boolean = await productInstance.getReadyToShip(4, { from: accounts[2] });

        await assert.strictEqual(
            boolean,
            true,
            "Wine not set as ready to ship"
        );

        truffleAssert.eventEmitted(readyToShip, "WineReadyToShip");
    });

    it('Bulk distributor buys wine from wine producer', async () => {
        const balance = await web3.eth.getBalance(accounts[2]);
        const balance2 = await web3.eth.getBalance(accounts[3]);
        let buy = await bulkDistributorInstance.buyWineFromWineProducer(4, { from: accounts[3], value: 1E18 });

        const afterBalance = await web3.eth.getBalance(accounts[2]);
        const afterBalance2 = await web3.eth.getBalance(accounts[3]);
        console.log(`Account balance of wine producer: ${balance}`);
        console.log(`Account balance of wine producer: ${afterBalance}`);
        console.log(`Account balance of bulk distributor: ${balance2}`);
        console.log(`Account balance of bulk distributor: ${afterBalance2}`);

        truffleAssert.eventEmitted(buy, "buyWine");
    });

    it('Wine producer dispatches wine to bulk distributor', async () => {
        let dispatch = await wineProducerInstance.dispatchWineToBulkDistributor(4, "April 12, 2023", accounts[3], bulkDistributorInstance.address, { from: accounts[2] });

        const owner = await productInstance.getCurrentOwner(4);

        await assert.strictEqual(
            owner,
            accounts[3],
            "Wine owner is incorrect"
        );

        const prevOwner = await productInstance.getPreviousOwner(4);

        await assert.strictEqual(
            prevOwner,
            accounts[2],
            "Wine previous owner is incorrect"
        );

        truffleAssert.eventEmitted(dispatch, "WineDisbatched");
    });

    it('Bulk distributor receives wine from wine producer', async () => {
        let receive = await bulkDistributorInstance.receiveWine(4, "Von Winning Winery, Pfalz", "April 16, 2023", { from: accounts[3] });

        let result = await productInstance.getCurrentLocation(4);
        assert.equal(result[0], "Von Winning Winery, Pfalz", "Location is not the same");
        assert.equal(result[1], "", "Dispatch date is not the same");
        assert.equal(result[2], "April 16, 2023", "Arrival date is not the same");

        const booleanReceived = await productInstance.getReceived(4);

        await assert.strictEqual(
            booleanReceived,
            true,
            "Wine not received by bulk distributor"
        );


        truffleAssert.eventEmitted(receive, "wineReceived");
    });

    it('Return wine to wine producer', async () => { 
        let returnWine = await bulkDistributorInstance.returnWine(4, { from: accounts[3] });

        const owner = await productInstance.getCurrentOwner(4);
        const prevOwner = await productInstance.getPreviousOwner(4);
        const contract = await productInstance.getCurrentContractAddress(4);
        const prevContract = await productInstance.getPreviousContractAddress(4);

        await assert.strictEqual(
            owner,
            accounts[2],
            "Wine owner is incorrect"
        );

        await assert.strictEqual(
            prevOwner,
            accounts[3],
            "Wine previous owner is incorrect"
        );

        await assert.strictEqual(
            contract,
            wineProducerInstance.address,
            "Wine contract address is incorrect"
        );

        await assert.strictEqual(
            prevContract,
            bulkDistributorInstance.address,
            "Wine previous contract address is incorrect"
        );

        truffleAssert.eventEmitted(returnWine, "returnedWine");
        
    });

    it('Refund money to bulk distributor', async () => {
        const balance = await web3.eth.getBalance(accounts[2]);
        const balance2 = await web3.eth.getBalance(accounts[3]);

        let refund = await wineProducerInstance.refundBulkDistributor(4, { from: accounts[2], value : 1E18 })
        const afterBalance = await web3.eth.getBalance(accounts[2]);
        const afterBalance2 = await web3.eth.getBalance(accounts[3]);
        const diff = web3.utils.toBN(afterBalance2).sub(web3.utils.toBN(balance2));
        console.log(`Account balance of wine producer: ${balance}`);
        console.log(`Account balance of wine producer: ${afterBalance}`);
        console.log(`Account balance of bulk distributor: ${balance2}`);
        console.log(`Account balance of bulk distributor: ${afterBalance2}`);

        await assert.strictEqual(
            diff.toString(),
            "1",
            "Money not refunded back to bulk distributor"
        );


        truffleAssert.eventEmitted(refund, "refundWine");
    });

    it('Remove wine', async () => {
        let remove = await wineProducerInstance.removeWine(4, {from: accounts[2]});

        const owner = await productInstance.getCurrentOwner(4);

        await assert.strictEqual(
            owner,
            '0x0000000000000000000000000000000000000000',
            "Wine not removed"
        );


        truffleAssert.eventEmitted(remove, "wineRemoved");
    });

})