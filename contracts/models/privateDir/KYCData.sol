// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.27;

struct KYCData {
    // User platform data
    uint256 id;
    string email;
    address wallet;
    // User document data
    string fullName;
    string name;
    string secondName;
    string lastName;
    string secondLastName;
    uint256 birthDate;
    string nationality;
    string documentType;
    string documentNumber;
    string countryOfNationality;
    // User residence data
    string countryOfResidence;
    string city;
    string residenceAddress;
    string postalCode;
}
