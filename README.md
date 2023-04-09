# Wine Supply Chain Smart Contract Readme
This smart contract is designed to implement a supply chain for the production and distribution of wine, from the grape grower to the retailer. The supply chain consists of several stages, including grape growing, wine production, bulk distribution, transit storage, filling/packaging, goods distribution, wholesaling, and retailing. Each stage is represented by a different actor in the supply chain and has its own set of functions and responsibilities

## Requirement

Ganache: A personal blockchain for Ethereum development.

Truffle: A development framework for building and deploying smart contracts.

Visual Studio Code: Integrated Development Environment

## Actors
The actors in the supply chain are as follows:

  GrapeGrower: This actor is responsible for growing and harvesting the grapes that will be used to produce wine.
  
  WineProducer: This actor is responsible for transforming the grapes into wine, including fermentation and aging.
  
  BulkDistributor: This actor is responsible for transporting the wine from the wine producer to the transit cellar, where it will be stored temporarily.
  
  TransitCellar: This actor is responsible for storing the wine temporarily until it is ready to be packaged and distributed.
  
  Filler/Packer: This actor is responsible for filling and packaging the wine for distribution.
  
  GoodsDistributor: This actor is responsible for transporting the packaged wine from the filler/packer to the wholesaler.
  
  Wholesaler: This actor is responsible for distributing the wine to retailers.
  
  Retailer: This actor is responsible for selling the wine to end customers.

## Functions

The following functions are available for each actor in the supply chain:

### Product.sol

  1. createProduct: This function is used to create a new product instance in the system. It takes in various parameters such as name, current contract address, unit quantity, unit quantity type, batch quantity, unit price, category and message sender address. It then creates a new product instance using the Product contract and sets the required information for the product such as product ID, name, current owner, current contract address, unit quantity, unit quantity type, batch quantity, unit price, category and other details such as whether the product is received or used, its current and previous location, and whether it is ready to ship.
  
  2. addComponentProduct: This function adds a component product to the given main product. It takes two parameters: mainProductId, which is the ID of the main product, and productId, which is the ID of the component product to be added. The function first checks if the caller of the function is the owner of the productId using the ownerOnly modifier, and then checks if the productId is valid using the validProductId modifier. Finally, it adds the productId to the componentProductIds array of the main product.
  
  3. getComponentProductIds: This function returns an array of component product IDs for the given main product. It takes one parameter: mainProductId, which is the ID of the main product. The function first checks if the mainProductId is valid using the validProductId modifier, and then returns the componentProductIds array of the main product.
  
  4. transferProduct: This function transfers ownership of the given product to a new owner and updates the contract address. It takes three parameters: productId, which is the ID of the product to be transferred, newOwner, which is the address of the new owner, and newContractAddress, which is the address of the new contract. The function first checks if the caller of the function is the owner of the productId using the ownerOnly modifier, and then checks if the productId is valid using the validProductId modifier. The function then updates the previousOwner and previousContractAddress fields of the product with the current owner and contract address, and then updates the currentOwner and currentContractAddress fields with the new owner and contract address.

  5. removeProduct: This function removes the given product from the system. It takes one parameter: productId, which is the ID of the product to be removed. The function first checks if the caller of the function is the owner of the productId using the ownerOnly modifier, and then checks if the productId is valid using the validProductId modifier. Finally, it deletes the product from the system.
  
  6. getProductName: This function returns the name of the given product. It takes one parameter: productId, which is the ID of the product. The function first checks if the productId is valid using the validProductId modifier, and then returns the name field of the product.
  
  7. getCurrentOwner: This function returns the current owner address of the given product. It takes one parameter: productId, which is the ID of the product. The function first checks if the productId is valid using the validProductId modifier, and then returns the currentOwner field of the product.
  
  8. setCurrentOwner: This function updates the current owner address of the given product. It takes two parameters: productId, which is the ID of the product, and newOwner, which is the address of the new owner. The function first checks if the caller of the function is the owner of the productId using the ownerOnly modifier, and then checks if the productId is valid using the validProductId modifier. The function then updates the currentOwner field of the product with the new owner address.
  
  9. getCurrentContractAddress: This function returns the current contract address of the product with the given productId.
  
  10. setCurrentContractAddress: This function sets the current contract address of the product with the given productId to the new address newContractAddress.
  
  11. getPreviousOwner: This function returns the previous owner of the product with the given productId.
  
  12. setPreviousOwner: This function sets the previous owner of the product with the given productId to the new owner address newPreviousOwner.
  
  13. getPreviousContractAddress: This function returns the previous contract address of the product with the given productId
  
  14. setPreviousContractAddress: This function sets the previous contract address of the product with the given productId to the new address newPreviousContractAddress.
  
  15. getPlaceOfOrigin: This function returns the place of origin of the product with the given productId.
  
  16. setPlaceOfOrigin: This function sets the place of origin of the product with the given productId to the new value newPlaceOfOrigin.

  17. getProductionDate: This function returns the production date of the product with the given productId.

  18: setProductionDate: This function sets the production date of the product with the given productId to the new value newProductionDate.

  19: getExpirationDate: This function returns the expiration date of the product with the given productId.

  20. setExpirationDate: This function sets the expiration date of the product with the given productId to the new value newExpirationDate.

  21. getUnitQuantity: This function returns the unit quantity of the product with the given productId.

  22. setUnitQuantity: This function sets the unit quantity of the product with the given productId to the new value newUnitQuantity.

  23. getUnitQuantityType: This function returns the unit quantity type of the product with the given productId.

  24. setUnitQuantityType: This function sets the unit quantity type of the product with the given productId to the new value newUnitQuantityType.

  25. getBatchQuantity: This function returns the batch quantity of the product with the given productId.

  26. setBatchQuantity: This function sets the batch quantity of the product with the given productId to the new value newBatchQuantity.

  27. getUnitPrice: This function returns the unit price of the product with the given productId.

  28. setUnitPrice: This function sets the unit price of the product with the given productId to the new value newUnitPrice.

  29. getCategory: This function returns the category of the product with the given productId.
  
  30. setCategory: This function sets the category of the product with the given productId to the specified newCategory.

  31. getReceived: This function returns a boolean value indicating whether the product with the given productId has been received.

  32. setReceived: This function sets the received status of the product with the given productId to the specified newReceived boolean value.

  33. getUsed: This function returns a boolean value indicating whether the product with the given productId has been used.

  34. setUsed: This function sets the used status of the product with the given productId to the specified used boolean value.

  35. getPreviousLocation: This function returns a tuple of three strings representing the location, dispatch date, and arrival date of the product with the given productId at the specified index in its previous location history.

  36. addPreviousLocation: This function adds a new previous location to the product with the given productId, recording the location name, dispatch date, and arrival date as specified in the function arguments.

  37. getCurrentLocation: This function returns a tuple of three strings representing the current location, dispatch date, and arrival date of the product with the given productId.

  38. setCurrentLocation: This function sets the current location of the product with the given productId to the specified location name, dispatch date, and arrival date.

  39. getReadyToShip: This function returns a boolean value indicating whether the product with the given productId is ready to be shipped.

  40. setReadyToShip: This function sets the ready to ship status of the product with the given productId to the specified boolean value.

### RawMaterialSupplier.sol

  1. constructor(Product productContractAddress): This is the constructor of the RawMaterialSupplier contract, which takes an address of an already deployed Product contract and sets it as the productContract.

  2. addRawMaterial: This function adds a new raw material to the Product contract. It takes various parameters like name, placeOfOrigin, productionDate, expirationDate, unitQuantity, unitQuantityType, batchQuantity, unitPrice, category, and currentPhysicalLocation. It then calls the createProduct() function of the productContract to create a new product and sets the values of the parameters. Finally, it emits the rawMaterialAdded event with the productId of the new product.

  3. refundWineProducer: This function refunds the wine producer for the raw material that they have returned. It takes the productId of the raw material and checks if the msg.sender is the current owner of the product. If yes, it transfers the amount paid by the wine producer to the previous owner of the product. Finally, it emits the refundRawMaterial event with the productId.

  4. removeRawMaterial: This function removes the raw material from the Product contract. It takes the productId of the raw material and checks if the msg.sender is the current owner of the product. If yes, it calls the removeProduct() function of the productContract to remove the product from the contract. Finally, it emits the rawMaterialRemoved event with the productId.

  5. materialReadyToShip: This function updates the status of the raw material to ready for shipping. It takes the productId of the raw material and checks if the msg.sender is the current owner of the product. If yes, it calls the setReadyToShip() function of the productContract to update the status of the product. Finally, it emits the rawMaterialReadyToShip event with the productId.

  6. dispatchRawMaterial: This function dispatches the raw material to the wine producer. It takes the productId, newDisbatchDate, wineProducerAddress, and wineProducerContractAddress. It checks if the raw material is ready to ship and if the msg.sender is the current owner of the product. If yes, it updates the previous owner and contract address of the product, sets the current contract address to the wineProducerContractAddress, updates the current location, sets the current owner to the wineProducerAddress, and finally, emits the rawMaterialDispatched event with the productId.


### WineProducer.sol

  1. constructor(Product productContractddress, RawMaterialSupplier supplierContractAddress): A constructor that sets the addresses of the Product and RawMaterialSupplier contracts, which are required for interacting with the other contracts in the supply chain.

  2. buy: A function that allows the wine producer to buy raw materials from the raw material supplier. The function checks that the wine producer has sufficient funds to make the purchase, and then transfers the funds to the current owner of the raw materials (i.e. the raw material supplier). It also emits an event buyRawMaterial.

  3. received: A function that updates the status of the raw materials when they are received by the wine producer. The function sets the received status to true, updates the current and previous locations of the product, and emits an event rawMaterialReceived. This function is only accessible by the owner of the raw materials.

  4. removeWine: A function that removes a wine product from the supply chain. The function emits an event wineRemoved. This function is only accessible by the owner of the wine product.

  5. returnRawMaterials: A function that allows the wine producer to return raw materials to the previous owner (i.e. the raw material supplier). The function checks that the raw materials have been received, and then updates the ownership and contract addresses of the raw materials to the previous owner and contract. It emits an event returnedRawMaterial. This function is only accessible by the owner of the raw materials.

  6. refundBulkDistributor: A function that allows the wine producer to refund a bulk distributor for a wine product. The function checks that the wine producer is the current owner of the product, and that they have sufficient funds to make the refund. It then transfers the funds to the previous owner of the product (i.e. the bulk distributor). It emits an event refundWine. This function is only accessible by the owner of the wine product.

  7. wineReadyToShip: A function that sets the readyToShip status of a wine product to true. It emits an event WineReadyToShip. This function is only accessible by the owner of the wine product.

  8. processWine: A function that creates a new wine product by processing raw materials. The function checks that all the required raw materials are available and have not been used before, and then creates a new wine product using the createProduct function from the Product contract. It also sets the place of origin, production date, expiration date, and current location of the wine product, and adds the raw materials as components of the wine product. It emits an event processedWine and returns the ID of the new wine product.

  9. dispatchWineToBulkDistributor: A function that dispatches a wine product to a bulk distributor. The function checks that the wine product is ready to be shipped, and then updates the disbatch date and current location of the wine product to the address of the bulk distributor contract. It also sets the previous owner and contract address of the wine product, and emits an event dispatchWine.


### BulkDistributor.sol

  1. Constructor(Product productAddress, WineProducer wineProducerAddress): A constructor function that takes in two parameters, the address of the Product contract and the address of the WineProducer contract. These addresses are stored in the state variables productContract and wineProducerContract respectively.

  2. buyWineFromWineProducer: A function that allows the BulkDistributor to buy wine from the WineProducer. The function checks that the BulkDistributor has sufficient funds to make the purchase, based on the price of the product (unit price multiplied by batch quantity). If the funds are sufficient, the function transfers the payment to the WineProducer and emits an event buyWine.

  3. removeWine: A function that allows the BulkDistributor to remove a product from the supply chain. The function checks that the caller of the function is the current owner of the product, by using the ownerOnly modifier. If the caller is the current owner, the product is removed from the Product contract and an event wineRemoved is emitted.

  4. receiveWine: A function that allows the BulkDistributor to receive wine from the WineProducer. The function checks that the caller of the function is the current owner of the product, by using the ownerOnly modifier. It also checks that the product has not already been received, and that it is currently owned by the BulkDistributor. If these conditions are met, the function updates the current location and arrival date of the product in the Product contract, and emits an event wineReceived.

  5. returnWine: A function that allows the BulkDistributor to return wine to the previous owner in the supply chain. The function checks that the caller of the function is the current owner of the product, by using the ownerOnly modifier. It also checks that the product has been received by the BulkDistributor. If these conditions are met, the function updates the previous owner and previous contract address of the product in the Product contract, and emits an event returnedWine.

  6. refundTransitCellar: A function that allows the BulkDistributor to refund a Transit Cellar for a returned product. The function checks that the caller of the function is the current owner of the product, by using the ownerOnly modifier. It also checks that the product has been returned by the Transit Cellar, and that the funds provided by the Transit Cellar are sufficient to cover the cost of the product. If these conditions are met, the function transfers the payment to the previous owner of the product and emits an event refundWine.

  7. materialReadyToShip: A function that allows the BulkDistributor to mark a product as ready for shipping. The function checks that the caller of the function is the current owner of the product, by using the ownerOnly modifier. If the caller is the current owner, the product is marked as ready to ship in the Product contract and an event readyToShip is emitted.

  8. dispatchWineToTransitCellar: A function that allows the BulkDistributor to dispatch wine to a Transit Cellar. The function checks that the caller of the function is the current owner of the product, by using the ownerOnly modifier. It also checks that the product is ready to ship and is currently owned by the BulkDistributor. If these conditions are met, the function updates the previous owner and previous contract address of the product in the Product contract, and sets the current owner and current contract address to the Transit Cellar's address and contract address respectively. The current location and dispatch date of the product are also updated in the Product contract. Finally, the function emits an event dispatchToTransitCellar to indicate that the product has been dispatched to the transit cellar.


### TransitCellar.sol

  1. constructor(Product productContractAddress, BulkDistributor bulkDistributorAddress): A constructor function that takes in two parameters, the address of the Product contract and the address of the BulkDistributor contract. These addresses are stored in the state variables productContract and bulkDistributorContract respectively. The constructor function is marked as public and is executed only once when the contract is deployed.
  
  2. getAnalysisDetails: a public function that takes in a productId and returns the analysis details of the product stored in the analysisDetails mapping.
  
  3. buyWineFromBulkDistributor: a public payable function that takes in a productId and transfers the required amount of Ether to the bulk distributor to buy the wine. If the transferred amount is less than the product price, it reverts the transaction.
  
  4. receiveWineFromBulkDistributor: a public payable function that takes in a productId, the current location and arrival date of the wine. It checks whether the caller is the current owner of the wine and whether the wine is not already received, ready to ship, and whether the current contract address matches the product's current contract address. It then sets the wine as received, not ready to ship, and sets the previous location details before emitting a wineReceived event.
  
  5. returnWine: a public payable function that takes in a productId and returns the wine to the previous owner and contract address of the wine. It then emits a wineReturned event.
  
  6. refundFillerPacker: a public payable function that takes in a productId and refunds the filler packer the amount they paid for the product. It then emits a wineRefunded event.
  
  7. removeWine: a public function that takes in a productId and removes the product from the products. It then emits a wineRemoved event.


### FillerPacker.sol


### GoodsDistributor.sol


### Wholesaler.sol


### Retailer.sol


## Deployment
To deploy the smart contract, you can use Solidity 9 and deploy it on any compatible blockchain platform, like Ethereum. One way to deploy it is by using a smart contract deployment tool such as Remix. Alternatively, you can use Visual Studio Code (VSCode) to compile and deploy the contract. To do this, you will need to install the necessary extensions and configure your development environment accordingly. Once set up, you can compile the contract using the Solidity Compiler extension and deploy it to the blockchain of your choice using the Truffle Suite.

To run the smart contract and associated tests, you will need to follow these steps:

Start Ganache: ganache-cli

Compile the Solidity contract: truffle compile

Deploy the contract to the local blockchain: truffle migrate

Run the tests: 
  - truffle test test_supplyChain.js 
  - truffle test test_refunds.js 

This will execute the test_supplyChain.js file, which contains a series of tests to ensure that the smart contract functions as expected.

