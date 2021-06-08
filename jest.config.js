const { jestConfig } = require("@salesforce/sfdx-lwc-jest/config");

const setupFilesAfterEnv = jestConfig.setupFilesAfterEnv || [];
setupFilesAfterEnv.push("<rootDir>/jest.setup.js");

const coverageThreshold = jestConfig.coverageThreshold || {};
coverageThreshold.global = {
    branches: 100,
    functions: 100,
    lines: 100,
    statements: 0,
};

module.exports = {
    ...jestConfig,
    moduleNameMapper: {},
    testPathIgnorePatterns: ["force-app/main/default/lwc/__(tests|mocks)__/"],
    reporters: ["default"],
    setupFilesAfterEnv: setupFilesAfterEnv,
    coverageThreshold: coverageThreshold,
};
