#!/bin/sh
#####################################
# wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel/installer.sh -qO - | /bin/sh

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERSION='2021_08_23'
URL='https://github.com/MOHAMED19OS/Download/blob/main/Channel'

####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    Package='astra-sm'
elif [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
fi

if [ $OSTYPE = "Opensource" ]; then
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
fi

#####################
#  Checking Package #
if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $Package" $STATUS ; then
        echo ""
        echo "$Package Depends Are Installed..."
        sleep 2; clear
    else
        echo ""
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1 ;clear
        echo " Downloading $Package ......"
        $OPKGINSTAL $Package
        echo "" ;clear
    fi

    if grep -qs "Package: $Package" $STATUS ; then
        echo ""
    else
        echo "Feed Missing $Package"
        echo "Sorry, the plugin will not be install"
        clear; echo "Goodbye!"
        exit 0
    fi
fi

###############################
# Downlaod And Install Plugin #
set -e
echo "Downloading And Insallling Channel Please Wait ......"
echo
wget --show-progress "$URL"/channels_"$VERSION".tar.xz -qO $TMPDIR/channels_"$VERSION".tar.xz
tar -xzf channels_"$VERSION".tar.xz -C /
set +e
rm -rf $TMPDIR/channels_"$VERSION".tar.xz

if [ $OSTYPE = "Opensource" ]; then
    uname -m > $CHECK
    sleep 1

    if grep -qs -i 'armv7l' cat $CHECK ; then
        echo ':Your Device IS ARM processor ...'
        sleep 2; clear
        set -e
        echo "Downloading And Insallling Config $Package Please Wait ......"
        echo
        wget --show-progress "$URL"/astra-arm.tar.xz -qO $TMPDIR/astra-arm.tar.xz
        tar -xzf astra-arm.tar.xz -C /
        set +e
        chmod -R 755 /etc/astra
        rm -rf $TMPDIR/astra-arm.tar.xz

    elif grep -qs -i 'mips' cat $CHECK ; then
        echo ':Your Device IS MIPS processor ...'
        sleep 2; clear
        set -e
        echo "Downloading And Insallling Config $Package Please Wait ......"
        echo
        wget --show-progress "$URL"/astra-mips.tar.xz -qO $TMPDIR/astra-mips.tar.xz
        tar -xzf astra-mips.tar.xz -C /
        set +e
        chmod -R 755 /etc/astra
        rm -rf $TMPDIR/astra-mips.tar.xz
    fi
fi

sync
echo ""
echo ""
echo "#########################################################"
echo "#       Channel And Config INSTALLED SUCCESSFULLY       #"
echo "#                   MOHAMED_OS                          #"
echo "#                     support                           #"
echo "#  https://www.tunisia-sat.com/forums/threads/4208717   #"
echo "#########################################################"
echo "#           your Device will RESTART Now                #"
echo "#########################################################"
sleep 2

if [ $OSTYPE = "Opensource" ]; then
    shutdown -r now
else
    systemctl restart enigma2
fi

exit 0
