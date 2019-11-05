# Okta Flutter App

Proof of concept for Okta integration with a Flutter app.

### Authentication API

On the `master` branch I've integrated using Authentication API:
https://developer.okta.com/docs/reference/api/authn/

This is actually quite useless unless you are simply trying to validate the user is in your Okta organization and/or you need their profile fields. It returns a sessionToken rather than an accessToken. The accessToken (or JWT) is generally what you would need when communicating with an exernal API.

### Open ID Connect

The `openid-connect` branch has an authentication flow using Open ID Connect. Although this is functional, the UX feels very clunky.

### grant_type: password

The `password` branch works basically like the /authenticate endpoint, except it returns a JWT. This is called the Resource Owner Password Flow: https://developer.okta.com/docs/guides/implement-password/overview/

You'll need to set up your Okta oAuth Application support mobile apps, which defaults to a PKCE exchange. Then you can use `grant_type: password` with the token endpoint https://developer.okta.com/docs/reference/api/oidc/#token. Example: `https://yourapp.oktapreview.com/oauth2/{client_id}/v1/token`.

Okta recommends against this method if more secure methods exist.

More on security:
https://www.identityserver.com/articles/fact-sheet-the-dangers-of-using-the-password-grant-type-with-mobile-applications
