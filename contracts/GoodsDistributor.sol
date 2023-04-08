pragma solidity ^0.5.0;

import "./Product.sol";
import "./FillerPacker.sol";

contract GoodsDistributor {

    Product productContract;
    FillerPacker fillerPackerContract; 
    address owner = msg.sender;

    // events
    event buyWineBatch(uint wineBatchId);
    event wineBatchReceived(uint256 wineBatchId);
    event dispatchWineBatch(uint256 wineBatchId);
    event returnedWine(uint256 wineBatchId);
    event refundWine(uint256 wineBatchId);
    event wineBatchRemoved(uint256 wineBatchId);

    uint256[] public wineBatchStorage;

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(productContract.getCurrentOwner(productId) == msg.sender);
        _;
    }

    constructor(Product productAddress, FillerPacker fillerPackerAddress) public {
        productContract = productAddress;
        fillerPackerContract = fillerPackerAddress;
    }

    function removeWineBatchFromStorage(uint wineBatchId) public {
        if (wineBatchId >= wineBatchStorage.length) return;

        for (uint i = wineBatchId; i<wineBatchStorage.length-1; i++){
            wineBatchStorage[i] = wineBatchStorage[i+1];
        }
        wineBatchStorage.pop();
    }

    function materialReadyToShip(uint256 productId) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == false, "Product is already ready for shipping");
        productContract.setReadyToShip(productId, true);
    }

    //buy wine batch from fillerpacker
    function buyWineFromFillerPacker(uint256 productId, string memory dispatchDate) public payable {
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value > productPrice, "Insufficent amount to buy the wine batch");
        address payable targetAddress = address(uint160(productContract.getCurrentOwner(productId)));
        targetAddress.transfer(productPrice);

        fillerPackerContract.dispatchWineToGoodsDistributor(productId, dispatchDate, msg.sender, address(this));
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

        wineBatchStorage.push(productId);

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

    function refundWholesaler(uint256 productId) public payable ownerOnly(productId) {

        require(productContract.getCurrentOwner(productId) == msg.sender, "Unable to refund items");

        //Transfer back the amt
        uint256 productPrice = productContract.getUnitPrice(productId) * productContract.getBatchQuantity(productId);
        require(msg.value >= productPrice, "Insufficent amount for refund");
        address payable targetAddress = address(uint160(productContract.getPreviousOwner(productId)));
        targetAddress.transfer(productPrice);

        emit refundWine(productId);
    }

    //dispatch to wholesaler
    function dispatchWineToWholesaler(uint256 productId, string memory newDisbatchDate, address wholeSalerAddress, address wholeSalerContractAddress) public ownerOnly(productId) {
        require(productContract.getReadyToShip(productId) == true, "Product not ready for shipping");
        require(productContract.getCurrentContractAddress(productId) == address(this));

        productContract.setPreviousOwner(productId, productContract.getCurrentOwner(productId));
        productContract.setCurrentOwner(productId, wholeSalerAddress);

        productContract.setPreviousContractAddress(productId, productContract.getCurrentContractAddress(productId));
        productContract.setCurrentContractAddress(productId, wholeSalerContractAddress);
        
        productContract.setReceived(productId, false); //set received to false before sending

        (string memory location, ,string memory arrivalDate) = productContract.getCurrentLocation(productId);
        productContract.setCurrentLocation(productId, location, newDisbatchDate, arrivalDate);

        //remove wine batch with productId from storage
        for (uint i = 0; i <= wineBatchStorage.length - 1; i++) {
            if (wineBatchStorage[i] == productId) {
                removeWineBatchFromStorage(i);
                break;
            }
        }
       
        emit dispatchWineBatch(productId);
    }

    function removeWineBatch(uint256 productId) public ownerOnly(productId) {
        productContract.removeProduct(productId);
        for (uint256 i = 0; i <= wineBatchStorage.length - 1; i++) {
            if (wineBatchStorage[i] == productId) {
                removeWineBatchFromStorage(i);
                break;
            }
        }
        emit wineBatchRemoved(productId);
    }
<<<<<<< HEAD

    function returnWineBatch(uint256 productId) public payable ownerOnly(productId) {

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

        emit returnedWineBatch(productId);
    }


=======
>>>>>>> a260fd1a65918933d7fb36a4b1d97da085e98930
}
