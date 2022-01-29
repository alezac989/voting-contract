// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

contract Voting {
    address public contractOwner;
    address[] public candidateList;

    mapping(address => uint8) public votesReceived;

    address public winner;
    uint public winnerVotes;

    enum votingStatus {NotStarted, Running, Completed}
    votingStatus public status;

    constructor() {
        contractOwner = msg.sender;
        status = votingStatus.NotStarted;
    }

    modifier OnlyOwner {
        if (msg.sender == contractOwner) {
            _;
        }
    }

    function setStatus() OnlyOwner public {
        if (status != votingStatus.Completed && status != votingStatus.Running) {
            status = votingStatus.Running;
        } else {
            status = votingStatus.Completed;
        }
    }

    function registerCandidates(address _candidate) OnlyOwner public {
        candidateList.push(_candidate);
    }

    function vote(address _candidate) public {
        require(validateCandidate(_candidate), "Not a Valid Candidate");
        require(status == votingStatus.Running, "Election is not active");
        votesReceived[_candidate] = votesReceived[_candidate] + 1;
    }

    function validateCandidate(address _candidate) view public returns (bool) {
        for (uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == _candidate) {
                return true;
            }
        }
        return false;
    }

    function votesCount(address _candidate) public view returns (uint) {
        require(validateCandidate(_candidate), "Not a Valid Candidate");
        assert(status == votingStatus.Running);
        return votesReceived[_candidate];
    }

    function result() public {
        require(status == votingStatus.Completed, "Voting is not completed, Result cannot be decleared");
        for (uint i = 0; i < candidateList.length; i++) {
            if (votesReceived[candidateList[i]] > winnerVotes) {
                winnerVotes = votesReceived[candidateList[i]];
                winner = candidateList[i];
            }
        }
    }
}