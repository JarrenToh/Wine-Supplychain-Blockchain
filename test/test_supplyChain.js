const _deploy_contracts = require("../migrations/2_deploy_contracts.js");
const truffleAssert = require("truffle-assertions");
var assert = require("assert");

// var Product = artifacts.require("../contracts/Product.sol");
// var RawMaterialSupplier = artifacts.require("../contracts/RawMaterialSupplier.sol");
// var WineProducer = artifacts.require("../contracts/WineProducer.sol");
// var BulkDistributor = artifacts.require("../contracts/BulkDistributor.sol");
// var TransitCellar = artifacts.require("../contracts/TransitCellar.sol");
// var FillerPacker = artifacts.require("../contracts/FillerPacker.sol");
// var GoodDistributor = artifacts.require("../contracts/GoodsDistributor.sol");
// var Wholesaler = artifacts.require("../contracts/Wholesaler.sol");
// var Retailer = artifacts.require("../contracts/Retailer.sol");

// contract('SupplyChain', function (accounts) {
//     before(async () => {
//         productInstance = await Product.deployed();
//         rawMaterialSupplierInstance = await RawMaterialSupplier.deployed();
//         wineProducerInstance = await WineProducer.deployed();
//         bulkDistributorInstance = await BulkDistributor.deployed();
//         transitCellarInstance = await TransitCellar.deployed();
//         fillerPackerInstance = await FillerPacker.deployed();
//         goodDistributorInstance = await GoodDistributor.deployed();
//         wholesalerInstance = await Wholesaler.deployed();
//         retailerInstance = await Retailer.deployed();
//     });

//     console.log("Testing Supply Chain");

//     let productId;

//     it('Test add raw material', async () => {
//         console.log("Enter here");

        let addGrape = await rawMaterialSupplierInstance.addRawMaterial("Grape", "Middle East", "1/4/2023", "1/4/2024", 1, "Gram", 10, 2, "Fruit", "Grape Supplier", { from: accounts[1] });

       // let addGrape2 = await rawMaterialSupplierInstance.addRawMaterial("Sugar", "Middle East", "1/4/2023", "1/4/2024", 1, "Gram", 10, 2, "Fruit", "Grape Supplier", { from: accounts[1] });

//         console.log(await productInstance.getProductName(0));
//         // console.log(await addGrape);

//         await assert.notStrictEqual(
//             addGrape,
//             undefined,
//             "Failed to add Grape"
//         );

//         truffleAssert.eventEmitted(addGrape, "rawMaterialAdded");

//         console.log("event emitted");

//         await assert.equal(
//             web3.utils.keccak256(await productInstance.getProductName(0)),
//             web3.utils.keccak256("Grape"),
//             "Failed to add Grape - product name is not the same"
//         );

//         console.log("Test value of product name");

//         await assert.equal(
//             web3.utils.keccak256(await productInstance.getPlaceOfOrigin(0)),
//             web3.utils.keccak256("Middle East"),
//             "Failed to add Grape - place of origin is not the same"
//         );

//         console.log("Test value of place of origin");

//         await assert.equal(
//             web3.utils.keccak256(await productInstance.getProductionDate(0)),
//             web3.utils.keccak256("1/4/2023"),
//             "Failed to add Grape - production date is not the same"
//         );

//         console.log("Test value of production date");

//         await assert.equal(
//             web3.utils.keccak256(await productInstance.getExpirationDate(0)),
//             web3.utils.keccak256("1/4/2024"),
//             "Failed to add Grape - expiration date is not the same"
//         );

//         console.log("Test value of expiration date");

        await assert.strictEqual(
            Number(await productInstance.getUnitQuantity(0)),         
            1,
            "Failed to add Grape - unit quantity is not the same"
        )

//         console.log("Test value of unit quantity");

//         await assert.equal(
//             web3.utils.keccak256(await productInstance.getUnitQuantityType(0)),
//             web3.utils.keccak256("Gram"),
//             "Failed to add Grape - unit quantity type is not the same"
//         );

//         console.log("Test value of unit quantity type")

        await assert.strictEqual(
            Number(await productInstance.getBatchQuantity(0)),
            10,
            "Failed to add Grape - batch quantity is not the same"
        );

//         console.log("Test value of batch quantity");

//         await assert.strictEqual(
//             Number(await productInstance.getUnitPrice(0)),
//             2,
//             "Failed to add Grape - unit price is not the same"
//         );

//         console.log("Test unit price");

//         await assert.equal(
//             web3.utils.keccak256(await productInstance.getCategory(0)),
//             web3.utils.keccak256("Fruit"),
//             "Failed to add Grape - category is not the same"
//         );

//         console.log("Test value of category");

//         let locationResult = await productInstance.getCurrentLocation(0);
//         let location = locationResult[0];

//         await assert.strictEqual(
//             web3.utils.keccak256(location),
//             web3.utils.keccak256("Grape Supplier"),
//             "Failed to add Grape - location is not the same"
//         );

//         console.log("Test value of current location");
//     });

//     it('Material Ready to ship in RawMaterialSupplier', async () => {
//         let rts = await rawMaterialSupplierInstance.materialReadyToShip(0, {from: accounts[1]});

//         truffleAssert.eventEmitted(rts, "rawMaterialReadyToShip");

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
            "Failed to receive raw materials from raw materials supplier - current location is not the same"
        );

        let arrivalDate = locationResult[2];

        console.log(arrivalDate);

        await assert.equal(
            web3.utils.keccak256(arrivalDate),
            web3.utils.keccak256("9/4/2023"),
            "Failed to receive raw materials from raw materials supplier - arrival date is not the same"
        );

        assert.strictEqual(
            await productInstance.getReceived(0), 
            true, 
            "Failed to receive raw materials from raw materials supplier");

    });

    it('Process wine in wine producer with raw materials available', async () => {

        let productIds = [0];

        let pw1 = await wineProducerInstance.processWine(productIds, "Mexico", "10/4/2023", "10/4/2040", 2, "Litre", 10, 2, "Wine", "Wine Factory", { from: accounts[2] })

        truffleAssert.eventEmitted(pw1, "processedWine");

        //assert.deepEqual(productIds, await productInstance.getComponentProductIds(1));

        assert.deepEqual(productIds.map(p => Number(p)), 
                        (await productInstance.getComponentProductIds(1)).map(p => Number(p)));

        assert.strictEqual(
            await productInstance.getUsed(0), 
            true, 
            "Failed to process wine - raw materials not used");

        await assert.equal(
            await productInstance.getCurrentOwner(1),
            accounts[2],
            "Failed to process wine - owner address is not the same"
        );
    

//     });

    it('Process wine in wine producer with raw materials unavailable', async () => {

        let productIds = [0];

        console.log(await productInstance.getUsed(0));

        await truffleAssert.reverts(
            wineProducerInstance.processWine(
              productIds,
              "Mexico",
              "10/4/2023",
              "10/4/2040",
              2,
              "Litre",
              10,
              2,
              "Wine",
              "Wine Factory",
              { from: accounts[2] }
            ),
            "You Do Not Have Sufficient Products To Process Wine"
          );

//     });

    it('Wine ready for shipping in wine producer contract', async () => {
        let wprts = await wineProducerInstance.wineReadyToShip(1, {from: accounts[2]});

        truffleAssert.eventEmitted(wprts, "WineReadyToShip");

        assert.strictEqual(
            await productInstance.getReadyToShip(1, {from: accounts[2]}), 
            true, 
            "Failed to set wine ready for shipping");

//     });

    it('Bulk Distributor buy wine from wine producer', async () => {

        let ownerBalanceBefore = web3.utils.toBN(await web3.eth.getBalance(accounts[2]));
        let buyFromWp = await bulkDistributorInstance.buyWineFromWineProducer(1, {from: accounts[3], value: 21});

        truffleAssert.eventEmitted(buyFromWp, "buyWine");

        let ownerBalanceAfter = web3.utils.toBN(await web3.eth.getBalance(accounts[2]));

        assert(ownerBalanceAfter.sub(ownerBalanceBefore).eq(web3.utils.toBN(20)), "Owner did not receive the correct amount");
    });

    it('Dispatch wine to bulk distributor', async () => {

        let dispatchToBulkDistributor = await wineProducerInstance.dispatchWineToBulkDistributor(1, "11/4/2023", accounts[3], bulkDistributorInstance.address, { from: accounts[2] });

        truffleAssert.eventEmitted(dispatchToBulkDistributor, "WineDisbatched");

        let dispatchDateResult = await productInstance.getCurrentLocation(1);
        let dispatchDate = dispatchDateResult[1];

        await assert.equal(
            web3.utils.keccak256(dispatchDate),
            web3.utils.keccak256("11/4/2023"),
            "Failed to dispatch wine to bulk distributor - dispatch date is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentOwner(1),
            accounts[3],
            "Failed to dispatch wine to bulk distributor - owner address is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentContractAddress(1),
            bulkDistributorInstance.address,
            "Failed to dispatch wine to bulk distributor - contract address is not the same"
        );
    });

    it('Bulk Distributor received the wine', async () => {
        let bdReceive = await bulkDistributorInstance.receiveWine(1, "Distributor warehouse", "12/4/2023", { from: accounts[3] })

        truffleAssert.eventEmitted(bdReceive, "wineReceived");

        let locationResult = await productInstance.getCurrentLocation(1);
        let location = locationResult[0];

        await assert.strictEqual(
            web3.utils.keccak256(location),
            web3.utils.keccak256("Distributor warehouse"),
            "Failed to receive wine from wine producer - current location is not the same"
        );

        let arrivalDate = locationResult[2];

        console.log(arrivalDate);

        await assert.equal(
            web3.utils.keccak256(arrivalDate),
            web3.utils.keccak256("12/4/2023"),
            "Failed to receive wine from wine producer - arrival date is not the same"
        );

        assert.strictEqual(
            await productInstance.getReceived(1), 
            true, 
            "Failed to receive wine from wine producer");

//     });

    it('Wine ready to ship in Bulk Dsitributor contract', async () => {
        let bdrts = await bulkDistributorInstance.materialReadyToShip(1, {from: accounts[3]});

        truffleAssert.eventEmitted(bdrts, "readyToShip");

        assert.strictEqual(
            await productInstance.getReadyToShip(1, {from: accounts[3]}), 
            true, 
            "Failed to set wine ready for shipping");
    });


    it('Transit cellar buy wine from bulk distributor', async () => {

        let ownerBalanceBefore = web3.utils.toBN(await web3.eth.getBalance(accounts[3]));
        let buyFrombd = await transitCellarInstance.buyWineFromBulkDistributor(1, {from: accounts[4], value: 21});

        truffleAssert.eventEmitted(buyFrombd, "wineBought");

        let ownerBalanceAfter = web3.utils.toBN(await web3.eth.getBalance(accounts[3]));

        assert(ownerBalanceAfter.sub(ownerBalanceBefore).eq(web3.utils.toBN(20)), "Owner did not receive the correct amount");

//     });

    it('Dispatch wine to transit cellar', async () => {
        
        let dispatchToTransitCellar = await bulkDistributorInstance. dispatchWineToTransitCellar(1, "13/4/2023", accounts[4], transitCellarInstance.address, { from: accounts[3] });

        truffleAssert.eventEmitted(dispatchToTransitCellar, "dispatchWine");

        let dispatchDateResult = await productInstance.getCurrentLocation(1);
        let dispatchDate = dispatchDateResult[1];

        await assert.equal(
            web3.utils.keccak256(dispatchDate),
            web3.utils.keccak256("13/4/2023"),
            "Failed to dispatch wine to transit cellar - dispatch date is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentOwner(1),
            accounts[4],
            "Failed to dispatch wine to transit cellar - owner address is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentContractAddress(1),
            transitCellarInstance.address,
            "Failed to dispatch wine to transit cellar - contract address is not the same"
        );

    });

    it('Transit cellar received the wine', async () => {
        let tcReceive = await transitCellarInstance.receiveWineFromBulkDistributor(1, "Truck", "14/4/2023", { from: accounts[4] })

        truffleAssert.eventEmitted(tcReceive, "wineReceived");

        let locationResult = await productInstance.getCurrentLocation(1);
        let location = locationResult[0];

        await assert.strictEqual(
            web3.utils.keccak256(location),
            web3.utils.keccak256("Truck"),
            "Failed to receive wine from bulk distributor - current location is not the same"
        );

        let arrivalDate = locationResult[2];

        console.log(arrivalDate);

        await assert.equal(
            web3.utils.keccak256(arrivalDate),
            web3.utils.keccak256("14/4/2023"),
            "Failed to receive wine from bulk distributor - arrival date is not the same"
        );

        assert.strictEqual(
            await productInstance.getReceived(1), 
            true, 
            "Failed to receive wine from bulk distributor");        
    });

    it('Analyse wine', async () => {

        let analyse = await transitCellarInstance.analyseWine(1, "Wine texture is good");

        truffleAssert.eventEmitted(analyse, "wineAnalysed");

        await assert.strictEqual(
            web3.utils.keccak256("Wine texture is good"),
            web3.utils.keccak256(await transitCellarInstance.getAnalysisDetails(1)),
            "Failed to analyse wine - analysis is not the same"
        );
    });

    it('Wine ready to ship in Transit Cellar contract', async () => {
        let tcrts = await transitCellarInstance.materialReadyToShip(1, {from: accounts[4]});

        truffleAssert.eventEmitted(tcrts, "readyToShip");

        assert.strictEqual(
            await productInstance.getReadyToShip(1, {from: accounts[4]}), 
            true, 
            "Failed to set wine ready for shipping");
    });


    it('Filler Packer buy wine from transit cellar', async () => {

        //console.log(`Product price: ${await productInstance.getUnitPrice(1) * await productInstance.getBatchQuantity(1)}`);

        let ownerBalanceBefore = web3.utils.toBN(await web3.eth.getBalance(accounts[4]));
        let buyFromtc = await fillerPackerInstance.buyWineFromTransitCellar(1, {from: accounts[5], value: 22});

        truffleAssert.eventEmitted(buyFromtc, "wineBought");

        let ownerBalanceAfter = web3.utils.toBN(await web3.eth.getBalance(accounts[4]));

        assert(ownerBalanceAfter.sub(ownerBalanceBefore).eq(web3.utils.toBN(20)), "Owner did not receive the correct amount");

//     });

    it('Dispatch wine to filler packer', async () => {
        
        let dispatchToFillerPacker = await transitCellarInstance.dispatchWineToFillerPacker(1, "16/4/2023", accounts[5], fillerPackerInstance.address, { from: accounts[4] });

        truffleAssert.eventEmitted(dispatchToFillerPacker, "wineDispatched");

        let dispatchDateResult = await productInstance.getCurrentLocation(1);
        let dispatchDate = dispatchDateResult[1];

        await assert.equal(
            web3.utils.keccak256(dispatchDate),
            web3.utils.keccak256("16/4/2023"),
            "Failed to dispatch wine to filler packer - dispatch date is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentOwner(1),
            accounts[5],
            "Failed to dispatch wine to transit cellar - owner address is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentContractAddress(1),
            fillerPackerInstance.address,
            "Failed to dispatch wine to transit cellar - contract address is not the same"
        );

    });

    it('Filler packer received the wine', async () => {
        let fpReceive = await fillerPackerInstance.receiveWineFromTransitCellar(1, "Packing warehouse", "17/4/2023", { from: accounts[5] })

        truffleAssert.eventEmitted(fpReceive, "wineReceived");

        let locationResult = await productInstance.getCurrentLocation(1);
        let location = locationResult[0];

        await assert.strictEqual(
            web3.utils.keccak256(location),
            web3.utils.keccak256("Packing warehouse"),
            "Failed to receive wine from transit cellar - current location is not the same"
        );

        let arrivalDate = locationResult[2];

        console.log(arrivalDate);

        await assert.equal(
            web3.utils.keccak256(arrivalDate),
            web3.utils.keccak256("17/4/2023"),
            "Failed to receive wine from transit cellar - arrival date is not the same"
        );

        assert.strictEqual(
            await productInstance.getReceived(1), 
            true, 
            "Failed to receive wine from transit cellar");        
    });

    it('Package wine', async () => {

        let package = await fillerPackerInstance.packageWine(1, "Box of 10 bottles of red wine");

        truffleAssert.eventEmitted(package, "winePackaged");

        await assert.equal(
            web3.utils.keccak256(await fillerPackerInstance.getPackagingDetails(1)),
            web3.utils.keccak256("Box of 10 bottles of red wine"),
            "Failed to package wine - packaging detail is not the same"
        );

//     });

    it('Label wine', async () => {

        let package = await fillerPackerInstance.labelWine(1, "Red wine");

        truffleAssert.eventEmitted(package, "wineLabelled");

        await assert.equal(
            web3.utils.keccak256(await fillerPackerInstance.getLabelDetails(1)),
            web3.utils.keccak256("Red wine"),
            "Failed to label wine - labelling detail is not the same"
        );

//     });

    it('Wine ready to ship in Filler Packer contract', async () => {
        let fprts = await fillerPackerInstance.materialReadyToShip(1, {from: accounts[5]});

        truffleAssert.eventEmitted(fprts, "readyToShip");

        assert.strictEqual(
            await productInstance.getReadyToShip(1, {from: accounts[5]}), 
            true, 
            "Failed to set wine ready for shipping");
    });
    
    it('Goods Distributor buy wine from filler packer', async () => {

        let ownerBalanceBefore = web3.utils.toBN(await web3.eth.getBalance(accounts[5]));
        let buyFromfp = await goodsDistributorInstance. buyWineFromFillerPacker(1, {from: accounts[6], value: 21});

        truffleAssert.eventEmitted(buyFromfp, "buyWineBatch");

        let ownerBalanceAfter = web3.utils.toBN(await web3.eth.getBalance(accounts[5]));

        assert(ownerBalanceAfter.sub(ownerBalanceBefore).eq(web3.utils.toBN(20)), "Owner did not receive the correct amount");
    });


    it('Dispatch wine to goods distributor', async () => {
        
        let dispatchToGoodsDistributor = await fillerPackerInstance.dispatchWineToGoodsDistributor(1, "18/4/2023", accounts[6], goodsDistributorInstance.address, { from: accounts[5] });

        truffleAssert.eventEmitted(dispatchToGoodsDistributor, "wineDispatched");

        let dispatchDateResult = await productInstance.getCurrentLocation(1);
        let dispatchDate = dispatchDateResult[1];

        await assert.equal(
            web3.utils.keccak256(dispatchDate),
            web3.utils.keccak256("18/4/2023"),
            "Failed to dispatch wine to goods distributor - dispatch date is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentOwner(1),
            accounts[6],
            "Failed to dispatch wine to goods distributor - owner address is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentContractAddress(1),
            goodsDistributorInstance.address,
            "Failed to dispatch wine to goods distributor - contract address is not the same"
        );

    });

    it('Goods distributor received the wine', async () => {
        let gdReceive = await goodsDistributorInstance.receiveWine(1, "Storage warehouse", "19/4/2023", { from: accounts[6] })

        truffleAssert.eventEmitted(gdReceive, "wineBatchReceived");

        let locationResult = await productInstance.getCurrentLocation(1);
        let location = locationResult[0];

        await assert.strictEqual(
            web3.utils.keccak256(location),
            web3.utils.keccak256("Storage warehouse"),
            "Failed to receive wine from filler packer - current location is not the same"
        );

        let arrivalDate = locationResult[2];

        console.log(arrivalDate);

        await assert.equal(
            web3.utils.keccak256(arrivalDate),
            web3.utils.keccak256("19/4/2023"),
            "Failed to receive wine from filler packer - arrival date is not the same"
        );

        assert.strictEqual(
            await productInstance.getReceived(1), 
            true, 
            "Failed to receive wine from filler packer");   

        let productIds = [1]
            
        assert.deepEqual(productIds.map(p => Number(p)), 
            (await goodsDistributorInstance.getWineBatchStorage()).map(p => Number(p)));

    });

    it('Wine ready to ship in Goods Distributor contract', async () => {
        let gdrts = await goodsDistributorInstance.materialReadyToShip(1, {from: accounts[6]});

        truffleAssert.eventEmitted(gdrts, "readyToShip");

        assert.strictEqual(
            await productInstance.getReadyToShip(1, {from: accounts[6]}), 
            true, 
            "Failed to set wine ready for shipping");
    });
    
    it('Wholesaler buy wine from goods distributor', async () => {

        let ownerBalanceBefore = web3.utils.toBN(await web3.eth.getBalance(accounts[6]));
        let buyFromgd = await wholesalerInstance.buyWineFromGoodsDistributor(1, {from: accounts[7], value: 21});

        truffleAssert.eventEmitted(buyFromgd, "buyWine");

        let ownerBalanceAfter = web3.utils.toBN(await web3.eth.getBalance(accounts[6]));

        assert(ownerBalanceAfter.sub(ownerBalanceBefore).eq(web3.utils.toBN(20)), "Owner did not receive the correct amount");
    });

    it('Dispatch wine to wholesaler', async () => {
        
        let dispatchToWholesaler = await goodsDistributorInstance.dispatchWineToWholesaler(1, "21/4/2023", accounts[7], wholesalerInstance.address, { from: accounts[6] });

        truffleAssert.eventEmitted(dispatchToWholesaler, "dispatchWineBatch");

        let dispatchDateResult = await productInstance.getCurrentLocation(1);
        let dispatchDate = dispatchDateResult[1];

        await assert.equal(
            web3.utils.keccak256(dispatchDate),
            web3.utils.keccak256("21/4/2023"),
            "Failed to dispatch wine to wholesaler - dispatch date is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentOwner(1),
            accounts[7],
            "Failed to dispatch wine to wholesaler - owner address is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentContractAddress(1),
            wholesalerInstance.address,
            "Failed to dispatch wine to wholesaler - contract address is not the same"
        );

        let wineBatchStorage = await goodsDistributorInstance.getWineBatchStorage();

        assert.equal(wineBatchStorage.length, 0, "wineBatchStorage should be empty");
    });

    it('Wholesaler received the wine', async () => {
        let wsReceive = await wholesalerInstance.receiveWine(1, "Wholesaler", "22/4/2023", { from: accounts[7] })

        truffleAssert.eventEmitted(wsReceive, "wineReceived");

        let locationResult = await productInstance.getCurrentLocation(1);
        let location = locationResult[0];

        await assert.strictEqual(
            web3.utils.keccak256(location),
            web3.utils.keccak256("Wholesaler"),
            "Failed to receive wine from goods distributor - current location is not the same"
        );

        let arrivalDate = locationResult[2];

        console.log(arrivalDate);

        await assert.equal(
            web3.utils.keccak256(arrivalDate),
            web3.utils.keccak256("22/4/2023"),
            "Failed to receive wine from goods distributor - arrival date is not the same"
        );
    });

    it('Wine ready to ship in Wholesaler contract', async () => {
        let wsrts = await wholesalerInstance.materialReadyToShip(1, {from: accounts[7]});

        truffleAssert.eventEmitted(wsrts, "readyToShip");

        assert.strictEqual(
            await productInstance.getReadyToShip(1, {from: accounts[7]}), 
            true, 
            "Failed to set wine ready for shipping");
    });

    it('Retailer buy wine from wholesaler', async () => {

        let ownerBalanceBefore = web3.utils.toBN(await web3.eth.getBalance(accounts[7]));
        let buyFromws = await retailerInstance.buyWineFromWholesaler(1, {from: accounts[8], value: 21});

        truffleAssert.eventEmitted(buyFromws, "buyWineBatch");

        let ownerBalanceAfter = web3.utils.toBN(await web3.eth.getBalance(accounts[7]));

        assert(ownerBalanceAfter.sub(ownerBalanceBefore).eq(web3.utils.toBN(20)), "Owner did not receive the correct amount");
    });

    it('Dispatch wine to retailer', async () => {
        
        let dispatchToRetailer = await wholesalerInstance.dispatchWineToRetailer(1, "23/4/2023", accounts[8], retailerInstance.address, { from: accounts[7] });

        truffleAssert.eventEmitted(dispatchToRetailer, "dispatchWine");

        let dispatchDateResult = await productInstance.getCurrentLocation(1);
        let dispatchDate = dispatchDateResult[1];

        await assert.equal(
            web3.utils.keccak256(dispatchDate),
            web3.utils.keccak256("23/4/2023"),
            "Failed to dispatch wine to retailer - dispatch date is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentOwner(1),
            accounts[8],
            "Failed to dispatch wine to retailer - owner address is not the same"
        );

        await assert.equal(
            await productInstance.getCurrentContractAddress(1),
            retailerInstance.address,
            "Failed to dispatch wine to retailer - contract address is not the same"
        );
    });

    it('Retailer received the wine', async () => {
        let rtReceive = await retailerInstance.receiveWine(1, "Wine connection", "24/4/2023", { from: accounts[8] })

        truffleAssert.eventEmitted(rtReceive, "wineBatchReceived");

        let locationResult = await productInstance.getCurrentLocation(1);
        let location = locationResult[0];

        await assert.strictEqual(
            web3.utils.keccak256(location),
            web3.utils.keccak256("Wine connection"),
            "Failed to receive wine from retailer - current location is not the same"
        );

        let arrivalDate = locationResult[2];

        console.log(arrivalDate);

        await assert.equal(
            web3.utils.keccak256(arrivalDate),
            web3.utils.keccak256("24/4/2023"),
            "Failed to receive wine from retailer - arrival date is not the same"
        );

        await assert 
        await retailerInstance.getWineRemaining(1)


        await assert.strictEqual(
            Number(await retailerInstance.getWineRemaining(1)),         
            10,
            "Failed to receieve wine - batch quantity is not the same"
        )
    });

    it('Retailer sell wine', async () => {

        let sellWine = await retailerInstance.sellWine(1, 3);

        truffleAssert.eventEmitted(sellWine, "soldWine");

        await assert.strictEqual(
            Number(await retailerInstance.getWineRemaining(1)),         
            7,
            "Failed to sell wine - wine remaining in batch is not the same"
        )

//     });

// })