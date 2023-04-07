pragma solidity ^0.5.0;

import "./Product.sol";
import "./WholeSaler.sol";

contract Retailer {

    Product productContract;
    Wholesaler wholeSalerContract;

    event soldWine(uint256 wineBatchId);
    event buyWineBatch(uint256 wineBatchId);
    event wineBatchReceived(uint256 wineBatchId);
    event wineBatchRemoved(uint256 wineBatchId);
    event returnedWineBatch(uint256 wineBatchId);

    mapping(uint256 => uint256) public wineRemainingInBatch;

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }

    constructor(Product productAddress, Wholesaler wholeSalerAddress) public {
        productContract = productAddress;
        wholeSalerContract = wholeSalerAddress;
    }

    //buy wine batch from wholesaler
    function buyWineFromWholesaler(uint256 productId, string memory dispatchDate) public payable {
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value > productPrice, "Insufficent amount to buy the wine batch");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        wholeSalerContract.disbatchWineToRetailer(productId, dispatchDate, msg.sender, address(this));
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

        emit wineBatchReceived(productId);
    }

    function sellWine(uint256 productId, uint256 quantity) public {
        wineRemainingInBatch[productId] -= quantity;
    }

    function removeWineBatch(uint256 productId) public ownerOnly(productId) {
        productContract.removeProduct(productId);
        emit wineBatchRemoved(productId);
    }

    function returnWineBatch(uint256 productId) public ownerOnly(productId) {
        require(productContract.getReceived(productId) == true, "Product is not yet received for return");
        productContract.setPreviousOwner(productId, msg.sender);
        productContract.setCurrentOwner(productId, productContract.getPreviousOwner(productId));
        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, productContract.getPreviousContractAddress(productId));

        emit returnedWineBatch(productId);
    }

}