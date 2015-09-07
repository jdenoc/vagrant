#!/usr/bin/env bash

LINE_BREAK="#####################"
KIBANA_SERVICE="/etc/init.d/kibana"
KIBANA_YML="/opt/kibana/config/kibana.yml"

echo $LINE_BREAK
echo "Installing Kibana"
echo $LINE_BREAK

mkdir -p /opt/kibana
wget -O /tmp/kibana-4.1.1-linux-x86.tar.gz https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x86.tar.gz
tar xf /tmp/kibana-*.tar.gz -C /tmp
mv -f /tmp/kibana-*/* /opt/kibana
sed -i_bak "s/host\: .*/host: 192.168.33.10/" $KIBANA_YML
sed "s/elasticsearch_url\: .*/elasticsearch_url: \"http://logs.local\"/" $KIBANA_YML > /tmp/kibana.yml; mv /tmp/kibana.yml $KIBANA_YML
sed "s/elasticsearch_preserve_host\: .*/elasticsearch_preserve_host: 192.168.33.111/" $KIBANA_YML > /tmp/kibana.yml; mv /tmp/kibana.yml $KIBANA_YML
rm -rf /tmp/kibana*

# Setup logs.local domain
mv /opt/kibana/src/public/index.html /opt/kibana/src/public/index.html_bak
/vagrant/create_domain.sh logs.local /opt/kibana/src/public > /dev/null
mv -f /opt/kibana/src/public/index.html_bak /opt/kibana/src/public/index.html

# Create Kibana service
echo "#!/bin/bash" >> $KIBANA_SERVICE
echo "PATH=/sbin:/usr/sbin:/bin:/usr/bin" >> $KIBANA_SERVICE
echo "DESC=\"Kibana 4\"" >> $KIBANA_SERVICE
echo "NAME=kibana" >> $KIBANA_SERVICE
echo "DAEMON=/opt/kibana/bin/\$NAME" >> $KIBANA_SERVICE
echo "DAEMON_ARGS=\"\"" >> $KIBANA_SERVICE
echo "PIDFILE=/var/run/\$NAME.pid" >> $KIBANA_SERVICE
echo "SCRIPTNAME=/etc/init.d/\$NAME" >> $KIBANA_SERVICE
echo "LOG=/opt/kibana/bin/kibana.log" >> $KIBANA_SERVICE
echo "" >> $KIBANA_SERVICE
echo "pid_file_exists() {" >> $KIBANA_SERVICE
echo "    [ -f \"\$PIDFILE\" ]" >> $KIBANA_SERVICE
echo "}" >> $KIBANA_SERVICE
echo "" >> $KIBANA_SERVICE
echo "do_start() {" >> $KIBANA_SERVICE
echo "    if pid_file_exists" >> $KIBANA_SERVICE
echo "    then" >> $KIBANA_SERVICE
echo "        echo \"Kibana is already running\"" >> $KIBANA_SERVICE
echo "    else" >> $KIBANA_SERVICE
echo "        \$DAEMON \$DAEMON_ARGS 1>\"\$LOG\" 2>&1 &" >> $KIBANA_SERVICE
echo "        echo \$! > \"\$PIDFILE\"" >> $KIBANA_SERVICE
echo "        PID=\$!" >> $KIBANA_SERVICE
echo "        if [ \"\$PID\" > 0 ]" >> $KIBANA_SERVICE
echo "        then" >> $KIBANA_SERVICE
echo "            echo \"Kibana started with pid \$!\"" >> $KIBANA_SERVICE
echo "        else" >> $KIBANA_SERVICE
echo "            echo \"Kibana could not be started\"" >> $KIBANA_SERVICE
echo "        fi" >> $KIBANA_SERVICE
echo "    fi" >> $KIBANA_SERVICE
echo "}" >> $KIBANA_SERVICE
echo "" >> $KIBANA_SERVICE
echo "do_status() {" >> $KIBANA_SERVICE
echo "    if pid_file_exists" >> $KIBANA_SERVICE
echo "    then" >> $KIBANA_SERVICE
echo "        PID=\$(cat \$PIDFILE)" >> $KIBANA_SERVICE
echo "        STATUS=\$(ps ax | grep \$PID | grep -v grep | awk '{print \$1}')" >> $KIBANA_SERVICE
echo "        if [ \"\$STATUS\" == \"\$PID\" ]" >> $KIBANA_SERVICE
echo "        then" >> $KIBANA_SERVICE
echo "            echo \"Kibana is running on proccess \$PID\"" >> $KIBANA_SERVICE
echo "        else" >> $KIBANA_SERVICE
echo "            echo \"Kibana is NOT running\"" >> $KIBANA_SERVICE
echo "            rm \$PIDFILE" >> $KIBANA_SERVICE
echo "        fi" >> $KIBANA_SERVICE
echo "    else" >> $KIBANA_SERVICE
echo "        echo \"Kibana is NOT running\"" >> $KIBANA_SERVICE
echo "    fi" >> $KIBANA_SERVICE
echo "}" >> $KIBANA_SERVICE
echo "" >> $KIBANA_SERVICE
echo "do_stop() {" >> $KIBANA_SERVICE
echo "    if pid_file_exists" >> $KIBANA_SERVICE
echo "    then" >> $KIBANA_SERVICE
echo "        PID=\$(cat \$PIDFILE)" >> $KIBANA_SERVICE
echo "        STATUS=\$(ps ax | grep \$PID | grep -v grep | awk '{print \$1}')" >> $KIBANA_SERVICE
echo "        if [ \"\$STATUS\" == \"\$PID\" ]" >> $KIBANA_SERVICE
echo "        then" >> $KIBANA_SERVICE
echo "            echo \"Killing Kibana....\"" >> $KIBANA_SERVICE
echo "            KILL=\$(kill -15 \$PID)" >> $KIBANA_SERVICE
echo "            rm \$PIDFILE" >> $KIBANA_SERVICE
echo "            sleep 1" >> $KIBANA_SERVICE
echo "            echo -e \"\\tKibana (PID:\$PID) killed\"" >> $KIBANA_SERVICE
echo "        else" >> $KIBANA_SERVICE
echo "            echo \"Kibana is NOT running\"" >> $KIBANA_SERVICE
echo "            rm \$PIDFILE" >> $KIBANA_SERVICE
echo "        fi" >> $KIBANA_SERVICE
echo "    else" >> $KIBANA_SERVICE
echo "        echo \"Kibana is NOT running\"" >> $KIBANA_SERVICE
echo "    fi" >> $KIBANA_SERVICE
echo "}" >> $KIBANA_SERVICE
echo "" >> $KIBANA_SERVICE
echo "case \"\$1\" in" >> $KIBANA_SERVICE
echo "    start)" >> $KIBANA_SERVICE
echo "        do_start" >> $KIBANA_SERVICE
echo "        ;;" >> $KIBANA_SERVICE
echo "    stop)" >> $KIBANA_SERVICE
echo "        do_stop" >> $KIBANA_SERVICE
echo "        ;;" >> $KIBANA_SERVICE
echo "    status)" >> $KIBANA_SERVICE
echo "        do_status" >> $KIBANA_SERVICE
echo "        ;;" >> $KIBANA_SERVICE
echo "    restart)" >> $KIBANA_SERVICE
echo "        do_stop" >> $KIBANA_SERVICE
echo "        do_start" >> $KIBANA_SERVICE
echo "        ;;" >> $KIBANA_SERVICE
echo "    *)" >> $KIBANA_SERVICE
echo "        echo \"Usage: \$SCRIPTNAME {start|stop|status|restart}\" >&2" >> $KIBANA_SERVICE
echo "        exit 3" >> $KIBANA_SERVICE
echo "        ;;" >> $KIBANA_SERVICE
echo "esac" >> $KIBANA_SERVICE
echo "" >> $KIBANA_SERVICE
echo ":" >> $KIBANA_SERVICE

chmod +x $KIBANA_SERVICE
chkconfig kibana on
service kibana start

echo $LINE_BREAK
echo "Kibana complete!!!"
echo $LINE_BREAK