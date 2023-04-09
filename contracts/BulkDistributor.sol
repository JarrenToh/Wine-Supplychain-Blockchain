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
    event readyToShip(uint productId);
    event returnedWine(uint productId);
    event refundWine(uint productId);
    event wineRemoved(uint productId);

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }


    //buy
    function buyWineFromWineProducer(uint256 productId) public payable {
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value > productPrice, "Insufficent amount to buy the wine");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        // wineProducerContract.dispatchWineToBulkDistributor(productId, dispatchDate, msg.sender, address(this));
        emit buyWine(productId);

    }

    function removeWine(uint256 productId) public ownerOnly(productId) {
        productContract.removeProduct(productId);
        emit wineRemoved(productId);
    }

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

    function returnWine(uint256 productId) public ownerOnly(productId) {

        require(productContract.getReceived(productId) == true, "Product is not yet received for return");

        address prevOwner = productContract.getPreviousOwner(productId);
        address prevContractAddress = productContract.getPreviousContractAddress(productId);

        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, prevContractAddress);
        productContract.setCurrentOwner(productId, prevOwner);

        emit returnedWine(productId);
    }

    function refundTransitCellar(uint256 productId) public payable ownerOnly(productId) {

        require(productContract.getCurrentOwner(productId) == msg.sender, "Unable to refund items");

        //Transfer back the amt
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value >= productPrice, "Insufficent amount for refund");
        address payable targetAddress = address(uint160(productContract.getPreviousOwner(productId)));
        targetAddress.transfer(productPrice);

        emit refundWine(productId);
    }

    function materialReadyToShip(uint256 productId) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == false, "Product is already ready for shipping");
        productContract.setReadyToShip(productId, true);

        emit readyToShip(productId);
    }

    //dispatch to Transit Cellar
    function dispatchWineToTransitCellar(uint256 productId, string memory newDisbatchDate, address transitCellarAddress, address transitCellarContractAddress) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
        require(productContract.getCurrentContractAddress(productId) == address(this));

        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setCurrentOwner(productId, transitCellarAddress);

        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId,transitCellarContractAddress);

        (string memory location, ,string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.setCurrentLocation(productId, location, newDisbatchDate, arrivalDate);

        productContract.setReceived(productId, false);
        
        emit dispatchWine(productId);
    }
}
