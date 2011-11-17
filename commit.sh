. ./options
./mk_group.sh output/opensuse/dvd-i586.list DVD-i586 osc/openSUSE:$proj/_product/DVD5-i586.group only_i586
./mk_group.sh output/opensuse/dvd-x86_64.list DVD-x86_64 osc/openSUSE:$proj/_product/DVD5-x86_64.group only_x86_64

./split_dvd9.sh output/opensuse/dvd9-i586.list output/opensuse/dvd9-x86_64.list output/opensuse/dvd9-all.list output/opensuse/dvd9-only_i586.list output/opensuse/dvd9-only_x86_64.list
./mk_group.sh output/opensuse/dvd9-only_i586.list DVD9-i586 osc/openSUSE:$proj/_product/DVD9-i586.group only_i586
./mk_group.sh output/opensuse/dvd9-only_x86_64.list DVD9-x86_64 osc/openSUSE:$proj/_product/DVD9-x86_64.group only_x86_64
./mk_group.sh output/opensuse/dvd9-all.list DVD9-biarch osc/openSUSE:$proj/_product/DVD9-biarch.group

./mk_group.sh output/opensuse/promo_dvd.i586.list REST-DVD-promo-i386 osc/openSUSE:$proj/_product/DVD5-promo-i386.group only_i586
./mk_group.sh output/opensuse/promo_dvd.x86_64.list REST-DVD-promo-x86_64 osc/openSUSE:$proj/_product/DVD5-promo-x86_64.group only_x86_64

./mk_group.sh output/opensuse/langaddon.i586.list REST-DVD-i586 osc/openSUSE:$proj/_product/DVD5-lang-i586.group only_i586
./mk_group.sh output/opensuse/langaddon.x86_64.list REST-DVD-x86_64 osc/openSUSE:$proj/_product/DVD5-lang-x86_64.group only_x86_64

( cd osc/openSUSE:$proj/_product/ && osc ci -m "auto update" )

./mk_group.sh output/opensuse/x11_cd.i586.list DVD osc/system:install:head/_product/DVD.group
(cd osc/system:install:head/_product/ && osc ci -m "auto update")

osc up -u osc/openSUSE:$proj:Live/package-lists-images.*
cp -a output/opensuse/*default.i586.list osc/openSUSE:$proj:Live/package-lists-images.i586
cp -a output/opensuse/*default.x86_64.list osc/openSUSE:$proj:Live/package-lists-images.x86_64

osc up -u osc/openSUSE:$proj:Live/package-lists-kde.*
cp -a output/opensuse/kde4_cd.i586.list osc/openSUSE:$proj:Live/package-lists-kde.i586/packagelist
cp -a output/opensuse/kde4_cd.x86_64.list osc/openSUSE:$proj:Live/package-lists-kde.x86_64/packagelist

osc up -u osc/openSUSE:$proj:Live/package-lists-gnome.*
cp -a output/opensuse/gnome_cd.i586.list osc/openSUSE:$proj:Live/package-lists-gnome.i586/packagelist
cp -a output/opensuse/gnome_cd.x86_64.list osc/openSUSE:$proj:Live/package-lists-gnome.x86_64/packagelist

osc ci -m "update from desdemona" osc/openSUSE:$proj:Live/package-lists-*
exit 0

(cd osc/openSUSE:$proj:Live/kiwi-usb-kde-x86_64; osc up -e)
(sed -n -e '1,/ PACKAGES BEGIN/p' osc/openSUSE:$proj:Live/kiwi-usb-kde-x86_64/kiwi-usb-kde.kiwi ; cat output/opensuse/dvd-base.x86_64.list | while read pack; do echo '<package name="'$pack'"/>'; done; sed -n -e '/ PACKAGES END/,$p'  osc/openSUSE:$proj:Live/kiwi-usb-kde-x86_64/kiwi-usb-kde.kiwi)| xmllint --format - > t && mv t osc/openSUSE:$proj:Live/kiwi-usb-kde-x86_64/kiwi-usb-kde.kiwi
(cd osc/openSUSE:$proj:Live/kiwi-usb-kde-x86_64; osc diff ; osc ci -m "update")

