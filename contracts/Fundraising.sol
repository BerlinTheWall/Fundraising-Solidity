// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract Fundraising is  Context, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    mapping(address => uint256) public contributors; // ['0x...' -> 1000wei]
    address public admin; // contract owner
    Counters.Counter public noOfContributors;
    uint256 public minimumContribution;
    uint256 public deadline;
    uint256 public goal;
    uint256 public raisedAmount;

    // events to emit
    event ContributeEvent(address _sender, uint _value);
 
    constructor(uint256 _goal, uint256 _minContr, uint256 _deadline) {
        admin = _msgSender();
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = _minContr;
    }

    function setGoal(uint256 _goal) public onlyOwner {
        goal = _goal;
    }

    function setDeadline(uint256 _deadline) public onlyOwner{
        require(_deadline > 0, "Invalid time");
        deadline = block.timestamp + _deadline;
    }

    // function contribute() public payable {
    //     require(block.timestamp < deadline, "The Deadline has passed!");
    //     uint256 _amount = 0.0001 ether;
    //     payable(address(this)).transfer(_amount);
    //     if(contributors[_msgSender()] == 0) {
    //         noOfContributors.increment();
    //     }
    //     contributors[_msgSender()] += _amount;
    //     raisedAmount += _amount;
    //     emit ContributeEvent(_msgSender(), _amount);
    // }

    receive() payable external {
        require(block.timestamp < deadline, "The Deadline has passed!");
        require(msg.value >= minimumContribution, "The Minimum Contribution has not met!");
        if(contributors[msg.sender] == 0) {
            noOfContributors.increment();
        }
        contributors[_msgSender()] += msg.value;
        raisedAmount += msg.value;
        
        emit ContributeEvent(_msgSender(), msg.value);
    }

    function getAdmin() public view returns(address) {
        return admin;
    }

    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
    
    function getAddress() public view returns(address) {
        return address(this);
    }

    function getGoal() public view returns(uint256) {
        return goal;
    }

    function getDeadline() public view returns(uint256) {
        return deadline;
    }

    function getMinContribute() public view returns(uint256) {
        return minimumContribution;
    }

    function getRaisedAmount() public view onlyOwner returns(uint256) {
        return raisedAmount;
    }

    function getNoOfContribute() public view returns(uint256) {
        return noOfContributors.current();
    }

    function getContributors(address contributor) public view onlyOwner returns (uint256) {
        return contributors[contributor];
    }
}
