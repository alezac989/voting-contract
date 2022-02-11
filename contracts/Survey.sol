// SPDX-License-Identifier: AZ Chain
pragma solidity ^0.8.11;

contract Survey {

    address public contractOwner;

    mapping(address => bool) public canVoteMap;

    string question;

    string[] public answerList;

    mapping(string => uint8) public votesReceived;

    struct ResultDto {
        string answer;
        uint8 votes;
    }

    constructor(string memory _question, string[] memory _answerList) {
        contractOwner = msg.sender;
        question = _question;
        answerList = _answerList;
    }

    modifier OnlyOwner {
        if (msg.sender == contractOwner) {
            _;
        }
    }

    function addVoter(address _voterAddress) OnlyOwner public {
        canVoteMap[_voterAddress] = true;
    }

    function canVote(address _voterAddress) view public returns (bool) {
        return canVoteMap[_voterAddress];
    }

    function isValidAnswer(string memory _answer) view public returns (bool) {
        for (uint i = 0; i < answerList.length; i++) {
            if (keccak256(bytes(answerList[i])) == keccak256(bytes(_answer))) {
                return true;
            }
        }
        return false;
    }

    function vote(string memory _answer) public {
        require(canVote(msg.sender), "Not a valid voter");
        require(isValidAnswer(_answer), "Not a valid answer");
        votesReceived[_answer] = votesReceived[_answer] + 1;
    }

}
