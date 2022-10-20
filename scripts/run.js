const hre = require("hardhat");

const main = async () => {
    const contractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const myEpicNFT = await contractFactory.deploy();

    await myEpicNFT.deployed();

    console.log("Contract deployed to:", myEpicNFT.address);

    for (var i = 0; i < 20; i++) {
        const txn = await myEpicNFT.makeAnEpicNFT();
        await txn.wait();
        console.log(`Minted NFT #${i}`);
    }
};

main()
    .then(() => {
        process.exit(0);
    })
    .catch((e) => {
        console.error(e);
        process.exit(1);
    });
