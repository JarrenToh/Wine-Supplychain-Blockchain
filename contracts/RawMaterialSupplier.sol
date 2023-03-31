pragma solidity ^0.5.0;

import "./Product.sol";

contract RawMaterialSupplier {
    Product productContract;
    address rawMaterialSupplierContractOwner = msg.sender;
    uint256[] rawMaterialsOwned;
    constructor(Product productContractddress) public {
        productContract = productContractddress;
    }

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }



    function addRawMaterial(
        string memory name,
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


        uint256 productId = productContract.createProduct(
            name,
            address(this),
            unitQuantity, 
            unitQuantityType, 
            batchQuantity, 
            unitPrice, 
            category
        );
        productContract.setPlaceOfOrigin(productId, placeOfOrigin);
        productContract.setProductionDate(productId, productionDate);
        productContract.setBatchQuantity(productId, batchQuantity);
        productContract.setExpirationDate(productId, expirationDate);
        productContract.setCurrentLocation(productId, currentPhysicalLocation, "", "");


        rawMaterialsOwned.push(productId);
        return productId;
    }


    function removeRawMaterial(uint256 productId) public ownerOnly(productId) {
        productContract.removeProduct(productId);
        for (uint256 i = 0; i < rawMaterialsOwned.length; i++) {
            if (rawMaterialsOwned[i] == productId) {
                delete rawMaterialsOwned[i];
                break;
            }
        }
    }
    

    function materialReadyToShip(uint256 productId, string memory newLocation) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == false, "Product is already ready for shipping");
        productContract.setReadyToShip(productId, true);
        (string memory location, string memory disbatchDate, string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, disbatchDate, arrivalDate);
        productContract.setCurrentLocation(productId, newLocation, "", "");
    }

    function disbatchRawMaterial(uint256 productId, string memory newDisbatchDate, address wineProducerAddress, address wineProducerContractAddress) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setCurrentOwner(productId, wineProducerAddress);
        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, wineProducerContractAddress);
        (string memory location, , string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.setCurrentLocation(productId, location, newDisbatchDate, arrivalDate);
    }    
}