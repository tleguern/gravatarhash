gravatarhash
============

The gravatarhash utility processes the given email address into an URL
pointing to an avatar image.

Three providers are currently supported:

*   Gravatar (https://secure.gravatar.com/);
*   Libreavatar (https://www.libravatar.org/);
*   self hosted people (SRV DNS query).

The default is to do a DNS query first and fallback to Gravatar if the
query fails.

