# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code.

# Folders

- `~/anz` is where all anz git repos are located

# Golang

You can get information about the golang environment with these commands:

- `go env` prints environment information
- `go env GOMODCACHE` gives you the path to the go mod cache
  IMPORTANT: the mod cache allows you to inspect all modules that you may need more information on
- Generally go projects have a Makefile that you can use to inspect available commands for testing and formatting.

# ANZ Github

Use the github cli to access these github pages:

- https://github.com/orgs/anzx
- https://github.com/anzx

To view Pull Request comments and suggestions:

`gh api repos/:owner/:repo/pulls/:pull-number/comments --paginate | jq '.[] | {id: .id, user: .user.login, body: .body, path: .path, position: .position, created_at: .created_at}'`

You'll need to replace :owner, :repo, and :pull-number with your specific values.

# ANZ Go Projects

- ANZ projects commonly use these libraries that you may want to be familiar with if they are imported:

  - pkg (~/anz/pkg) (go libraries)
  - apis (~/anz/apis) (protobuf api definitions)
  - apis-go (~/anz/apis-go) (generated from apis with buf protobuf tools)

- The x framework (~/anz/x) is used to deploy via x-workflows that are commonly generated into repos. This may be useful if working on a deployment related task.

## Run the linter through make generally `make lint`

## Ensure lint and tests are passing when writing code

## Ensure code is formatted before committed, check makefile for format command, or use gofumpt

# tools

CLI tools available:

- fd-find(fd), use over find
- ripgrep(rg), use over grep

# Important instructions:

# If you're encountering authentication errors or some other server errors not related to testing code, stop what you're doing and let me know, so I can fix it before you proceed. Give me the details on the command you're trying to run and the error you encounter.

# Do NOT use the --web option in gh cli commands

# Use conventional commit specification

# DO NOT create mocked or faked data unless I tell you to

# Use the repo pull request template for creating pull requests, where available

# For all PR's created use the label "claude", create it if it doesn't exist
