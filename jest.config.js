process.env.TZ = "CET"; // Make sure the tests are run in the same time zone, but not GMT

module.exports = {
  moduleFileExtensions: ["js", "mjs", "ts"],
  testMatch: ["**/__tests__/**/*_test.mjs", "**/__tests__/**/*_test.bs.js"],
  transform: {
    "^.+.m?js$": "babel-jest",
    "^.+.bs.m?js$": "babel-jest",
    "^.+.ts$": "ts-jest",
  },
  transformIgnorePatterns: [
    "node_modules/(?!(@glennsl/rescript-jest|rescript|@rescript/core)/)",
  ],
  testTimeout: 25000,
};
