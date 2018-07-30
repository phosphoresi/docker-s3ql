#!/bin/bash


trap 'term_handler' SIGTERM INT
    term_handler() {
	echo "signal received"
        umount.s3ql ${S3QL_MOUNTPOINT}
	echo "unmounted s3ql filesystem"
      exit 143; # 128 + 15 -- SIGTERM
    }


/scripts/10_create_s3ql_filesystem
if [ $? -ne 0 ];then
echo "creating s3ql failed"
fi

/scripts/20_mount_s3ql_filesystem
if [ $? -ne 0 ];then
echo "mounting s3ql failed"
exit 4
fi


echo "waiting for signal"
tail -f /dev/null & wait ${!}


