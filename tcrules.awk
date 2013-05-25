BEGIN {
	FS=":"
	n = 0
}

($1 != "") {
	n++
	class[n] = $1
	avgrate[n] = ($2 * linespeed / 100)
	maxrate[n] = ($3 * linespeed / 100)
	qdisc[n] = $4
	filter[n] = $5
	irate[n] = ($6 * linespeed / 100)
	duration[n] = $7
}

END {
	for (i = 1; i <= n; i++) {

		printf "tc class add dev "device" parent 1:1 classid 1:"class[i]"0 hfsc"

		if (duration[i] > 0) {
			printf " sc m1 " int(irate[i]) "kbit d " int(duration[i]) "ms m2 " int(avgrate[i]) "kbit"
		} else {
		 	printf " sc m2 " int(avgrate[i]) "kbit"
		}
		print " ul rate " int(maxrate[i]) "kbit"

	}

	for (i = 1; i <= n; i++) {
		print "tc qdisc add dev "device" parent 1:"class[i]"0 handle "class[i]"00: fq_codel"
	}

	for (i = 1; i <= n; i++) {
		print "tc filter add dev "device" parent 1: prio "class[i]" protocol ip handle "class[i]"/0xff fw flowid 1:"class[i] "0"
		filterc=1
		if (filter[i] != "") {
			print " tc filter add dev "device" parent "class[i]"00: handle "filterc"0 "filter[i]
			filterc=filterc+1
		}
	}
}

