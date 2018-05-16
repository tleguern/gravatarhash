GRAVATARHASH(1) - General Commands Manual

# NAME

**gravatarhash** - Generate an avatar URL from an email address

# SYNOPSIS

**gravatarhash**
\[**-fs**]
\[**-d**&nbsp;**default**]
\[**-h**&nbsp;**md5**&nbsp;|&nbsp;**sha256**]
\[**-p**&nbsp;**dns**&nbsp;|&nbsp;**gravatar**&nbsp;|&nbsp;**libravatar**]
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

**-d**

> Specify what to do if the avatar doesn't exist.  Can be 404, mm, blank,
> retro or absolutely anything.

**-f**

> Enable the forcedefault flag.

**-h**

> Use either
> md5
> or
> sha256
> for the hash creation.

**-p**

> Only use the specified avatar provider.

**-s**

> Use the HTTPS URL instead of the default one.

# SEE ALSO

md5(1)

OpenBSD 6.3 - August 19, 2014
