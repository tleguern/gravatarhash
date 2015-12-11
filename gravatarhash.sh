#!/bin/sh
#
# Copyright (c) 2014,2015 Tristan Le Guern <tleguern@bouledef.eu>
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

readonly PROGNAME="$(basename $0)"
readonly VERSION='v1.0'

usage() {
        echo "usage: $PROGNAME [-s] [-p dns|gravatar|libreavatar] email"
}

_md5() {
	if which md5 > /dev/null; then
		md5 -qs $1
	else
		echo -n $1 | md5sum | cut -d' ' -f1
	fi
}

sflag=0
pflag=''

tail="?d=retro"

while getopts ":p:s" opt;do
	case $opt in
		p) pflag=$OPTARG;;
		s) sflag=1;;
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
	if [ $sflag -eq 1 ]; then
		echo "https://secure.gravatar.com/avatar"
	else
		echo "http://www.gravatar.com/avatar"
	fi
}

getlibreavatarbaseuri() {
	if [ $sflag -eq 1 ]; then
		echo "https://seccdn.libravatar.org/avatar"
	else
		echo "http://cdn.libravatar.org/avatar"
	fi
}

getdnsbaseuri() {
	dns_domain="$( echo $1 | cut -d '@' -f 2 )"

	if [ $sflag -eq 1 ]; then
		dns_service="_avatars-sec._tcp"
		proto="https"
	else
		dns_service="_avatars._tcp"
		proto="http"
	fi

	if dns_ret="$(dig +short $dns_service.$dns_domain -t SRV)"; then :
	else
		return 1
	fi
	if [ -z "$dns_ret" ]; then
		return 1
	fi
	# TODO: Check priority and weight

	# Clean up the trailing dot
	dns_ret="$(echo $dns_ret|rev|cut -d'.' -f2-|rev|cut -d ' ' -f 4)"
	echo "$proto://$dns_ret/avatar"
}

# If asked, use the specific provider. If not do a DNS request and
# fallback to gravatar.
case "$pflag" in
	dns) baseuri="$(getdnsbaseuri $email)";;
	libreavatar) baseuri="$(getlibreavatarbaseuri)";;
	gravatar) baseuri="$(getgravatarbaseuri)";;
	*) baseuri="$(getdnsbaseuri $email || getgravatarbaseuri)";;
esac

email="$(echo $email|tr '[A-Z' '[a-z]')"
hash="$(_md5 $email)"

echo $baseuri/$hash$tail
