#!/bin/bash

if [ ! -f home.qth ]
then
	# Need a home.qth file
	cat <<-EOF > home.qth
		PERTH
		 -31.953512
		 115.857048
		 20
	EOF
fi

if [ $# -ne 1 ]
then
	# Default ISS
	item=25544
else
	item=$1
fi

if [ "${item}" -eq "${item}" ] 2> /dev/null
then
	searchType='CATNR'
else
	searchType='NAME'
fi

tleName="${item}.tle"

if [ ! -f "${tleName}" ] || [ "$(find "${tleName}" -mtime +1)" ]
then
	wget --quiet --output-document="${tleName}" "https://celestrak.com/NORAD/elements/gp.php?${searchType}=${item}&FORMAT=TLE"
fi

predict -t "${tleName}" -q home.qth -p "${item}"
