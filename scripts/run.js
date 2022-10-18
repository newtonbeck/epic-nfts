const hre = require("hardhat");

const main = async () => {
    const contractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const myEpicNFT = await contractFactory.deploy();

    await myEpicNFT.deployed();

    console.log("Contract deployed to:", myEpicNFT.address);

    const txnOne = await myEpicNFT.makeAnEpicNFT();
    await txnOne.wait();

    const txnTwo = await myEpicNFT.makeAnEpicNFT();
    await txnTwo.wait();
};

main()
    .then(() => {
        process.exit(0);
    })
    .catch((e) => {
        console.error(e);
        process.exit(1);
    });
