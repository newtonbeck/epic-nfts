const hre = require("hardhat");

const main = async () => {
    const contractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const myEpicNFTContract = await contractFactory.deploy();

    await myEpicNFTContract.deployed();

    console.log("Contract deployed to:", myEpicNFTContract.address);
};

main()
    .then(() => {
        process.exit(0);
    })
    .catch((e) => {
        console.error(e);
        process.exit(1);
    });