#!/usr/bin/env bash

# Author:   Zhang Huangbin (zhb _at_ iredmail.org)
# Purpose:  Import users to SQL database from plain text file.
# Project:  iRedMail (http://www.iredmail.org/)ss

# -------------------------------------------------------------------
# Usage:
#   * Edit these variables:
#       STORAGE_BASE_DIRECTORY
#       DEFAULT_QUOTA='1024'   # 1024 is 1GB
#
#   * Run this script to generate SQL command used to create new user.
#
#       bash create_mail_user_SQL.sh <new-email> <plain-password>
#
#     For example:
#
#       bash create_mail_user_SQL.sh user@domain.ltd plain_password
#
#     It will print SQL commands on console directly, you can redirect the
#     output to a file for further use like this:
#
#       bash create_mail_user_SQL.sh user@domain.ltd plain_password > output.sql
#
#   * Import output.sql into SQL database like below:
#
#       # mysql -uroot -p
#       mysql> USE vmail;
#       mysql> SOURCE /path/to/output.sql;
#
#       # psql -d vmail
#       sql> \i /path/to/output.sql;

# --------- CHANGE THESE VALUES ----------
# Storage base directory used to store users' mail.
STORAGE_BASE_DIRECTORY="/var/vmail/vmail1"

###########
# Password
#
# Password scheme. Available schemes: BCRYPT, SSHA512, SSHA, PLAIN.
# Check file Available
PASSWORD_SCHEME='SSHA512'

# Default mail quota (in MB).
DEFAULT_QUOTA='1024'

#
# Maildir settings
#
# Maildir style: hashed, normal.
# Hashed maildir style, so that there won't be many large directories
# in your mail storage file system. Better performance in large scale
# deployment.
# Format: e.g. username@domain.td
#   hashed  -> domain.ltd/u/us/use/username/
#   normal  -> domain.ltd/username/
# Default hash level is 3.
MAILDIR_STYLE='hashed'      # hashed, normal.

if [ X"$#" != X'2' ]; then
	echo "Invalid command arguments. Usage:"
	echo "bash create_mail_user_SQL.sh user@domain.ltd plain_password"
	exit 255
fi

cat <<EOF
INSERT INTO mailbox (username, password, name,
					 storagebasedirectory,storagenode, maildir,
					 quota, domain, active, passwordlastchange, created)
			 VALUES ('${mail}', '${CRYPT_PASSWD}', '${username}',
					 '${STORAGE_BASE}','${STORAGE_NODE}', '${maildir}',
					 '${DEFAULT_QUOTA}', '${domain}', '1', NOW(), NOW());
INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_forwarding)
				 VALUES ('${mail}', '${mail}','${domain}', '${domain}', 1);
EOF
