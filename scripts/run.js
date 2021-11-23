const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("GenerativeCocktail");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to: ", nftContract.address);

  // Call mint function
  let txn = await nftContract.mintNFT()

  // Wait for it to be mined
  await txn.wait()

  // Mint another NFT
  txn = await nftContract.mintNFT()
  
  // Wait for it to be mined
  await txn.wait()
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
};

runMain();
