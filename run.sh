#!/bin/bash
sicklocation="/opt/sickbeard_mp4_automator/manual.py" #Location of sickbeard_mp4_automator
tsdate="/root/scripts/rawhdconvert/ts.$(date +'%Y%m%d')" #Create current date and time
tsdatec=$tsdate # Not sure why I did this
ts="/root/scripts/rawhdconvert/ts" # location of ts. TS is the temp file that holds files to be converted
location="$1" # Folder you want to search in
type="$2" # File extension without the . of what you want to be converted
num="$3" # Amount of files you want to be converted
EMAIL_TO="email@site.net" # Where you want it to email when done being converted

function run {
        sed -i 's#^#python '$sicklocation' -i "#' $ts
        sed -i 's#$#" -a#' $ts
        date +'%Y%m%d_%H%M' >> $tsdate
        find "$location" -iname "*."$type"" -type f -exec du -hsc {} + | tail -1 >> $tsdate
        cat $ts >> $tsdate
        chmod +x $ts
        sh $ts
        rm $ts
        find "$location" -iname "*."$type"" -type f -exec du -hsc {} + | tail -1 >> $tsdate
        date +'%Y%m%d_%H%M' >> $tsdatec
        echo "Finished Converting" | mutt -a "$tsdate" -s "Finished Converting" -- "$EMAIL_TO"
}

if [ -f $ts ]
        then
                echo "Already Running"
        else
                if [ $num == "a" ]
                        then
                                find "$location" -iname "*."$type"" -type f >> $ts
                                run
                        else
                                find "$location" -iname "*."$type"" -type f | tail -$num >> $ts
                                run
                fi
fi
