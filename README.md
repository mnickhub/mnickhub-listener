# mnickhub-listener
mnickhub-listener for automation on new repos in mnickhub.

## Overview

Currently this service is set up as a GitHub App for only the organization `mnickhub` and only run locally. It will protect the `main` branch on any new repo created with a README.md (or other file). It also creates an issue on that new repo alerting `@mikelnick` of the branch protections added.

### Main Branch Protections
Detailed options can be found on GitHub's [enabling and disabling branch protection](https://docs.github.com/en/rest/reference/repos#enabling-and-disabling-branch-protection) document.

```
{
    required_status_checks: {
        strict: true,
        contexts: []
    },
    enforce_admins: true,
    required_pull_request_reviews: {
        dismissal_restrictions: {},
        dismiss_stale_reviews: true,
        require_code_owner_reviews: true
    },
    restrictions: {
        users: ['mikelnick'],
        teams: []
    }
}
```

## Assumptions for Use

* Have read document on running [GitHub Apps locally](https://docs.github.com/en/developers/apps/getting-started-with-apps/setting-up-your-development-environment-to-create-a-github-app#step-2-register-a-new-github-app) and followed set up instructions.
* `smee` is used while running this application for local execution with the GitHub organization `mnickhub`.

## Install

To run the code, make sure you have [Bundler](http://gembundler.com/) installed; then enter `bundle install` on the command line.

## Set environment variables

1. Add the GitHub App's private key, app ID, and webhook secret to the `template.env` file and rename it to `.env`.
2. `Note`: for local run, also add a WEBHOOK_PROXY_URL to point to your smee endpoint.


## Run the server

### Ruby

1. Run `bundle exec ruby listener_server.rb` on the command line.
2. View the default Sinatra app at `localhost:3000`.

### Docker
These commands assume Mac usage.

1. Build the image locally - `docker build -t mnickhub-listener:demo .`
2. `docker run -p 3000:3000 -v $(pwd)/.env:/app/.env mnickhub-listener:demo`
3. View the default (docker) Sinatra app at `localhost:3000`.

# Deployment Options (Advanced)

This section is high level guide on how to run this service in a production environment.

## Requirements
* Secret management solution and user can use secrets with applications.
* Network routing is standardized in a way that user knows how to map ports at a minimum with ingress from the public internet to reach this application.
* User supplied pipeline exists and or user is familiar with deploying applications.

## Container Orchestrator
1. Run docker build in pipeline and publish image to image registry of choice.
2. Image should be scanned as appropriate for security standards by Snyk or tooling of choice.
3. Deploy image to container orchestration platform. Ensure that environment variables are sourced from secret management solution and set as platform allows. Need these values set:
    * GITHUB_PRIVATE_KEY
    * GITHUB_APP_IDENTIFIER
    * GITHUB_WEBHOOK_SECRET
4. There will need to be an ingress from the public internet to reach your service.

## AWS ApiGateway with Lambda

```
This method will require user refactoring but showing the high level steps required to make it work.
```

1. Read or know how to use implement [AWS Lambda with Amazon API Gateway](https://docs.aws.amazon.com/lambda/latest/dg/services-apigateway.html). Be sure to look over supported [lambda](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) runtimes for Ruby. There are quick start guides for Micorservices in AWS with API Gateway and Lambda.
2. Add an api route that triggers the lambda with a handler.
3. Rework is required to make the methods supplied in lister_service.rb function from the context of the new lambda.

# Credits

* [Building new GitHub Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/setting-up-your-development-environment-to-create-a-github-app#step-2-register-a-new-github-app)
* [github-app-template](https://github.com/github-developer/github-app-template)
* [Octokit.rb docs](https://www.rubydoc.info/gems/octokit/Octokit%2FClient%2FRepositories:protect_branch)