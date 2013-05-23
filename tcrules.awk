BEGIN {
	FS=":"
	n = 0
}

($1 != "") {
	n++
	class[n] = $1
	prio[n] = ($2 * linespeed / 100)
	avgrate[n] = ($3 * linespeed / 100)
	pktsize[n] = $4
	delay[n] = $5
	maxrate[n] = ($6 * linespeed / 100)
	qdisc[n] = $7
	filter[n] = $8
}

END {
	for (i = 1; i <= n; i++) {

		lsm1[i] = 0
		lsm2[i] = prio[i]
		rtm1[i] = 0
		rtm2[i] = avgrate[i]

		printf "tc class add dev "device" parent 1:1 classid 1:"class[i]"0 hfsc"

		if (delay[i] > 0) {
			printf " rt m1 " int(rtm1[i]) "kbit d " int(delay[i]) "ms m2 " int(rtm2[i]) "kbit"
		 	printf " ls m1 " int(lsm1[i]) "kbit d " int(delay[i]) "ms m2 " int(lsm2[i]) "kbit"
		} else {
		 	printf " rt m2 " int(rtm2[i]) "kbit"
		 	printf " ls m2 " int(lsm2[i]) "kbit"
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

