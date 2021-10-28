# Just to test the connection
# No password on root
# password on local user

# https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-18-04

import mysql.connector

cnx = mysql.connector.connect(user='priyam', password='password',
                              host='127.0.0.1',
                              database='mysql')
cnx.close()
