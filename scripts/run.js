const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();

  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  let waveCount;
  waveCount = await waveContract.totalWaves();
  console.log(`Wave count ${waveCount}`);

  let waveTxn = await waveContract.wave("Fisrt message");
  await waveTxn.wait();

  waveCount = await waveContract.totalWaves();
  console.log(`Wave count ${waveCount}`);

  waveTxn = await waveContract.connect(randomPerson).wave("Second message");
  await waveTxn.wait();

  waveCount = await waveContract.totalWaves();
  console.log(`Wave count ${waveCount}`);

  const waves = await waveContract.getAllWaves();
  console.log("Waves sent till now:", waves);
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
