// SPDX-License-Identifier: AZ Chain
pragma solidity ^0.8.11;
import './model/Candidate.sol';
import './model/Voter.sol';

contract Voting {

    address public contractOwner;
    Candidate[] public candidateList;
    Candidate public winner;
    uint public winnerVotes;

    Voter[] public voterList;

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

    function startVoting() OnlyOwner public {
        status = votingStatus.Running;
    }


    function closeVoting() OnlyOwner public {
        status = votingStatus.Completed;
    }

    function inviteVoter(address _address, string memory _email) OnlyOwner public {

        require(!isVoterPresent(_address), "Voter Already Present");

        Voter memory newVoter = Voter({
        __address: _address,
        email: _email,
        hasVoted: false
        });

        voterList.push(newVoter);
    }

    function registerCandidate(address _address, string memory _email, string memory _description) OnlyOwner public {

        require(!isCandidatePresent(_address), "Candidate Already Present");

        Candidate memory newCandidate = Candidate({
        __address: _address,
        email: _email,
        description: _description,
        votes: 0,
        added: true
        });

        candidateList.push(newCandidate);
    }

    function vote(address _candidateAddress) public {
        require(isCandidatePresent(_candidateAddress), "Not a Valid Candidate");
        require(isVoterPresent(msg.sender), "you weren't invited");
        require(!hasVoted(msg.sender), "You had already voted");
        require(status == votingStatus.Running, "Election is not active");
        for (uint i = 0; i < candidateList.length; i++) {
            if(candidateList[i].__address == _candidateAddress) {
                candidateList[i].votes += 1;
                setHasVoted(msg.sender);
            }
        }
    }

    function setHasVoted(address _voter) private {
        for (uint i = 0; i < voterList.length; i++) {
            if (voterList[i].__address == _voter) {
                voterList[i].hasVoted = true;
            }
        }
    }

    function hasVoted(address _voter) view private returns (bool) {
        for (uint i = 0; i < voterList.length; i++) {
            if (voterList[i].__address == _voter) {
                return voterList[i].hasVoted;
            }
        }
        return false;
    }

    function isCandidatePresent(address _candidate) view private returns (bool) {
        for (uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i].__address == _candidate) {
                return true;
            }
        }
        return false;
    }

    function isVoterPresent(address _voter) view private returns (bool) {
        for (uint i = 0; i < voterList.length; i++) {
            if (voterList[i].__address == _voter) {
                return true;
            }
        }
        return false;
    }

}