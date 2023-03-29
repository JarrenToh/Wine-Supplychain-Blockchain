pragma solidity ^0.5.0;

contract Product {

    address contractOwner = msg.sender;
    //struct
    struct product {
        product[] componentProduct;
        uint256 productId;
        string name;
        address currentOwner;
        address currentContractAddress;
        address previousOwner;
        address previousContractAddress;
        string placeOfOrigin;
        string productionDate;
        string expirationDate;
        uint256 unitQuantity;
        string unitQuantityType;
        uint256 batchQuantity;
        uint256 unitPrice;
        string category;
        bool received;
<<<<<<< HEAD
        bool used;
=======
>>>>>>> 3b4b299659d91aa15d8648d3106190b8f50eb136
        productLocation[] previousLocation;
        productLocation currentLocation;
        bool readyToShip;
    }

    struct productLocation {
        string location;
        string disbatchDate;
<<<<<<< HEAD
=======
        string expectedArrivalDate;
>>>>>>> 3b4b299659d91aa15d8648d3106190b8f50eb136
        string arrivalDate;
    }

    //variables
    uint256 public noProduct = 0;
    mapping(uint256 => product) private products;

    //Events
    event ProductCreated(
        uint256 newProductId,
        string name,
        address currentContractAddress
    );

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(products[productId].currentOwner == msg.sender);
        _;
    }

    modifier validProductId(uint256 productId) {
        require(productId < noProduct);
        _;
    }

    //methods
    function createProduct(
        string memory name,
        address currentContractAddress,
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

        require(bytes(name).length > 0, "Name cannot be empty");

        //create new product
        product memory newProduct = product({
            componentProduct: new product[](0),
            productId: noProduct,
            name: name,
            currentOwner: msg.sender,
            currentContractAddress: currentContractAddress,
            previousOwner: address(0),
            previousContractAddress: address(0),
            placeOfOrigin: placeOfOrigin,
            productionDate: productionDate,
            expirationDate: expirationDate,
            unitQuantity: unitQuantity,
            unitQuantityType: unitQuantityType,
            batchQuantity: batchQuantity,
            unitPrice: unitPrice,
            category: category,
            received: false,
<<<<<<< HEAD
            used: false,
=======
>>>>>>> 3b4b299659d91aa15d8648d3106190b8f50eb136
            previousLocation: new productLocation[](0),
            currentLocation: productLocation({
                location: currentPhysicalLocation,
                disbatchDate: "null",
<<<<<<< HEAD
=======
                expectedArrivalDate: "null",
>>>>>>> 3b4b299659d91aa15d8648d3106190b8f50eb136
                arrivalDate: "null"
            }),
            readyToShip: false
        });

        uint256 newProductId = noProduct++;
        products[newProductId] = newProduct;
        emit ProductCreated(newProductId, name, msg.sender);
        return newProductId;
    }

    function addComponentProduct(uint256 mainProductId, uint256 productId) public ownerOnly(productId) validProductId(productId){
        products[mainProductId].componentProduct.push(products[productId]);
    }
    //transfer ownership when it moves from one entity to another entity in the supplychain
    function transferProduct(
        uint256 productId,
        address newOwner,
        address newContractAdddress
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].previousOwner = products[productId].currentOwner;
        products[productId].currentOwner = newOwner;

        products[productId].previousContractAddress = products[productId].currentContractAddress;
        products[productId].currentContractAddress = newContractAdddress;
    }
    

    // return value of product to the owner of the product
    function removeProduct(uint256 productId) public ownerOnly(productId) validProductId(productId) {
        // uint256 value = products[productId].creationValue;
        delete products[productId];
        // address payable targetAddress = msg.sender;
        // targetAddress.transfer(value);
    }


    function getProductName(uint256 productId) public view validProductId(productId) returns (string memory){
        return products[productId].name;
    }



    function getCurrentOwner(uint256 productId) public view validProductId(productId) returns (address){
        return products[productId].currentOwner;
    }

    function setCurrentOwner(uint256 productId, address newOwner) public ownerOnly(productId) validProductId(productId) {
        products[productId].currentOwner= newOwner;
    }

    function getCurrentContractAddress(uint256 productId) public view validProductId(productId) returns (address){
        return products[productId].currentContractAddress;
    }

    function setCurrentContractAddress(uint256 productId, address newContractAddress) public ownerOnly(productId) validProductId(productId) {
        products[productId].currentContractAddress = newContractAddress;
    }

    function getPreviousOwner(uint256 productId) public view validProductId(productId) returns (address) {
        return products[productId].previousOwner;
    }

    function setPreviousOwner(uint256 productId, address newPreviousOwner) public ownerOnly(productId) validProductId(productId) {
        products[productId].previousOwner = newPreviousOwner;
    }

    function getPreviousContractAddress(uint256 productId) public view validProductId(productId) returns (address) {
        return products[productId].previousContractAddress;
    }

    function setPreviousContractAddress(uint256 productId, address newPreviousContractAddress) public ownerOnly(productId) validProductId(productId) {
        products[productId].previousContractAddress = newPreviousContractAddress;
    }

    function getPlaceOfOrigin(uint256 productId) public view validProductId(productId) returns (string memory){
        return products[productId].placeOfOrigin;
    }

    function setPlaceOfOrigin(uint256 productId, string memory newPlaceOfOrigin) public ownerOnly(productId) validProductId(productId) {
        products[productId].placeOfOrigin = newPlaceOfOrigin;
    }
   
    function getProductionDate(uint256 productId) public view validProductId(productId) returns (string memory){
        return products[productId].productionDate;
    }

    function setProductionDate(uint256 productId, string memory newProductionDate) public ownerOnly(productId) validProductId(productId) {
        products[productId].productionDate = newProductionDate;
    }
    function getExpirationDate(uint256 productId) public view validProductId(productId) returns (string memory){
        return products[productId].expirationDate;
    }

    function setExpirationDate(uint256 productId, string memory newExpirationDate) public ownerOnly(productId) validProductId(productId) {
        products[productId].expirationDate = newExpirationDate;
    }

    function getUnitQuantity(uint256 productId) public view validProductId(productId) returns (uint256){
        return products[productId].unitQuantity;
    }

    function setUnitQuantity(uint256 productId, uint256 newUnitQuantity) public ownerOnly(productId) validProductId(productId) {
        products[productId].unitQuantity = newUnitQuantity;
    }

    function getUnitQuantityType(uint256 productId) public view validProductId(productId) returns (string memory){
        return products[productId].unitQuantityType;
    }

    function setUnitQuantityType(uint256 productId, string memory newUnitQuantityType) public ownerOnly(productId) validProductId(productId) {
        products[productId].unitQuantityType = newUnitQuantityType;
    }

    function getBatchQuantity(uint256 productId) public view validProductId(productId) returns (uint256){
        return products[productId].batchQuantity;
    }

    function setBatchQuantity(uint256 productId, uint256 newBatchQuantity) public ownerOnly(productId) validProductId(productId) {
        products[productId].batchQuantity = newBatchQuantity;
    }

    function getUnitPrice(uint256 productId) public view validProductId(productId) returns (uint256){
        return products[productId].unitPrice;
    }

    function setUnitPrice(uint256 productId, uint256 newUnitPrice) public ownerOnly(productId) validProductId(productId) {
        products[productId].unitPrice = newUnitPrice;
    }

    function getCategory(uint256 productId) public view validProductId(productId) returns (string memory){
        return products[productId].category;
    }

    function setCategory(uint256 productId, string memory newCategory) public ownerOnly(productId) validProductId(productId) {
        products[productId].category = newCategory;
    }

    function getReceived(uint256 productId) public view validProductId(productId) returns (bool){
        return products[productId].received;
    }

    function setReceived(uint256 productId, bool newReceived) public ownerOnly(productId) validProductId(productId) {
        products[productId].received = newReceived;
    }


    function getUsed(uint256 productId) public view validProductId(productId) returns (bool){
        return products[productId].used;
    }

    function setUsed(uint256 productId, bool used) public ownerOnly(productId) validProductId(productId) {
        products[productId].used = used;
    }



    // function getCreationValue(uint256 productId) public view validProductId(productId) returns (uint256){
    //     return products[productId].creationValue;
    // }

    // function setCreationValue(uint256 productId, uint256 newCreationValue) public ownerOnly(productId) validProductId(productId) {
    //     products[productId].creationValue = newCreationValue;
    // }

    function getPreviousLocation(uint256 productId, uint256 index) public view validProductId(productId) returns (string memory, string memory, string memory) {
        require(index < products[productId].previousLocation.length, "Invalid index");
        return (
            products[productId].previousLocation[index].location, 
            products[productId].previousLocation[index].disbatchDate, 
            products[productId].previousLocation[index].arrivalDate
            );
    }

    function addPreviousLocation(
        uint256 productId, 
    string memory prevLocation, 
    string memory prevDisbatchDate,  
    string memory prevArrivalDate
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].previousLocation.push(productLocation({
            location: prevLocation,
            disbatchDate: prevDisbatchDate,
            arrivalDate: prevArrivalDate
        }));
    }

    function getCurrentLocation(uint256 productId) public view validProductId(productId) returns (string memory, string memory, string memory) {
        return (
            products[productId].currentLocation.location, 
            products[productId].currentLocation.disbatchDate, 
            products[productId].currentLocation.arrivalDate
            );
    }

    function setCurrentLocation(uint256 productId, 
    string memory newLocation,
    string memory newDisbatchDate, 
    string memory newArrivalDate) public ownerOnly(productId) validProductId(productId) {
        products[productId].currentLocation = productLocation({
            location: newLocation,
            disbatchDate: newDisbatchDate,
            arrivalDate: newArrivalDate
        });
    }

    function getReadyToShip(uint256 productId) public view ownerOnly(productId) returns (bool) {
        products[productId].readyToShip;
    }

    function setReadyToShip(uint256 productId, bool shipStatus) public ownerOnly(productId) validProductId(productId) {
        products[productId].readyToShip = shipStatus;
    }
}

