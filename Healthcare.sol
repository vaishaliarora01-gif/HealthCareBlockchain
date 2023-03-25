pragma solidity ^0.8.0;

contract Healthcare {

    // Medical Record structure
    struct MedicalRecord {
        string patientName;
        string diagnosis;
        string medication;
        uint timestamp;
    }

    // Patient structure
    struct Patient {
        string name;
        mapping(uint => MedicalRecord) medicalRecords;
        bool isPaid;
    }

    // Doctor structure
    struct Doctor {
        string id;
        string name;
        string speciality;
    }

    // Mapping to store patient information
    mapping(address => Patient) public patients;

    // Mapping to store doctor information
    mapping(address => Doctor) public doctors;

    // Function to Register Doctor
    function registerDoctor(string memory _id, string memory _name, string memory _speciality) public {
        doctors[msg.sender] = Doctor(_id, _name, _speciality);
    }

    // Function to make payment
    function makePayment() public payable {
        Patient storage patient = patients[msg.sender];
        require(patient.isPaid == false, "payment already made");
        require(keccak256(abi.encodePacked(patient.name)) != keccak256(abi.encodePacked("")), "Patient not registered");
        patient.isPaid = true;
    }

    // Function to add medical record
    function addMedicalRecord(uint _medicalRecordId, address patientAddress, string memory _patientName, string memory _diagnosis, string memory _medication) public {
    // only doctor can add medical record
    Doctor memory doctor = doctors[msg.sender];
    require(bytes(doctor.id).length > 0, "Only doctor can add medical record.");
    // paitent id should be valid
    Patient storage patient = patients[patientAddress];
    require(patient.medicalRecords[_medicalRecordId].timestamp == 0, "Medical ID Invalid");
    uint timestamp = block.timestamp;
    MedicalRecord memory record = MedicalRecord(_patientName, _diagnosis, _medication, timestamp);
    patient.medicalRecords[_medicalRecordId] = record;
    patient.name = _patientName;
}

    // Function to get medical record
    function getMedicalRecord(address _patientAddress, uint _patientId) public view returns (string memory, string memory, string memory, uint) {
        Patient storage patient = patients[_patientAddress];
        MedicalRecord memory record = patient.medicalRecords[_patientId];
        return (record.patientName, record.diagnosis, record.medication, record.timestamp);
    }

}
