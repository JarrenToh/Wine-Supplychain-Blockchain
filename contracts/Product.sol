pragma solidity ^0.5.0;

contract Product {
    //struct
    struct product {
        product[] componentProduct;
        uint256 productId;
        string name;
        address owner;
        address contractAddress;
        string placeOfOrigin;
        string productionDate;
        string expirationDate;
        uint256 unitQuantity;
        string unitQuantityType;
        uint256 batchQuantity;
        string unitPrice;
        string category;
        bool received;
        uint256 creationValue;
        productLocation[] previousLocation;
        productLocation currentLocation;
    }

    struct productLocation {
        string location;
        string arrivalDate;
    }

    //variables
    uint256 public noProduct = 0;
    mapping(uint256 => product) private products;

    //Events
    event ProductCreated(
        uint256 newProductId,
        string name,
        address contractAddress
    );

    //modifiers
    modifier ownerOnly(uint256 productId) {
        require(products[productId].owner == msg.sender);
        _;
    }

    modifier validProductId(uint256 productId) {
        require(productId < noProduct);
        _;
    }

    //methods
    function createProduct(
        string memory name,
        address contractAddress,
        string memory placeOfOrigin,
        string memory productionDate,
        string memory expirationDate,
        uint256 unitQuantity,
        string memory unitQuantityType,
        uint256 batchQuantity,
        string memory unitPrice,
        string memory category,
        string memory currentPhysicalLocation,
        string memory arrivalDate
    ) public payable returns (uint256) {
        require(
            msg.value > 0.01 ether,
            "at least 0.01 ETH is needed to create a new product"
        );
        require(bytes(name).length > 0, "Name cannot be empty");

        //create new product
        product memory newProduct = product({
            componentProduct: new product[](0),
            productId: noProduct,
            name: name,
            owner: msg.sender,
            contractAddress: contractAddress,
            placeOfOrigin: placeOfOrigin,
            productionDate: productionDate,
            expirationDate: expirationDate,
            unitQuantity: unitQuantity,
            unitQuantityType: unitQuantityType,
            batchQuantity: batchQuantity,
            unitPrice: unitPrice,
            category: category,
            received: false,
            creationValue: msg.value,
            previousLocation: new productLocation[](0),
            currentLocation: productLocation({
                location: currentPhysicalLocation,
                arrivalDate: arrivalDate
            })
        });

        uint256 newProductId = noProduct++;
        products[newProductId] = newProduct;
        emit ProductCreated(newProductId, name, msg.sender);
        return newProductId;
    }

    //transfer ownership when it moves from one entity to another entity in the supplychain
    function transferProduct(
        uint256 productId,
        address newOwner
    ) public ownerOnly(productId) validProductId(productId) {
        products[productId].owner = newOwner;
    }

    // return value of product to the owner of the product
    function removeProduct(uint256 productId) public ownerOnly(productId) validProductId(productId) {
        uint256 value = products[productId].creationValue;
        delete products[productId];
        address payable targetAddress = msg.sender;
        targetAddress.transfer(value);
    }

    function getOwner(uint256 productId) public view validProductId(productId) returns (address){
        return products[productId].owner;
    }

    function setOwner(uint256 productId, address newOwner) public ownerOnly(productId) validProductId(productId) {
        products[productId].owner= newOwner;
    }

    function getContractAddress(uint256 productId) public view validProductId(productId) returns (address){
        return products[productId].contractAddress;
    }

    function setContractAddress(uint256 productId, address newContractAddress) public ownerOnly(productId) validProductId(productId) {
        products[productId].contractAddress = newContractAddress;
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

    function getUnitPrice(uint256 productId) public view validProductId(productId) returns (string memory){
        return products[productId].unitPrice;
    }

    function setUnitPrice(uint256 productId, string memory newUnitPrice) public ownerOnly(productId) validProductId(productId) {
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

    function getCreationValue(uint256 productId) public view validProductId(productId) returns (uint256){
        return products[productId].creationValue;
    }

    function setCreationValue(uint256 productId, uint256 newCreationValue) public ownerOnly(productId) validProductId(productId) {
        products[productId].creationValue = newCreationValue;
    }

    function getPreviousLocation(uint256 productId, uint256 index) public view validProductId(productId) returns (string memory, string memory) {
        require(index < products[productId].previousLocation.length, "Invalid index");
        return (products[productId].previousLocation[index].location, products[productId].previousLocation[index].arrivalDate);
    }

    function addPreviousLocation(uint256 productId, string memory newLocation, string memory newDate) public ownerOnly(productId) validProductId(productId) {
        products[productId].previousLocation.push(productLocation({
            location: newLocation,
            arrivalDate: newDate
        }));
    }

    function getCurrentLocation(uint256 productId) public view validProductId(productId) returns (string memory, string memory) {
        return (products[productId].currentLocation.location, products[productId].currentLocation.arrivalDate);
    }

    function setCurrentLocation(uint256 productId, string memory newLocation, string memory newDate) public ownerOnly(productId) validProductId(productId) {
        products[productId].currentLocation = productLocation({
            location: newLocation,
            arrivalDate: newDate
        });
    }
}
