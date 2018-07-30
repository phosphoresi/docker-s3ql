# S3QL

This container allow you to mount the backend s3ql.<br>
It has only been tested to backup on swift for now.


## Usage

For the container to mount the s3ql filesystem you need to configure at least :
 
* The credential to login to the swift backend :
  * ```backend_login=TENANT_NAME:USERNAME```
  * ```backend_password=PASSWORD```
  
  On OVH you can find those informations by downloading your openrc file in horizon.

* The following environment variables :
  * storage_url : URL of the backend storage and region ```Example : swiftks://auth.cloud.ovh.net/REGION_NAME:CT_NAME```
  * fs_passphrase : the passphrase you want to use for the filesystem encryption



The filesystem will be created if necessary but it won't be formatted if corrupted or in an unknown state.


A docker-compose.yml file can be found in the repo if you need more examples.

## Optional Environment variables       

Variable | Decription | Default Value
------------ | ------------- | ------------
CACHESIZE | Size of the cache in KB  | 10485760 (10GB)
S3QL_MOUNTPOINT | Mountpoint of the filesystem  | /mnt/s3ql


## TroubleShooting

**ERROR: Found existing file system! Use --force to overwrite** is nothing to worry about, this just mean your filesystem already existed and no creation was needed <br>
**ERROR: File system damaged or not unmounted cleanly, run fsck!** most likely mean your filesystem wasn't unmounted properly, you can solve it with the following steps :


!!! caution
    Make sure the filesystem is not in use anywhere or you might lose data

  1) run the container in debug mode : change the entrypoint to ```watch echo debug```
  2) inside the container run the script ```/scripts/10_create_s3ql_filesystem``` to create the authentification file to s3ql
  3) run the following command to launch a check of the filesystem : ```fsck.s3ql --authfile /root/s3ql.ini $storage_url```

