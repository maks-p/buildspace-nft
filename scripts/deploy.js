const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("GenerativeCocktail");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to: ", nftContract.address);

  let txn = await nftContract.mintNFT();
  await txn.wait();
  console.log("Minted NFT #1");

  // txn = await nftContract.mintNFT();
  // await txn.wait();
  // console.log("Minted NFT #2");
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
