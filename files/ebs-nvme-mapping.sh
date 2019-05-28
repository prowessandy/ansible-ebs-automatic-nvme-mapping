#!/bin/bash

PATH="${PATH}:/usr/sbin"

for blkdev in $( nvme list | awk '/^\/dev/ { print $1 }' ) ; do
  mapping=$(nvme id-ctrl --raw-binary "${blkdev}" | cut -c3073-3104 | tr -s ' ' | sed 's/ $//g')

  if [[ "${mapping}" == "" ]]; then
    ( test -b "${blkdev}" && test -L "/dev/local0" ) || ln -s "${blkdev}" "/dev/local0"
  else
    if [[ "${mapping}" != /dev/* ]]; then
        mapping="/dev/${mapping}"
    fi
    ( test -b "${blkdev}" && test -L "${mapping}" ) || ln -s "${blkdev}" "${mapping}"
  fi
done
