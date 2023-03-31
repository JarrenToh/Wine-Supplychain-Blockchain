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

    // function buy(
    //     uint256 productId,
    //     string memory disbatchDate
    // ) public payable returns(uint256) {
    //     uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
    //     require(msg.value > productPrice, "Insufficent balance to buy the supply");
    //     // address payable targetAddress = payable(productContract.getCurrentOwner(productId));
    //     // targetAddress.transfer(productPrice);

    //     rawMaterialSupplierContract.disbatchRawMaterial(
    //         productId, 
    //         disbatchDate, 
    //         msg.sender
    //     );
    // }

    function received(
        uint256 productId,
        string memory currentLocation,
        string memory arrivalDate
    ) public {
        productContract.setReceived(productId, true);
        (string memory location, string memory disbatchDate, string memory prevArrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, disbatchDate, prevArrivalDate);
        productContract.setCurrentLocation(productId, currentLocation, disbatchDate, arrivalDate);
    }


    function wineReadyToShip(uint256 productId, string memory newLocation) public {
        require(productContract.getReadyToShip(productId) == false, "Product is already ready for shipping");
        // require(productContract.getProductName(productId) == "Wine", "You can only ship wine products");
        productContract.setReadyToShip(productId, true);
        (string memory location, string memory disbatchDate, string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, disbatchDate, arrivalDate);
        productContract.setCurrentLocation(productId, newLocation, "null", "null");
    }

    // function processWine(
    //     uint256[] memory productIds,
    //     string memory placeOfOrigin,
    //     string memory productionDate,
    //     string memory expirationDate, 
    //     uint256 unitQuantity, 
    //     string memory unitQuantityType, 
    //     uint256 batchQuantity, 
    //     uint256 unitPrice, 
    //     string memory category, 
    //     string memory currentPhysicalLocation
    //     ) public returns (uint256) {


    //     bool allAvailableToUse = true;
    //     for (uint256 i = 0; i < productIds.length; i++) {
    //         if (productContract.getUsed((productIds[i])) == true) {
    //             allAvailableToUse == false;
    //             break;
    //         }
    //     }

    //     require(allAvailableToUse == true, "You Do Not Have Sufficient Products To Process Wine");

    //     //CreateWine and add all the materials Inside

    //     uint256 wineProductId = productContract.createProduct(
    //         "Wine", 
    //         address(this),
    //         placeOfOrigin, 
    //         productionDate, 
    //         expirationDate, 
    //         unitQuantity, 
    //         unitQuantityType, 
    //         batchQuantity, 
    //         unitPrice, 
    //         category, 
    //         currentPhysicalLocation
    //         );

    //     for (uint256 i = 0; i < productIds.length; i++) {
    //         productContract.addComponentProduct(wineProductId, productIds[i]);
    //     }
    

    //     //Use up all the materials, remove them from the product contract as well as materialsOwned array
    //     for (uint256 i = 0; i < productIds.length; i++) {
    //         productContract.setUsed(productIds[i], true);
    //     }

    //     return wineProductId;
    //     }

    // function disbatchWineToBulkDistributor(uint256 productId, string memory newDisbatchDate, address bulkDistributorAddress) public {
    //     require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
    //     // require(keccak256(productContract.getProductName(productId)) == keccak256("Wine"), "You can only ship wine products");

    //     productContract.setCurrentOwner(productId, bulkDistributorAddress);
    //     productContract.setPreviousOwner(productId, address(this));
    //     (string memory location, string memory disbatchDate, string memory arrivalDate) = productContract.getCurrentLocation(productId);
    //     productContract.addPreviousLocation(productId, location, disbatchDate, arrivalDate);
    //     productContract.setCurrentLocation(productId, location, newDisbatchDate, "null");
    // }
}
















































































    