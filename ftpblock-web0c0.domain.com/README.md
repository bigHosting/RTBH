  To be able to inject abusers into the RTBH database we need to have server logs in a common place
(folder) and in a certain format 

proftpd.conf:

                # ln -s PATH_TO_LOGS/proftpd.auth/`hostname` /var/log/proftpd.auth.analyzeftp

                #     --->  LogFormat securityauthanalyzeftp "%a %U %m %s %{%j:%H}t"
                #     --->  ExtendedLog /var/log/proftpd.auth.analyzeftp auth securityauthanalyzeftp

