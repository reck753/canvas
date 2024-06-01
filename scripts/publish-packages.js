const { execSync } = require("child_process");

// List of package names you want to publish
const packagesToPublish = [
  "packages/rescript-uuid",
  "packages/utils",
  "packages/canvas",
  // Add more packages as needed
];

try {
  console.log("Updating version for all packages...");
  execSync("yarn lerna version --yes --no-push", { stdio: "inherit" });

  packagesToPublish.forEach(pkg => {
    console.log(`Publishing ${pkg}...`);
    execSync(`yarn lerna exec --scope=${pkg} -- npm publish`, {
      stdio: "inherit",
    });
    console.log(`${pkg} published successfully.`);
  });
} catch (error) {
  console.error("Failed to publish packages:", error);
}
