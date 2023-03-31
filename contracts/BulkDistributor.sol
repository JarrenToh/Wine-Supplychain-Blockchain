pragma solidity ^0.5.0;

import "./Product.sol";
import "./WineProducer.sol";

contract BulkDistributor {

    //variables
    Product productContract;
    WineProducer wineProducerContract;
    address owner = msg.sender;

    constructor(Product productAddress, WineProducer wineProducerAddress) public {
        productContract = productAddress;
        wineProducerContract = wineProducerAddress;
    }

    //events
    event buyWine(uint productId);
    event wineReceived(uint productId);
    event dispatchWine(uint productId);

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }


    //buy
    // function buyWineFromWineProducer(uint256 productId, string memory dispatchDate) public payable {
    //     uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
    //     require(msg.value > productPrice, "Insufficent amount to buy the wine");
    //     address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
    //     targetAddress.transfer(productPrice);

    //     wineProducerContract.disbatchWineToBulkDistributor(produceId, dispatchDate, msg.sender, address(this));
    // buyWine(productId);

    // }

    //Receive From Wine Producer
    function receiveWine(
        uint256 productId,
        string memory currentLocation,
        string memory arrivalDate
    ) public ownerOnly(productId) {
        require(productContract.getReceived(productId) == false);
        require(productContract.getCurrentContractAddress(productId) == address(this));
        require(productContract.getReadyToShip(productId) == true);
        (string memory location, string memory dispatchDate, string memory prevArrivalDate) = productContract.getCurrentLocation(productId);
        productContract.addPreviousLocation(productId, location, dispatchDate, prevArrivalDate);
        productContract.setCurrentLocation(productId, currentLocation, "", arrivalDate);

        productContract.setReceived(productId, true);
        productContract.setReadyToShip(productId, false);

        emit wineReceived(productId);
    }

    //dispatch to Transit Cellar
    function disbatchWineToTransitCellar(uint256 productId, string memory newDisbatchDate, address transitCellarAddress, address transitCellarContractAddress) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
        require(productContract.getCurrentContractAddress(productId) == address(this));

        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setCurrentOwner(productId, transitCellarAddress);

        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId,transitCellarContractAddress);

        (string memory location, ,string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.setCurrentLocation(productId, location, newDisbatchDate, arrivalDate);
        
        emit dispatchWine(productId);
    }
}
