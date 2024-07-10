# DLT Tools: Business Smart Contracts

## Branch rule naming:

[feat/bug][YY][MM]/[jira-id]-[jira issue title]

feat - for features
bug - for bugs/fixes
YY - year in 2 digits
MM - month in 2 digits
jira-id - jira identificator of issue like ROSC-17

Example of branch name:
feat2308/rosc-17-login-page

## PullRequest rule naming:

Get it from issue in Jira with identificator and put it like "JIRA-ID: Issue Title".

Example of PR name:

BM-17: Login page

## How link libraries in testing

    const DLTStrings = await ethers.getContractFactory('DLTStrings');
    const roStrings = await DLTStrings.deploy();

    const DLTRoleManager = await ethers.getContractFactory('DLTRoleManager', {
      libraries: {
        DLTStrings: roStrings.target,
      },
    });

## How to use console for testing

In .sol file:
1. import 'hardhat/console.sol';
2. console.log('7. BLACKLIST_MANAGER_ROLE %s', DLTStrings.iToHex(roleHash));

## Test only one file

yarn t ./test/DLTRoleManager.ts

## Test all

yarn t

# How to local deploy

1. In one terminal execute: yarn n
2. In second terminal execute: yarn dl

# How to update solc:

1. npx solc --version
2. npm update solc
3. npm install solc@<versión específica> --save-dev
4. 