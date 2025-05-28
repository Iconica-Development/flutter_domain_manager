# Flutter domain manager

Easily add subdomain specific logic in your Flutter web app

## Setup
Add to `pubspec.yaml`

```
flutter_domain_manager: ^0.0.4
```

## Using
Call this somewhere in the beginning of your code, in the example it is called in `main.dart` inside `main()` before `runApp()`. It could be placed somewhere else.

```
DomainManager.register(
  config: DomainManagerConfig(
    domain: "https://app.iconica.nl/",
    allowedCompanies: ["iconica"],
    debugCompany: "iconica",
  ),
);
```

`domain`: Root domain where the base app is hosted, used for validation and redirection

`allowedCompanies`: List of allowedCompanies, if empty anything is allowed.

`debugCompany`: Used for development, since the Flutter debugger doesn't act great when adding a subdomain to `localhost`

## Attention
To use this in production more setup is required, look at [app_server](https://github.com/Iconica-Development/app_server) for more information

# Motivation
The motivation behind this package in one sentence is:
```
Easily support multi tenancy in your Flutter web app with minimal deployments and DNS changes
```

For our application we want to offer multi-tenancy as a feature, this should be achieved in the easiest way possible.
We DON'T want to have to do the following:
- Set up `N` amount of clients
- Add lots of DNS records
- Manage lots of subdomains

This package in combination with [this](https://github.com/Iconica-Development/app_server)
Allows you to have multi-tenant support whilst only having to add 2 DNS records.

The primary use case for this will be with Firebase APP hosting, since this allow wildcard subdomains (Firebase hosting does not allow this).

### Setup
- Create a Flutter site
- Use [flutter_domain_manager](https://github.com/Iconica-Development/flutter_domain_manager) for retrieving the proper tenant and configuring it
- Setup app server inside the project
- Initialize and create the app hosting backend with the command under `Deploying`
- Add the following custom domains to your backend service:
    - *.iconica.nl
    - iconica.nl

This last step can be personalized, so an already defined subdomain can be setup:
- *.app.iconica.nl
- app.iconica.nl

Also environments could be added in this way:
- *.app.staging.iconica.nl
- app.staging.iconica.nl

So, lots of possibilities!