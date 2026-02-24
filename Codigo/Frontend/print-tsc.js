const { execSync } = require("child_process");

try {
  const output = execSync("npx tsc -b", { encoding: "utf-8", stdio: "pipe" });
  console.log(output);
} catch (error) {
  console.log(error.stdout);
}
