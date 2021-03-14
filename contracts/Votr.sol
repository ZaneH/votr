// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Votr {
    address public owner;

    struct Candidate {
        uint256 id;
        string name;
        address person;
        uint256 votes;
        uint256 pollId;
    }

    struct PollInfo {
        uint256 id;
        string title;
    }

    PollInfo[] public polls;
    Candidate[] public candidates;

    mapping(address => mapping(uint256 => bool)) public votedForPoll;

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function addPoll(string calldata _title) public onlyOwner {
        polls.push(PollInfo({id: polls.length, title: _title}));
    }

    function addCandidate(
        uint256 _pollId,
        address _person,
        string calldata _name
    ) public onlyOwner {
        candidates.push(
            Candidate({
                id: candidates.length,
                name: _name,
                person: _person,
                votes: 0,
                pollId: _pollId
            })
        );
    }

    function castVote(uint256 _candidateId) public {
        uint256 pollId = candidates[_candidateId].pollId;

        require(
            !votedForPoll[msg.sender][pollId],
            "You've already voted for this poll"
        );

        candidates[_candidateId].votes += 1;
        votedForPoll[msg.sender][pollId] = true;
    }
}
