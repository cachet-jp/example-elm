# Elm Example Project

This project is an example demonstrating how to set up an Elm project using Nix, dream2nix, elm-watch, and esbuild.

## Prerequisites

- Nix package manager installed on your system

## Getting Started

1. Clone this repository:

   ```shell
   git clone https://github.com/cachet-jp/example-elm.git
   cd elm-example
   ```

2. Enter the development environment:

   ```shell
   nix develop
   ```

   This will set up the necessary dependencies, including Elm, elm-test, elm-format, and elm-language-server.

3. Start the development server:

   ```shell
   nix run .#dev
   ```

   This project uses `elm-watch` for the development server. Please note that the version of `elm-watch` used in this project is a beta version (v2.0.0-beta.2) which includes a built-in development server. It will compile your Elm code and start a development server with hot reloading. The development server port is automatically assigned, so please access the URL displayed in the command line.

## Building for Production and Running

To build your Elm project for production and start the server, run:

```shell
nix run
```

This command not only builds the project but also starts the production server. This project uses `esbuild` as the module bundler for production builds. The optimized output will be available in the `result/public/build` directory.

## Updating elm-srcs.nix

If you add or remove Elm dependencies, you'll need to update the `elm-srcs.nix` file. To do this, run:

```shell
nix run .#elm2nix
```

This will regenerate the `elm-srcs.nix` file based on your current dependencies.

## Pre-commit Hooks

This project uses pre-commit hooks to ensure consistent formatting and styling. The hooks are managed by `nix-pre-commit-hooks` and include:

- `alejandra`: A Nix code formatter
- `elm-format`: An Elm code formatter

The hooks will automatically run before each commit.
