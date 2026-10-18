# Releasing

Releases are automated with [release-please](https://github.com/googleapis/release-please).

1. Use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages or squash-merge PR titles:
   - `fix: …` creates a patch release (2.0.1)
   - `feat: …` creates a minor release (2.1.0)
   - `feat!: …`, or a `BREAKING CHANGE:` footer, creates a major release (3.0.0)
   - `docs:`, `ci:`, `chore:`, `test:` and `refactor:` don't create a release
2. After each push to `master`, the **Release** workflow opens or updates a PR titled `chore(master): release X.Y.Z`. It updates `CHANGELOG.md` and `version.txt`.
3. Merging that PR creates the tag `X.Y.Z` (no `v` prefix, as Swift Package Manager expects) and a GitHub Release.

The first release is **2.0.0**. It's set by `initial-version` in `release-please-config.json` and by the `Release-As: 2.0.0` footer of the commit that added this automation.

To force a specific version, add a `Release-As: X.Y.Z` footer to a commit message.

## Required CI on release PRs

`master` requires status checks. GitHub doesn't run workflows for PRs that are created or updated with the default `GITHUB_TOKEN`. To have CI run automatically on release PRs, add a repository secret named `RELEASE_PLEASE_TOKEN`. It can be either:

- A fine-grained personal access token for this repository with **Contents: Read and write** and **Pull requests: Read and write** (add **Issues: Read and write** for labels).
- A GitHub App installation token with the same permissions.

Without the secret, the workflow falls back to `GITHUB_TOKEN`. The release PR is still created, but you have to start CI by hand: close and reopen the release PR.
