module.exports = {
    extends: ["next/core-web-vitals"],
    ignorePatterns: ["node_modules/"],
    parser: "@typescript-eslint/parser",
    parserOptions: {
      project: ["tsconfig.json"],
      tsconfigRootDir: __dirname,
      sourceType: "module",
    },
    plugins: ["@typescript-eslint"],
    rules: {
      "@next/next/no-html-link-for-pages": [
        "error",
        ["apps/admin/pages/", "apps/partners/pages/", "apps/web/pages/"],
      ],
      "no-unused-vars": "off",
      "prefer-const": "warn",
      "no-duplicate-imports": ["warn", { includeExports: false }],
      "react-hooks/rules-of-hooks": "error",
      "react-hooks/exhaustive-deps": "warn",
      "@typescript-eslint/no-unsafe-argument": "warn",
      "@typescript-eslint/no-unsafe-member-access": "warn",
      "@typescript-eslint/no-explicit-any": "warn",
      "@typescript-eslint/no-unused-vars": [
        "warn",
        {
          vars: "all",
          args: "after-used",
          ignoreRestSiblings: true,
          argsIgnorePattern: "^_",
          varsIgnorePattern: "^_",
        },
      ],
      "@typescript-eslint/ban-types": [
        "warn",
        {
          extendDefaults: true,
          types: {
            object: false,
            "{}": false,
          },
        },
      ],
      "@typescript-eslint/no-unnecessary-condition": "warn",
    },
  };
  