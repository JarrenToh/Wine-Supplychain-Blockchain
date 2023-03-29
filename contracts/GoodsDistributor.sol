pragma solidity ^0.5.0;

import "./Product.sol";

contract GoodsDistributor {
    event recievedWineBatch(uint256 wineBatchId, address goodsDistributor);
    event sentWineBatch(uint256 wineBatchId, address wholeSaler);
    event changeLabel(uint256 wineBatchId, string newLabel, address goodsDistributor);
    event addedGoodsDistributor(uint256 distributorId);
    event removedGoodsDistributor(uint256 distributorId);

    Product productContract;
    uint256 public numOfGoodsDistributor = 0;
    mapping(uint256 => address) public goodsDistributors; //mapping the id of the goods distributors to their addresses
    mapping(uint256 => string) public wineBatchLabel;
    mapping(uint256 => uint256) public wineBatchRecieve; //mapping the id of the wine batch recieved and the id of the goods distributor recieving the wine batch
    mapping(uint256 => uint256) public wineBatchSent; //mapping the id of the wine batch sent and the id of the goods distributor sending the wine batch
    mapping(uint256 => address) public wineBatchRelabel; //mapping the id of the wine batch and the address of the goods distributor who relabeled the wine batch
    uint256[] public wineBatchStorage;

    //function to add a new goods distributor
    function addGoodsDistributor(
        address accountNumber
    ) public returns (uint256) {
        require(
            checkGoodsDistributorExist(accountNumber) == false,
            "Goods distributor already exist!"
        );
        goodsDistributors[numOfGoodsDistributor] = accountNumber;
        emit addedGoodsDistributor(numOfGoodsDistributor);
        numOfGoodsDistributor += 1;
    }

    //check whether goods distributor already exist. Returns true if exist and false otherwise
    function checkGoodsDistributorExist(
        address accountNumber
    ) public view returns (bool) {
        if (numOfGoodsDistributor > 0) {
            for (uint i = 0; i <= numOfGoodsDistributor; i++) {
                if (goodsDistributors[i] == accountNumber) {
                    return true;
                }
            }
        }
        return false;
    }

    function removeGoodsDistributor(
        address accountNumber
    ) public returns (bool) {
        require(
            checkGoodsDistributorExist(accountNumber) == true,
            "Goods distributor does not exist!"
        );
        uint256 removedId = 0;
        for (uint i = 0; i <= numOfGoodsDistributor; i++) {
            if (goodsDistributors[i] == accountNumber) {
                goodsDistributors[i] = address(0);
                removedId = i;
                break;
            }
        }  
        emit removedGoodsDistributor(removedId);
    }

    function isGoodsDistributor(address accountNumber) public view returns (bool) {
        bool exist = checkGoodsDistributorExist(accountNumber);
        if (exist) {
            return true;
        } else {
            return false;
        }
    }

    function relabelWineBatch(uint256 wineBatchId, string memory newLabel, address accountNumber) public {
        require(isGoodsDistributor(accountNumber) == true, "Requires goods distributor to relabel wine batch!");
        wineBatchLabel[wineBatchId] = newLabel;
        wineBatchRelabel[wineBatchId] = accountNumber;
        emit changeLabel(wineBatchId, newLabel, accountNumber);
    }

    function recieveWineBatchFromFiller(uint256 wineBatchId) public payable { 
       // require(msg.value == productContract.getUnitPrice(), "Insufficient payment!");
       productContract.setCurrentLocation(wineBatchId, "Goods Distributor", "Today");
       productContract.addPreviousLocation(wineBatchId, "Filler Packer", "Today");
       productContract.setReceived(wineBatchId, true);  
    }
}
