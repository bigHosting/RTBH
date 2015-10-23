
1. Create database RTBH
    mysql> create database RTBH;

2. Create user for dosportal user:
    mysql> GRANT USAGE ON *.* TO 'dosportal'@'nsyslog-mia1.sec.domain.com' IDENTIFIED BY 'PASSWORD_HERE';
    mysql> GRANT ALL PRIVILEGES ON `RTBH`.* TO 'dosportal'@'nsyslog-mia1.sec.domain.com'; 
    mysql> GRANT ALL PRIVILEGES ON `dosportal`.* TO 'dosportal'@'nsyslog-mia1.sec.domain.com';

3. Mysqld 5.5 is missing ipv6 to binary conversion so you need to install mysql-udf-ipv6 plugin. For convenience I've attached source code from bitbucket.org. 
    https://bitbucket.org/watchmouse/mysql-udf-ipv6

   I've rebuilt the udf plugin rpm for CentOS 6 I found @ http://yum.fjfi.cvut.cz/clean-epel-7-x86_64/mysql-udf-ipv6-2.05-1.el7.centos.src.rpm 

   # rpmbuild --rebuild  mysql-udf-ipv6-2.05-2.el6.src.rpm
   # cd .....
   # rpm -ivh mysql-udf-ipv6-2.05-2.el6.x86_64.rpm
   # rpm -ql mysql-udf-ipv6
   # service mysqld restart

   mysql> CREATE FUNCTION inet6_ntop RETURNS STRING SONAME "mysql_udf_ipv6.so";
   mysql> CREATE FUNCTION inet6_pton RETURNS STRING SONAME "mysql_udf_ipv6.so";

   mysql> CREATE FUNCTION inet6_lookup RETURNS STRING SONAME "mysql_udf_ipv6.so";
   mysql> CREATE FUNCTION inet6_rlookup RETURNS STRING SONAME "mysql_udf_ipv6.so";
   mysql> CREATE FUNCTION inet6_mask RETURNS STRING SONAME "mysql_udf_ipv6.so";

