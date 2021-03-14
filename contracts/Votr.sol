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

    event PollAdded(uint256 pollId, string title);

    event CandidateAdded(
        uint256 candidateId,
        string name,
        address indexed person,
        uint256 indexed pollId
    );

    event VoteCasted(
        uint256 indexed pollId,
        uint256 indexed candidateId,
        address indexed voter
    );

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
        uint256 pollId = polls.length;
        polls.push(PollInfo({id: pollId, title: _title}));

        emit PollAdded(pollId, _title);
    }

    function addCandidate(
        uint256 _pollId,
        address _person,
        string calldata _name
    ) public onlyOwner {
        uint256 candidateId = candidates.length;
        candidates.push(
            Candidate({
                id: candidateId,
                name: _name,
                person: _person,
                votes: 0,
                pollId: _pollId
            })
        );

        emit CandidateAdded(candidateId, _name, _person, _pollId);
    }

    function castVote(uint256 _candidateId) public {
        uint256 pollId = candidates[_candidateId].pollId;

        require(
            !votedForPoll[msg.sender][pollId],
            "You've already voted for this poll"
        );

        candidates[_candidateId].votes += 1;
        votedForPoll[msg.sender][pollId] = true;

        emit VoteCasted(pollId, _candidateId, msg.sender);
    }
}
