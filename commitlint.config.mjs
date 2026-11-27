// Enforces the commit format from the project spec: Conventional Commits
// with a required, known scope and a short imperative description.
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'scope-empty': [2, 'never'],
    'scope-enum': [
      2,
      'always',
      [
        'gno-dart',
        'keystore',
        'vault-realm',
        'wallet-app',
        'tools',
        'repo',
        'ci',
        'release',
      ],
    ],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-max-length': [2, 'always', 72],
    'body-max-line-length': [2, 'always', 72],
  },
};
