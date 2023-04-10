pragma solidity ^0.5.0;

import "./Product.sol";
import "./WholeSaler.sol";

contract Retailer {

    Product productContract;
    Wholesaler wholeSalerContract;

    event soldWine(uint256 wineBatchId);
    event buyWineBatch(uint256 wineBatchId);
    event wineBatchReceived(uint256 wineBatchId);
    event returnedWine(uint256 wineBatchId);
    event wineBatchRemoved(uint256 wineBatchId);

    mapping(uint256 => uint256) private wineRemainingInBatch;

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }

    constructor(Product productAddress, Wholesaler wholeSalerAddress) public {
        productContract = productAddress;
        wholeSalerContract = wholeSalerAddress;
    }

    function getWineRemaining(uint256 productId) public view returns(uint256) {
       return wineRemainingInBatch[productId];
    }

    //buy wine batch from wholesaler
    function buyWineFromWholesaler(uint256 productId) public payable {
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value > productPrice, "Insufficent amount to buy the wine batch");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        //wholeSalerContract.dispatchWineToRetailer(productId, dispatchDate, msg.sender, address(this));
        emit buyWineBatch(productId);
    }

    //Receive From fillerpacker
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

        wineRemainingInBatch[productId] = productContract.getBatchQuantity(productId);

        emit wineBatchReceived(productId);
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

    function sellWine(uint256 productId, uint256 quantity) public {
        wineRemainingInBatch[productId] -= quantity;
        emit soldWine(productId);
    }

    function removeWineBatch(uint256 productId) public ownerOnly(productId) {
        productContract.removeProduct(productId);
        emit wineBatchRemoved(productId);
    }

}