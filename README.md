[![Test](https://github.com/ybiquitous/npm-audit-fix-action/actions/workflows/test.yml/badge.svg)](https://github.com/ybiquitous/npm-audit-fix-action/actions/workflows/test.yml)

# `npm audit fix` Action

This action runs [`npm audit fix`](https://docs.npmjs.com/cli/audit) and creates a pull request.

## Usage

For example, you can add this action by creating [`.github/workflows/npm-audit-fix.yml`](.github/workflows/npm-audit-fix.yml):

```yaml
name: npm audit fix

on:
  schedule:
    - cron: "0 0 * * *"
  workflow_dispatch:

jobs:
  npm-audit-fix:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v3
      - uses: ybiquitous/npm-audit-fix-action@v6
```

### Inputs

| Name             | Description                          | Default                                        |
| ---------------- | ------------------------------------ | ---------------------------------------------- |
| `github_token`   | GitHub token                         | `${{ github.token }}`                          |
| `github_user`    | GitHub user name for commit changes  | `${{ github.actor }}`                          |
| `github_email`   | GitHub user email for commit changes | `${{ github.actor }}@users.noreply.github.com` |
| `branch`         | Created branch                       | `npm-audit-fix-action/fix`                     |
| `default_branch` | Default branch                       | n/a                                            |
| `commit_title`   | Commit and PR title                  | `build(deps): npm audit fix`                   |
| `labels`         | PR labels (comma-separated)          | `dependencies, javascript, security`           |
| `assignees`      | PR assignees (comma-separated)       | n/a                                            |
| `npm_args`       | Arguments for the `npm` command      | n/a                                            |
| `path`           | Path to the project root directory   | `.`                                            |

See [`action.yml`](action.yml).

### Using a personal access token

If you want to run your CI with pull requests created by this action, you may need to set your [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) instead of the GitHub's default token:

For example:

```yaml
with:
  github_token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
```

The reason is that the default token does not have enough permissions to trigger CI.
See also the [GitHub document](https://docs.github.com/en/actions/configuring-and-managing-workflows/authenticating-with-the-github_token#permissions-for-the-github_token) about the token permissions.

## Screenshot

![A pull request created by npm-audit-fix-action](screenshot.png)

## License

This project is licensed under the MIT License - see the original repository for details.

## Credits

This is based on the excellent work by [ybiquitous](https://github.com/ybiquitous) in the [npm-audit-fix-action](https://github.com/ybiquitous/npm-audit-fix-action) repository.

# Docker Version of npm-audit-fix-action

This is a Docker version of [ybiquitous/npm-audit-fix-action](https://github.com/ybiquitous/npm-audit-fix-action) that supports Node.js 22 and npm 11, which are not yet supported by GitHub Action runners.

This Docker version is available as a fork at [base64ai/npm-audit-fix-action](https://github.com/base64ai/npm-audit-fix-action) in the `docker` branch.

## Overview

This Docker container performs the same functionality as the original GitHub Action:

1. Runs `npm audit fix` on your repository
2. Creates a pull request with the fixes

## Runtime Information

- **Node.js**: v22.x (Alpine)
- **npm**: v11.x

## Usage

### Using Docker Directly

```bash
# Clone the repository
git clone -b docker https://github.com/base64ai/npm-audit-fix-action.git
cd npm-audit-fix-action

# Build the Docker image
docker build -t npm-audit-fix .

# Run the Docker container
docker run -it --rm \
  -v $(pwd):/github/workspace \
  -w /github/workspace \
  -e GITHUB_TOKEN=your_github_token \
  -e GITHUB_REPOSITORY=owner/repo \
  -e GITHUB_ACTOR=your_github_username \
  -e GITHUB_SERVER_URL=https://github.com \
  npm-audit-fix
```

### Using Pre-built Docker Image

You can also use the pre-built Docker image from GitHub Container Registry:

```bash
docker run -it --rm \
  -v $(pwd):/github/workspace \
  -w /github/workspace \
  -e GITHUB_TOKEN=your_github_token \
  -e GITHUB_REPOSITORY=owner/repo \
  -e GITHUB_ACTOR=your_github_username \
  -e GITHUB_SERVER_URL=https://github.com \
  ghcr.io/base64ai/npm-audit-fix-action:docker
```

### Using Docker Compose

1. Set up environment variables:

```bash
export GITHUB_TOKEN=your_github_token
export GITHUB_REPOSITORY=owner/repo
export GITHUB_ACTOR=your_github_username
```

2. Run with Docker Compose:

```bash
docker-compose up
```

## Configuration

The Docker container accepts the same inputs as the original GitHub Action:

| Input             | Description                          | Default                                  |
| ----------------- | ------------------------------------ | ---------------------------------------- |
| `GITHUB_TOKEN`    | GitHub token                         | Required                                 |
| `GITHUB_USER`     | GitHub user name for commit changes  | `$GITHUB_ACTOR`                          |
| `GITHUB_EMAIL`    | GitHub user email for commit changes | `$GITHUB_ACTOR@users.noreply.github.com` |
| `BRANCH`          | Created branch                       | `npm-audit-fix-action/fix`               |
| `DEFAULT_BRANCH`  | Default branch                       | Auto-detected                            |
| `COMMIT_TITLE`    | Commit and PR title                  | `build(deps): npm audit fix`             |
| `LABELS`          | PR labels (comma-separated)          | `dependencies, javascript, security`     |
| `ASSIGNEES`       | PR assignees (comma-separated)       | None                                     |
| `NPM_ARGS`        | Arguments for the `npm` command      | None                                     |
| `PATH_TO_PROJECT` | Path to the project root directory   | `.`                                      |

## Example in GitHub Actions

You can still use this in your GitHub Actions workflow by using the Docker container:

```yaml
name: npm audit fix with Node.js 22 and npm 11

on:
  schedule:
    - cron: "0 0 * * *" # Run daily at midnight
  workflow_dispatch: # Allow manual trigger

jobs:
  npm-audit-fix:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Needed for creating PRs

      - name: Run npm audit fix with Node.js 22 and npm 11
        run: |
          docker run -i --rm \
            -v ${{ github.workspace }}:/github/workspace \
            -w /github/workspace \
            -e GITHUB_TOKEN=${{ secrets.GITHUB_TOKEN }} \
            -e GITHUB_REPOSITORY=${{ github.repository }} \
            -e GITHUB_ACTOR=${{ github.actor }} \
            -e GITHUB_SERVER_URL=${{ github.server_url }} \
            -e GITHUB_RUN_ID=${{ github.run_id }} \
            ghcr.io/base64ai/npm-audit-fix-action:docker
```
