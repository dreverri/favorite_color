Application demonstrating the use of Riak for session storage,
identity management, and access control.

## Session Storage

Use the Riak session storage functionality included in the ripple gem.

## Identity Management

Use Omniauth to allow users to login from 3rd party sites (facebook,
twitter, linkedin, github, etc.). Authenticated users are stored in
Riak.

## Access Control

Use rack-oauth2-server to allow clients to access user data via OAuth
2.0.
