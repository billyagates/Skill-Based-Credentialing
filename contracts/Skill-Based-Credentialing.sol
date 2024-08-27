// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SkillBasedCredentialing {

    // Course structure
    struct Course {
        string courseName;
        string instructor;
        bool exists;
    }

    // Certificate structure
    struct Certificate {
        address student;
        uint256 courseId;
        string issueDate;
        bool isIssued;
    }

    // Mapping to store courses by ID
    mapping(uint256 => Course) public courses;
    uint256 public courseCount;

    // Mapping to store certificates issued to students
    mapping(uint256 => Certificate) public certificates;
    uint256 public certificateCount;

    // Mapping to track which instructor is authorized to issue certificates for a course
    mapping(uint256 => address) public courseInstructor;

    // Events
    event CourseCreated(uint256 courseId, string courseName, string instructor);
    event CertificateIssued(uint256 certificateId, address student, uint256 courseId, string issueDate);

    // Function to create a new course (only by the owner/instructor)
    function createCourse(string memory _courseName, string memory _instructor) public {
        courseCount++;
        courses[courseCount] = Course(_courseName, _instructor, true);
        courseInstructor[courseCount] = msg.sender;

        emit CourseCreated(courseCount, _courseName, _instructor);
    }

    // Function to issue a certificate (only by authorized instructors)
    function issueCertificate(address _student, uint256 _courseId, string memory _issueDate) public {
        require(courses[_courseId].exists, "Course does not exist");
        require(courseInstructor[_courseId] == msg.sender, "Not authorized to issue certificate for this course");

        certificateCount++;
        certificates[certificateCount] = Certificate(_student, _courseId, _issueDate, true);

        emit CertificateIssued(certificateCount, _student, _courseId, _issueDate);
    }

    // Function to verify a certificate
    function verifyCertificate(uint256 _certificateId) public view returns (address student, uint256 courseId, string memory issueDate, string memory courseName, string memory instructor, bool valid) {
        Certificate memory cert = certificates[_certificateId];
        require(cert.isIssued, "Certificate does not exist");

        Course memory course = courses[cert.courseId];

        return (cert.student, cert.courseId, cert.issueDate, course.courseName, course.instructor, true);
    }
}
