const main = async () => {
  const [owner, random] = await hre.ethers.getSigners();

  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");

  const txOptions = { value: hre.ethers.utils.parseEther("0.1") };
  const waveContract = await waveContractFactory.deploy(txOptions);
  await waveContract.deployed();

  console.log("Contract deployed in address:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  // Contract balance
  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance before wave:", hre.ethers.utils.formatEther(contractBalance));

  // Waves count
  let waveCount;
  waveCount = await waveContract.totalWaves();
  console.log(`Wave count ${waveCount}`);

  // Wave message
  const waveTxn1 = await waveContract.wave("#1 message");
  await waveTxn1.wait();

  const waveTxn2 = await waveContract.connect(random).wave("#2 message");
  await waveTxn2.wait();

  waveCount = await waveContract.totalWaves();
  console.log(`Wave count ${waveCount}`);

  // Contract balance
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance after wave:", hre.ethers.utils.formatEther(contractBalance));

  // All waves
  const waves = await waveContract.getAllWaves();
  console.log("All waves sent till now:", waves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
