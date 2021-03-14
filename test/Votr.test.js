const chai = require("chai");
const { expect } = chai;
const chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
const { ethers } = require("hardhat");

describe("Votr", () => {
  let Votr;
  let votr;

  const POLL_NAME = "U.S. President 2024";
  const CANDIDATE_NAME = "Jeff Bezos";

  beforeEach(async () => {
    Votr = await ethers.getContractFactory("Votr");
    votr = await Votr.deploy();

    await votr.deployed();
  });

  it("should be owned by the deployer", async () => {
    const [owner] = await ethers.getSigners();

    expect(await votr.owner()).to.be.equal(owner.address);
  });

  it("should add a poll", async () => {
    await votr.addPoll(POLL_NAME);

    expect((await votr.polls(0)).title).to.equal(
      POLL_NAME,
      "Poll title is correct"
    );
  });

  it("should add a candidate to a poll", async () => {
    await votr.addPoll(POLL_NAME);

    let [owner] = await ethers.getSigners();
    await votr.addCandidate(0, owner.address, CANDIDATE_NAME);

    expect((await votr.candidates(0)).pollId).to.equal(0);
    expect((await votr.candidates(0)).name).to.equal(CANDIDATE_NAME);
  });

  it("should only cast a vote once", async () => {
    await votr.addPoll(POLL_NAME);

    let [owner] = await ethers.getSigners();
    await votr.addCandidate(0, owner.address, CANDIDATE_NAME);

    await votr.castVote(0);

    expect(votr.castVote(0)).to.be.rejected;

    expect((await votr.candidates(0)).votes).to.equal(1);
    expect((await votr.candidates(0)).votes).to.equal(1);
  });

  it("should only allow the owner to create polls", async () => {
    await votr.transferOwnership("0x0000000000000000000000000000000000000000");

    expect(votr.addPoll(POLL_NAME)).to.be.rejected;
  });
});
