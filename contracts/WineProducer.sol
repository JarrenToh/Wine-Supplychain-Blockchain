pragma solidity ^0.5.0;

import "./Product.sol";
import "./RawMaterialSupplier.sol";

contract WineProducer {
    Product productContract;
    RawMaterialSupplier rawMaterialSupplierContract;
    address wineProducerAddress = msg.sender;
    constructor(Product productContractddress, RawMaterialSupplier supplierContractAddress) public {
        productContract = productContractddress;
        rawMaterialSupplierContract = supplierContractAddress;
    }

    //events
    event buyRawMaterial(uint productId);
    event processedWine(uint productId);
    event wineRemoved(uint productId);
    event returnedRawMaterial(uint productId);
    event refundWine(uint productId);
    event WineReadyToShip(uint productId);
    event WineDispatched(uint productId);
    event rawMaterialReceived(uint productId);

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }


    function buy(
        uint256 productId
    ) public payable returns(uint256) {

        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value > productPrice, "Insufficent balance to buy the supply");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        emit buyRawMaterial(productId);
    }

    function received(
        uint256 productId,
        string memory currentLocation,
        string memory arrivalDate
    ) public ownerOnly(productId) {
        productContract.setReceived(productId, true);
        (string memory location, string memory disbatchDate, string memory prevArrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, disbatchDate, prevArrivalDate);
        productContract.setCurrentLocation(productId, currentLocation, "", arrivalDate);
        emit rawMaterialReceived(productId);
    }


    function removeWine(uint256 productId) public ownerOnly(productId) {
        productContract.removeProduct(productId);
        emit wineRemoved(productId);
    }
    
    //Setting of location is unncessary because the returned products would not be of used anymore in the supplychain.
    function returnRawMaterials(uint256 productId) public ownerOnly(productId) {

        require(productContract.getReceived(productId) == true, "Product is not yet received for return");

        address prevOwner = productContract.getPreviousOwner(productId);
        address prevContractAddress = productContract.getPreviousContractAddress(productId);

        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, prevContractAddress);
        productContract.setCurrentOwner(productId, prevOwner);

        emit returnedRawMaterial(productId);
    }

    function refundBulkDistributor(uint256 productId) public payable ownerOnly(productId) {

        require(productContract.getCurrentOwner(productId) == msg.sender, "Unable to refund items");

        //Transfer back the amt
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value >= productPrice, "Insufficent amount for refund");
        address payable targetAddress = address(uint160(productContract.getPreviousOwner(productId)));
        targetAddress.transfer(productPrice);

        emit refundWine(productId);
    }


    function wineReadyToShip(uint256 productId) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == false, "Product is already ready for shipping");

        productContract.setReadyToShip(productId, true);
    
        emit WineReadyToShip(productId);
    }

    function processWine(
        uint256[] memory productIds,
        string memory placeOfOrigin,
        string memory productionDate,
        string memory expirationDate, 
        uint256 unitQuantity, 
        string memory unitQuantityType, 
        uint256 batchQuantity, 
        uint256 unitPrice, 
        string memory category, 
        string memory currentPhysicalLocation

        ) public returns (uint256) {


        bool allAvailableToUse = true;
        for (uint256 i = 0; i < productIds.length; i++) {
            if (productContract.getUsed((productIds[i])) == true) {
                allAvailableToUse = false;
                break;
            }
        }

        require(allAvailableToUse == true, "You Do Not Have Sufficient Products To Process Wine");

        //CreateWine and add all the materials Inside

        uint256 wineProductId = productContract.createProduct(
            "Wine", 
            address(this),
            unitQuantity, 
            unitQuantityType, 
            batchQuantity, 
            unitPrice, 
            category,
            address(msg.sender)
            );

        productContract.setPlaceOfOrigin(wineProductId, placeOfOrigin);
        productContract.setProductionDate(wineProductId, productionDate);
        productContract.setExpirationDate(wineProductId, expirationDate);
        productContract.setCurrentLocation(wineProductId, currentPhysicalLocation, "", "");

        for (uint256 i = 0; i < productIds.length; i++) {
            uint256 productId = productIds[i];
            productContract.addComponentProduct(wineProductId, productId);
        }

        //Use up all the materials
        for (uint256 i = 0; i < productIds.length; i++) {
            productContract.setUsed(productIds[i], true);
        }
        emit processedWine(wineProductId);
        return wineProductId;
    }

    function dispatchWineToBulkDistributor(uint256 productId, string memory newDisbatchDate, address bulkDistributorAddress, address bulkDistributorContractAddress) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
        require(keccak256(abi.encodePacked(productContract.getProductName(productId))) == keccak256(abi.encodePacked("Wine")), "You can only ship wine products");
        
        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, bulkDistributorContractAddress);
        (string memory location, , string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.setCurrentLocation(productId, location, newDisbatchDate, arrivalDate);
        productContract.setReceived(productId, false);
        productContract.setCurrentOwner(productId, bulkDistributorAddress);
        emit WineDisbatched(productId);
    }
}