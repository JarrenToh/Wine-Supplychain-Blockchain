pragma solidity ^0.5.0;

import "./Product.sol";

contract Retailer {

    event soldWine(uint256 wineBatchId, address retailer);
    event addedRetailer(uint256 retailerId);
    event removedRetailer(uint256 retailerId);
    event receivedWineBatch(uint256 wineBatchId, address retailer);

    Product productContract;
    uint256 public numOfRetailers = 0;
    mapping(uint256 => uint256) public wineRemainingInBatch;
    mapping(uint256 => address) public retailers; //mapping id of retailers to their addresses

    //function to add a new retailer
    function addRetailer(
        address accountNumber
    ) public returns (uint256) {
        require(
            checkRetailerExist(accountNumber) == false,
            "Retailer already exist!"
        );
        retailers[numOfRetailers] = accountNumber;
        emit addedRetailer(numOfRetailers);
        numOfRetailers += 1;
    }

    //check whether goods distributor already exist. Returns true if exist and false otherwise
    function checkRetailerExist(
        address accountNumber
    ) public view returns (bool) {
        if (numOfRetailers > 0) {
            for (uint i = 0; i <= numOfRetailers; i++) {
                if (retailers[i] == accountNumber) {
                    return true;
                }
            }
        }
        return false;
    }

    function removeRetailer(
        address accountNumber
    ) public returns (bool) {
        require(
            checkRetailerExist(accountNumber) == true,
            "Retailer does not exist!"
        );
        uint256 removedId = 0;
        for (uint i = 0; i <= numOfRetailers; i++) {
            if (retailers[i] == accountNumber) {
                retailers[i] = address(0);
                removedId = i;
                break;
            }
        }
        emit removedRetailer(removedId);
    }

    function isGoodsDistributor(
        address accountNumber
    ) public view returns (bool) {
        bool exist = checkRetailerExist(accountNumber);
        if (exist) {
            return true;
        } else {
            return false;
        }
    }

    // function receiveWineBatchFromWholeSaler(
    //     uint256 wineBatchId,
    //     address retailer,
    //     string memory newLocation,
    //     string memory newDisbatchDate,
    //     string memory newExpectedArrivalDate,
    //     string memory newArrivalDate,
    //     string memory prevLocation, 
    //     string memory prevDisbatchDate, 
    //     string memory prevExpectedArrivalDate, 
    //     string memory prevArrivalDate
    // ) public payable {
    //     require(
    //         msg.value == productContract.getUnitPrice(wineBatchId),
    //         "Insufficient payment!"
    //     );
    //     //fillerPackerContract.sendWineToGoodsDistributor(wineBatchId);
    //     productContract.setCurrentLocation(
    //         wineBatchId,
    //         newLocation,
    //         newDisbatchDate,
    //         newExpectedArrivalDate,
    //         newArrivalDate
    //     );
    //     productContract.addPreviousLocation(
    //         wineBatchId,
    //         prevLocation,
    //         prevDisbatchDate,
    //         prevExpectedArrivalDate,
    //         prevArrivalDate
    //     );
    //     productContract.setCurrentContractAddress(wineBatchId, address(this));
    //     productContract.setReceived(wineBatchId, true);
    //     wineRemainingInBatch[wineBatchId] = productContract.getBatchQuantity(wineBatchId);
    //     emit receivedWineBatch(wineBatchId, retailer);
    // }

    function sellWineFromBatch(uint256 wineBatchId, address retailer) public {
        wineRemainingInBatch[wineBatchId] = wineRemainingInBatch[wineBatchId] - 1;
        emit soldWine(wineBatchId, retailer);
    }
}