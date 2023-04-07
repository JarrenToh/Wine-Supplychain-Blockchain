pragma solidity ^0.5.0;

import "./Product.sol";
import "./GoodsDistributor.sol";

contract Wholesaler {

    //variables
    Product productContract;
    GoodsDistributor goodsDistributorContract;
    address owner = msg.sender;

    constructor(Product productAddress, GoodsDistributor goodsDistributorAddress) public {
        productContract = productAddress;
        goodsDistributorContract = goodsDistributorAddress;
    }

    //events
    event buyWine(uint productId);
    event wineReceived(uint productId);
    event dispatchWine(uint productId);
    event readyToShip(uint productId);
    event returnedWine(uint productId);
    event wineRemoved(uint productId);
    
    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }


    //buy
    function buyWineFromGoodsDistributor(uint256 productId, string memory dispatchDate) public payable {
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value > productPrice, "Insufficent amount to buy the wine");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        goodsDistributorContract.disbatchWineToWholesaler(productId, dispatchDate, msg.sender, address(this));
        emit buyWine(productId);

    }

    function removeWine(uint256 productId) public ownerOnly(productId) {
        productContract.removeProduct(productId);
        emit wineRemoved(productId);
    }

    function materialReadyToShip(uint256 productId) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == false, "Product is already ready for shipping");
        productContract.setReadyToShip(productId, true);

        emit readyToShip(productId);
    }

    //Receive From Filler/Packer
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

    function returnWine(uint256 productId) public payable {

        require(productContract.getReceived(productId) == true, "Wine is not yet received for return");
        require(productContract.getPreviousOwner(productId) == msg.sender, "Unable to refund items");

        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value >= productPrice, "Insufficent amount for refund");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setCurrentOwner(productId, msg.sender);
        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, productContract.getPreviousContractAddress(productId));

        emit returnedWine(productId);
    }

    //Dispatch to Retailer
    function disbatchWineToRetailer(uint256 productId, string memory newDisbatchDate, address retailerAddress, address retailerContractAddress) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
        require(productContract.getCurrentContractAddress(productId) == address(this));

        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setCurrentOwner(productId, retailerAddress);

        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId,retailerContractAddress);

        (string memory location, ,string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.setCurrentLocation(productId, location, newDisbatchDate, arrivalDate);

        productContract.setReceived(productId, false);

        emit dispatchWine(productId);
    }
    
}