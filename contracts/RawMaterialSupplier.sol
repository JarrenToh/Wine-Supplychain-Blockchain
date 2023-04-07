pragma solidity ^0.5.0;

import "./Product.sol";

contract RawMaterialSupplier {
    Product productContract;
    address rawMaterialSupplierContractOwner = msg.sender;
    constructor(Product productContractddress) public {
        productContract = productContractddress;
    }

    //events
    event rawMaterialAdded(uint productId);
    event rawMaterialRemoved(uint productId);
    event rawMaterialReadyToShip(uint productId);
    event rawMaterialDisbatched(uint productId);
    event returnedRawMaterial(uint productId);
    

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

        emit rawMaterialAdded(productId);
        return productId;
    }


    function returnRawMaterials(uint256 productId) public payable ownerOnly(productId) {

        require(productContract.getReceived(productId) == true, "Product is not yet received for return");
        require(productContract.getPreviousOwner(productId) == msg.sender, "Unable to refund items");

        //Transfer back the amt
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value >= productPrice, "Insufficent amount for refund");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setCurrentOwner(productId, msg.sender);
        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, productContract.getPreviousContractAddress(productId));

        emit returnedRawMaterial(productId);
    }


    function removeRawMaterial(uint256 productId) public ownerOnly(productId) {
        productContract.removeProduct(productId);

        emit rawMaterialRemoved(productId);
    }
    

    function materialReadyToShip(uint256 productId) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == false, "Product is already ready for shipping");
        productContract.setReadyToShip(productId, true);
        emit rawMaterialReadyToShip(productId);
    }

    function disbatchRawMaterial(uint256 productId, string memory newDisbatchDate, address wineProducerAddress, address wineProducerContractAddress) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setCurrentOwner(productId, wineProducerAddress);
        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, wineProducerContractAddress);
        (string memory location, , string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.setCurrentLocation(productId, location, newDisbatchDate, arrivalDate);
        emit rawMaterialDisbatched(productId);
    }    
}