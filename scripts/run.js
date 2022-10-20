const hre = require("hardhat");

const main = async () => {
    const contractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const myEpicNFT = await contractFactory.deploy();

    await myEpicNFT.deployed();

    console.log("Contract deployed to:", myEpicNFT.address);

    const txnOne = await myEpicNFT.makeAnEpicNFT();
    await txnOne.wait();
    console.log("Minted NFT #1");

    const txnTwo = await myEpicNFT.makeAnEpicNFT();
    await txnTwo.wait();
    console.log("Minted NFT #2");
};

main()
    .then(() => {
        process.exit(0);
    })
    .catch((e) => {
        console.error(e);
        process.exit(1);
    });
