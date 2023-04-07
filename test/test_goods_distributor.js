const _deploy_contracts = require("../migrations/2_deploy_contracts");
const truffleAssert = require('truffle-assertions');
var assert = require('assert');

var GoodsDistributor = artifacts.require("../contracts/GoodsDistributor.sol");
var FillerPacker = artifacts.require("../contracts/FillerPacker.sol");
var Product = artifacts.require("../contracts/Product.sol");

contract('GoodsDistributor', function(accounts) {

    before(async () => {
        productInstance = await Product.deployed();
        fillerPackerInstance = await FillerPacker.deployed();
        goodsDistributorInstance = await GoodsDistributor.deployed();
    });
    console.log("Testing Goods Distributor Contract");

    //Test materialReadyToShip method
    it('Ready to ship', async () => {
        let productP1 = await productInstance        
    })
})

