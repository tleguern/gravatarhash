#!/bin/sh
#
# Copyright (c) 2014 Tristan Le Guern <tleguern@bouledef.eu>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

set -e

readonly PROGNAME="`basename $0`"
readonly VERSION='v1.1'

usage() {
        echo "usage: $PROGNAME [-dhsV] [-p dns|gravatar|libreavatar] email"
}

version() {
        echo "$PROGNAME $VERSION"
}

sflag=0
pflag=''

tail="?d=retro"

while getopts ":dhp:sV" opt;do
	case $opt in
		d) set -x;;
		h) usage; exit 0;;	# NOTREACHED
		p) pflag=$OPTARG;;
		s) sflag=1;;
		V) version; exit 0;;	# NOTREACHED
		:) echo "$PROGNAME: option requires an argument -- $OPTARG";
		   usage; exit 1;;	# NOTREACHED
		?) echo "$PROGNAME: unkown option -- $OPTARG";
		   usage; exit 1;;	# NOTREACHED
		*) usage; exit 1;;	# NOTREACHED
	esac
done
shift $(( $OPTIND -1 ))

if [ -z "$1" ]; then
	echo "$PROGNAME: email address expected"
	usage
	exit 1
else
	email="$1"
	shift
fi

if [ $# -ge 1 ]; then
	echo "$PROGNAME: invalid trailing chars -- $@"
	usage
	exit 1
fi

[ -n "$pflag" ] && case "$pflag" in
	dns|gravatar|libreavatar) :;;
	*) usage; exit 1;;	# NOTREACHED
esac

set -u

getgravatarbaseuri() {
	ga_uri="http://www.gravatar.com/avatar"
	ga_securi="https://secure.gravatar.com/avatar"

	if [ $sflag -eq 1 ]; then
		echo $ga_securi;
	else
		echo $ga_uri;
	fi
}

getlibreavatarbaseuri() {
	la_uri="http://cdn.libravatar.org/avatar"
	la_securi="https://seccdn.libravatar.org/avatar"

	if [ $sflag -eq 1 ]; then
		echo $la_securi;
	else
		echo $la_uri;
	fi
}

getdnsbaseuri() {
	dns_domain="$( echo $1 | cut -d '@' -f 2 )"

	if [ $sflag -eq 1 ]; then
		dns_service="_avatars-sec._tcp"
	else
		dns_service="_avatars._tcp"
	fi

	if dns_ret="`dig +short $dns_service.$dns_domain -t SRV`"; then :
	else
		return 1
	fi
	if [ -z "$dns_ret" ]; then
		return 1
	fi
	# TODO: Check priority and weight

	# Clean up the trailing dot
	dns_ret="`echo $dns_ret|rev|cut -d'.' -f2-|rev`"
	echo "$dns_ret/avatar" | cut -d ' ' -f 4
}

# If asked, use the specific provider. If not do a DNS request and
# fallback to gravatar.
case "$pflag" in
	dns) baseuri=$( getdnsbaseuri $email );;
	libreavatar) baseuri=$( getlibreavatarbaseuri );;
	gravatar) baseuri=$( getgravatarbaseuri );;
	*) baseuri=$( getdnsbaseuri $email || getgravatarbaseuri );;
esac

email="`echo $email|tr '[A-Z' '[a-z]'`"
if which md5 > /dev/null; then
       hash="`md5 -qs $email`"
else
       hash="`echo -n $email|md5sum|cut -d' ' -f1`"
fi

echo $baseuri/$hash$tail
