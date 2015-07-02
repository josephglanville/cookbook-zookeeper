# Zookeeper

This cookbook is designed for use with Gersberms to build AMIs for autoscaling Zookeeper clusters on EC2 using Netflix Exhibitor.

# Wrapper

There is a wrapper script that launches Exhbitor that expects a number of environment variables to be defined in /etc/env_vars

```bash
CONFIG_TYPE="s3" # required, can be file or s3
AWS_ACCESS_KEY_ID # optional
AWS_SECRET_ACCESS_KEY # optional
PORT="8181" # requried
S3_BUCKET="app-exhibitor" # required when CONFIG_TYPE == s3
S3_PREFIX="exhibitor/" # required when CONFIG_TYPE == s3
S3_REGION="ap-southeast-2" # required when CONFIG_TYPE == s3
HOSTNAME="hostname" # required
FS_CONFIG_DIR="/var/lib/exhibitor" # optional when CONFIG_TYPE == file
```
