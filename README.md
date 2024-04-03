# Elm Example Project

This project is an example demonstrating how to set up an Elm project using Nix, dream2nix, elm-watch, and esbuild.

## Prerequisites

- Nix package manager installed on your system
- direnv installed on your system

## Getting Started

1. Clone this repository:

   ```shell
   git clone https://github.com/cachet-jp/example-elm.git
   cd elm-example
   ```

2. Allow direnv to load environment variables:

   ```shell
   direnv allow && direnv allow ./terranix
   ```

This command allows direnv to load the environment variables defined in the .envrc files located in the project root directory and the terranix directory. By running this command, you can automatically enter the development environment when navigating to these directories, eliminating the need to manually run nix develop each time.

3. Enter the development environment:

   ```shell
   nix develop
   ```

   This will set up the necessary dependencies, including Elm, elm-test, elm-format, and elm-language-server.

4. Start the development server:

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

## Environment Setup

Follow these steps to set up the environment and deploy the application:

1. Generate the Docker image by running: ```nix build .#docker ```
1. Load the generated Docker image: ```docker load -i result ```
1. Tag the Docker image, replacing $LOCATION and $PROJECT_ID with the appropriate values: ```docker tag exampleelm:latest $LOCATION-docker.pkg.dev/$PROJECT_ID/container/exampleelm:latest ```
1. Push the Docker image: ```docker push $LOCATION-docker.pkg.dev/$PROJECT_ID/container/exampleelm:latest ```
1. Change the current directory to the terranix/ directory: ```cd terranix/ ```
1. Enter the development shell using: ```nix develop ```
1. Modify the terranix/config.nix file to match your environment and configure the backend for OpenTofu before running the apply command.
1. Update the env argument passed to terraformConfiguration in the terranix/flake.nix file to match the desired environment (dev or prod) based on your updated terranix/config.nix configuration.
1. Log in to Google Cloud SDK and set up the application default credentials for OpenTofu: ```gcloud auth application-default login ```
1. Update the image field in the google_cloud_run_v2_service.default resource within the terranix/config.nix file to reference the Docker image URL pushed in step 4.
1. Build the Google Cloud environment using OpenTofu by running: ```nix run .#terraform-dev apply ```

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
