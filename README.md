GRAVATARHASH(1) - General Commands Manual

# NAME

**gravatarhash** - Generate an avatar URL from an email address

# SYNOPSIS

**gravatarhash**
\[**-s**]
\[**-p**&nbsp;**dns**&nbsp;|&nbsp;**gravatar**&nbsp;|&nbsp;**libreavatar**]
*email*

# DESCRIPTION

The
**gravatarhash**
utility processes the given
*email*
address into an URL pointing to an avatar image.

Three providers are currently supported:

*	Gravatar (https://secure.gravatar.com/);
*	Libreavatar (https://www.libravatar.org/);
*	self hosted people (SRV DNS query).

The default is to do a DNS query first and fallback to Gravatar if the
query fails.

The options are as follows:

**-p**

> Only use the specified avatar provider.

**-s**

> Use the HTTPS URL instead of the default one.

# SEE ALSO

md5(1)

Linux 4.9.0-3-amd64 - August 19, 2014
