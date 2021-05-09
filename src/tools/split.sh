#!/bin/sh

if [ $# -lt 1 ]; then
  echo Usage: $0 <path_name> [start address]
  exit 64
fi

address=0;
if [ $# -gt 1 ]; then
  address=$((2))
fi

prefix=$1
initfile=${prefix}.init
srcfile=${prefix}.bin
logfile=${prefix}_dd.log
filesize=`ls -l ${srcfile} | awk '{print $5}'`
echo -e "\nerase $address $filesize\n" >> $initfile
cnt=0;
loop=1
while [ $loop -ne 0 ]; do
	dstfile=${prefix}${cnt}.bin
	dd if=${srcfile} bs=2K of=${dstfile} count=1 skip=${cnt} &> $logfile
	sect_size=`sed -n 3p $logfile | awk '{print $1}'`
	if [ $sect_size -lt 2048 ]; then
		loop=0;
		if [ $sect_size -eq 0 ]; then
			break;
		fi
	fi
	echo "program ${dstfile} ${address} ${sect_size}" >> $initfile
	cnt=$((cnt + 1))
	address=$((address + 2048))
done
rm -f $logfile