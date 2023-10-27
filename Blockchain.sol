// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Blockchain {
    // Contract code goes here
    address internal teacher;
    uint public tuitionAmount = 1 ether; // Tuition fee is set to 1 ether
    enum Specializations { DataScience, EnterpriseSystems, InteractiveMultimedia }
    Specializations constant defaultChoice = Specializations.DataScience;

    struct Student {
        uint idnumber;
        string name;
        uint grade;
        Specializations specialization;
        bool hasPaidTuition;
    }

    mapping(address => Student) public students;

    modifier isTeacher() {
        require(msg.sender == teacher, "You are not the teacher!");
        _;
    }

    modifier isStudent() {
        require(msg.sender != teacher, "Teachers cannot perform this transaction!");
        _;
    }

    constructor() {
        teacher = msg.sender;
    }

    function transferToES() public isStudent {
        students[msg.sender].specialization = Specializations.EnterpriseSystems;
    }

    function submit(string memory _name) public isStudent {
        students[msg.sender].name = _name;
    }

    function enroll (uint _id) public isStudent {
        students[msg.sender].idnumber = _id;
    }

    function addGrade (address _student, uint _grade) public isTeacher {
        students[_student].grade = _grade;
    }

    function viewTeacher() external view returns(address) {
        return teacher;
    }

    function payTuition() public payable isStudent {
        require(students[msg.sender].hasPaidTuition == false, "Tuition has already been paid.");
        require(msg.value >= tuitionAmount, "Insufficient payment for tuition.");

        students[msg.sender].hasPaidTuition = true;
    }

     function withdrawFunds() public payable isStudent{
        require(address(this).balance>0, "No funds available for withdrawal.");
        payable(teacher).transfer(address(this).balance);
    }

} // Blockchain
