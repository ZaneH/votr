# Votr
My first smart contract using Hardhat + Chai + Waffle.

## Functions
- [x] `transferOwnership(address newOwner)`
- [x] `addPoll(string title)`
- [x] `addCandidate(uint256 pollId, address person, string name)`
- [x] `castVote(uint256 candidateId)`

## Events
- [x] `TransferredOwnership(...)`
- [x] `PollAdded(...)`
- [x] `CandidateAdded(...)`
- [x] `VoteCasted(...)`

## Todo
- [ ] Utilize TypeScript (for tests)
- [ ] Add React interface
- [ ] Add events and write tests for them
- [x] Review Solidity attack vectors and make appropriate changes
