
# Wine Supply Chain Smart Contract
The Wine Supply Chain Smart Contract is created to establish a supply chain for the production and distribution of wine, starting from the raw material suppliers and ending at the retailer. The supply chain consists of various stages, including raw material suppliers, wine production, bulk distribution, transit storage, filling/packaging, goods distribution, wholesaling, and retailing. Each stage is represented by a different actor in the supply chain and has its own unique functions and responsibilities.

### Activity Diagram

![image](https://user-images.githubusercontent.com/89383093/230786716-b7cf1056-a825-4c7a-8fd2-4ec366f862e7.png)

### Class Diagram

![image](https://user-images.githubusercontent.com/89383093/230837863-42bb76d0-7500-4075-aab2-68e0914780fe.png)

## Requirement

Ganache: A personal blockchain for Ethereum development.

Truffle: A development framework for building and deploying smart contracts.

Visual Studio Code: Integrated Development Environment

## Actors
The actors in the supply chain are as follows:

  RawMaterialSupplier: This actor is responsible for supplying ingredients that will be used to produce wine.
  
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

  18. setProductionDate: This function sets the production date of the product with the given productId to the new value newProductionDate.

  19. getExpirationDate: This function returns the expiration date of the product with the given productId.

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

  6. dispatchRawMaterial: This function dispatches the raw material to the wine producer. It takes the productId, newDispatchDate, wineProducerAddress, and wineProducerContractAddress. It checks if the raw material is ready to ship and if the msg.sender is the current owner of the product. If yes, it updates the previous owner and contract address of the product, sets the current contract address to the wineProducerContractAddress, updates the current location, sets the current owner to the wineProducerAddress, and finally, emits the rawMaterialDispatched event with the productId.


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

  1. constructor(Product productContractAddress, BulkDistributor bulkDistributorAddress): This is the constructor function that initializes the contract with the addresses of two other contracts, "Product" and "BulkDistributor".

  2. getAnalysisDetails: This function allows anyone to retrieve the analysis details of a particular product.

  3. buyWineFromBulkDistributor: This function allows a buyer to purchase wine from the bulk distributor. The buyer must send enough ether to cover the price of the product. Once the payment is received, the wine is marked as "bought" and an event is emitted.

  4. receiveWineFromBulkDistributor: This function allows the transit cellar owner to receive wine from the bulk distributor. The function checks that the wine has not already been received, that it is being received by the correct contract, and that it is ready to be shipped. If all conditions are met, the wine is marked as received, and an event is emitted.

  5. returnWine: This function allows the transit cellar owner to return wine to the bulk distributor. The function checks that the wine has been received and transfers ownership of the product back to the previous owner.

  6. refundFillerPacker: This function allows the transit cellar owner to refund the filler packer for the wine. The function checks that the current owner is the transit cellar owner and that enough ether has been sent to cover the refund. If all conditions are met, the previous owner is refunded, and an event is emitted.

  7. removeWine: This function allows the transit cellar owner to remove a product from the products list. An event is emitted once the product is removed.

  8. analyseWine: This function allows anyone to store analysis details for a particular product. An event is emitted once the analysis is complete.

  9. materialReadyToShip: This function allows the transit cellar owner to mark a product as ready to be shipped to the filler packer. An event is emitted once the product is marked as ready to ship.

  10. dispatchWineToFillerPacker: This function allows the transit cellar owner to dispatch the wine to the filler packer. The function checks that the wine is ready to be shipped, and that it is being dispatched by the correct contract. If all conditions are met, ownership of the product is transferred to the filler packer, and an event is emitted.


### FillerPacker.sol

  1. constructor(Product productContractAddress, TransitCellar transitCellarAddress): This function is the constructor of the smart contract. It is executed only once when the contract is deployed to the blockchain network. It initializes the contract by setting the addresses of the Product and TransitCellar contracts.

  2. getOwner: This function is used to retrieve the address of the contract owner. The "view" keyword indicates that this function does not modify the contract state and can be executed without incurring any gas cost.

  3. getPackagingDetails: This function is used to retrieve the packaging details of a product by its ID. The "view" keyword indicates that this function does not modify the contract state and can be executed without incurring any gas cost. It takes a product ID as input and returns the packaging details associated with that product.

  4. getLabelDetails: This function is used to retrieve the label details of a product by its ID. The "view" keyword indicates that this function does not modify the contract state and can be executed without incurring any gas cost. It takes a product ID as input and returns the label details associated with that product.

  5. buyWineFromTransitCellar: This function is used to buy wine from the TransitCellar contract by sending ether to the contract. It takes a product ID as input and the caller must send enough ether to cover the cost of the product.

  6. receiveWineFromTransitCellar: This function is used to receive wine from the TransitCellar contract and update the product's location details. It takes a product ID, the current location, and the arrival date as inputs. The "ownerOnly" modifier ensures that only the contract owner can execute this function.

  7. returnWine: This function is used to return wine to the TransitCellar contract and update the product's location details. It takes a product ID as input and the caller must send enough ether to cover the cost of returning the product.

  8. refundGoodsDistributor: This function is used to refund the GoodsDistributor for a product. It takes a product ID as input and the caller must send enough ether to cover the cost of the refund. The "ownerOnly" modifier ensures that only the contract owner can execute this function.

  9. removeWine: This function allows the filler packer owner to remove a product from the products list. An event is emitted once the product is removed.

  10. packageWine: This function is used to store the packaging details of a product. It takes a product ID and the packaging details as inputs and updates the packaging details associated with that product.

  11. labelWine: This function is used to store the label details of a product. It takes a product ID and the label details as inputs and updates the label details associated with that product.

  12. materialReadyToShip: This function is used to set a product as ready to ship to the GoodsDistributor. It takes a product ID as input and the "ownerOnly" modifier ensures that only the contract owner can execute this function.

  13. dispatchWineToGoodsDistributor: This function is used to dispatch a product to the GoodsDistributor and update its location details. It takes in four parameters - the product ID, dispatch date, new owner address, and new contract address. The ownerOnly modifier ensures that only the contract owner can execute this function. Before updating the product's location details, the function checks whether the product is ready for shipping and whether the contract address matches the current contract address. Then, it updates the product's location details, sets the previous owner and contract address as the current owner and contract address, respectively, and sets the received status of the product as false. Finally, it emits the wineDispatched event.


### GoodsDistributor.sol

  1. constructor(Product productContractAddress, FillerPacker fillerPackerAddress): This function is the constructor of the smart contract. It is executed only once when the contract is deployed to the blockchain network. It initializes the contract by setting the addresses of the Product and FillerPacker contracts.

  2. getWineBatchStorage is a view function that returns an array of uint256 values representing the IDs of wine batches that have been received by the GoodsDistributor contract.

  3. removeWineBatchFromStorage is a function that takes in a wineBatchId parameter and removes the corresponding ID from the wineBatchStorage array if it exists. The function checks whether the ID is within the bounds of the array, and if not, it returns without doing anything. Otherwise, it shifts all the elements after the ID one position to the left and pops the last element of the array.

  4. materialReadyToShip is a function that takes in a productId parameter and sets the readyToShip status of the corresponding product to true in the productContract. The function checks whether the caller is the owner of the product, and whether the product is not already marked as ready to ship. If these conditions are met, the function sets the readyToShip status to true and emits the readyToShip event with the productId parameter.

  5. buyWineFromFillerPacker: This function is used to buy a wine batch from the FillerPacker contract and update its ownership details. It takes in one parameter - the product ID. The function first checks whether the amount of ether sent by the buyer is sufficient to buy the wine batch. If the amount is insufficient, the function will throw an error message. Next, it calculates the product's price by multiplying the unit price by the batch quantity. The function then transfers the product price to the current owner's address using the transfer function. The target address is obtained using the getCurrentOwner function of the Product contract, and it is cast to an address payable type to enable the transfer function. Finally, the function emits the buyWineBatch event to indicate that the wine batch has been bought by the GoodsDistributor contract.

  6. receiveWine: This function is used to receive wine from the previous owner and update its location details. It takes in three parameters - the product ID, current location, and arrival date. The ownerOnly modifier ensures that only the contract owner can execute this function. The function first checks whether the product is ready to ship and whether the contract address matches the current contract address. Then, it adds the previous location details to the product's history, updates the current location details, and sets the received and ready to ship status of the product as true and false, respectively. It also adds the product ID to the wineBatchStorage array and emits the wineBatchReceived event.

  7. returnWine: This function is used to return wine to the previous owner and update its ownership and contract details. It takes in one parameter - the product ID. The ownerOnly modifier ensures that only the contract owner can execute this function. The function first checks whether the product has been received before it can be returned. Then, it updates the ownership and contract details of the product to the previous owner and contract address, respectively, and emits the returnedWine event.

  8. refundWholesaler: This function is used to refund the wholesaler when a product is returned. It takes in one parameter - the product ID - and requires that the current owner is the sender. The function calculates the product price and ensures that the sent amount is greater than or equal to the product price. It then transfers the product price to the previous owner's address and emits the refundWine event.

  9. dispatchWineToWholesaler: This function is used to dispatch a product to a wholesaler and update its location and ownership details. It takes in four parameters - the product ID, dispatch date, wholesaler address, and wholesaler contract address. The ownerOnly modifier ensures that only the contract owner can execute this function. The function first checks whether the product is ready to ship and whether the contract address matches the current contract address. Then, it sets the previous owner and contract address as the current owner and contract address, respectively, and sets the received status of the product as false. It also removes the product ID from the wineBatchStorage array and emits the dispatchWineBatch event.

  10. removeWineBatch: This function is used to remove a product from the smart contract and the wineBatchStorage array. It takes in one parameter - the product ID - and requires that the current owner is the sender. The function removes the product from the productContract and wineBatchStorage array and emits the wineBatchRemoved event.

### Wholesaler.sol

  1. constructor(Product productAddress, GoodsDistributor goodsDistributorAddress): This is the constructor function of the Wholesaler contract that initializes the productContract and goodsDistributorContract variables with the addresses of the deployed Product and GoodsDistributor contracts respectively. The owner variable is also set to the address of the sender.

  2. buyWineFromGoodsDistributor: This function is used to buy wine from the GoodsDistributor contract. It takes in the productId parameter and requires that the sent value is greater than the price of the product. The function then transfers the product price to the current owner of the product and emits the buyWine event.

  3. removeWine: This function is used to remove a product from the productContract. It takes in one parameter - the product ID - and requires that the current owner is the sender. The function removes the product from the productContract and emits the wineRemoved event.

  4. materialReadyToShip: This function is used to set a product to "ready to ship" status. It takes in the productId parameter and requires that the current owner is the sender and the product is not already "ready to ship". The function sets the readyToShip status of the product to true and emits the readyToShip event.

  5. receiveWine: This function is used to receive wine from the FillerPacker contract. It takes in the productId parameter, currentLocation and arrivalDate and requires that the product has not been received, is ready to ship, and the current contract address is the Wholesaler contract. The function adds the previous location of the product to the previousLocations mapping, sets the currentLocation of the product to the new currentLocation and arrivalDate, and sets the received and readyToShip status of the product to true. It emits the wineReceived event.

  6. returnWine: This function is used to return wine to the previous owner of the product. It takes in the productId parameter and requires that the product has been received. The function sets the previousOwner and previousContractAddress of the product to the current owner and contract address respectively, and sets the currentOwner and currentContractAddress of the product to the previous owner and contract address respectively. It emits the returnedWine event.

  7. refundRetailer: This function is used to refund a retailer for a returned product. It takes in the productId parameter and requires that the current owner is the sender. The function transfers the product price to the previous owner of the product and emits the refundWine event.

  8. dispatchWineToRetailer: This function is used to dispatch wine to a retailer. It takes in the productId, newDispatchDate, retailerAddress, and retailerContractAddress parameters and requires that the product is "ready to ship" and the current contract address is the Wholesaler contract. The function sets the previousOwner and previousContractAddress of the product to the current owner and contract address respectively, and sets the currentContractAddress of the product to the retailerContractAddress parameter. It also updates the currentLocation of the product with the new dispatch date, and sets the received status of the product to false. Finally, the currentOwner of the product is set to the retailerAddress parameter, and the dispatchWine event is emitted.

### Retailer.sol

  1. constructor(Product productAddress, Wholesaler wholeSalerAddress): This is the constructor function for the Retailer contract. It takes in the addresses of the Product and Wholesaler contracts and initializes their instances in the Retailer contract.

  2. getWineRemaining: This function takes in a wineBatchId as a parameter and returns the remaining quantity of wine in that batch.

  3. buyWineFromWholesaler: This function allows the retailer to buy wine from the wholesaler. It takes in the productId as a parameter and requires the retailer to pay the total price of the batch of wine. The function then transfers the payment to the current owner of the product (i.e., the wholesaler) and emits a buyWineBatch event.

  4. receiveWine: This function allows the retailer to receive wine from the filler/packer. It takes in the productId, the current location, and the arrival date as parameters. The function requires that the product has not already been received, is ready to ship, and the current contract address is the Retailer contract. It then updates the product's previous and current location, sets the product as received and not ready to ship, and emits a wineBatchReceived event.

  5. returnWine: This function allows the retailer to return wine to the previous owner (e.g., the wholesaler). It takes in the productId as a parameter and requires that the product has already been received. The function then updates the product's current and previous owner and contract address and emits a returnedWine event.

  6. sellWine: This function allows the retailer to sell a certain quantity of wine from a specific batch. It takes in the productId and the quantity as parameters and updates the remaining quantity of wine in that batch. It also emits a soldWine event.

  7. removeWineBatch: This function allows the retailer to remove a specific batch of wine from the product list. It takes in the productId as a parameter and removes the product from the list. It also emits a wineBatchRemoved event.


## Deployment
To deploy the smart contract, you can use Solidity 9 and deploy it on any compatible blockchain platform, like Ethereum. One way to deploy it is by using a smart contract deployment tool such as Remix. Alternatively, you can use Visual Studio Code (VSCode) to compile and deploy the contract. To do this, you will need to install the necessary extensions and configure your development environment accordingly. Once set up, you can compile the contract using the Solidity Compiler extension and deploy it to the blockchain of your choice using the Truffle Suite.

To run the smart contract and associated tests, you will need to follow these steps:

Start Ganache: ganache-cli

Compile the Solidity contract: truffle compile

Deploy the contract to the local blockchain: truffle migrate

Run the tests: 
  - truffle test test_supplyChain.js 
  - truffle test test_refunds.js 

This will execute the test_supplyChain.js and test_refunds.js files, which contain series of tests to ensure that the smart contract functions as expected.

