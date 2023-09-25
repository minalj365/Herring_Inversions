for f in `ls *.fa`;do
        first=`echo $f | cut -d "." -f1`
        rest2=`echo $f | cut -d "." -f2`
        rest3=`echo $f | cut -d "." -f3`

        newfile="${first}_${rest2}.${rest3}"
        #echo "file: $f new: $newfile"
        mv $f $newfile
done;


## rename .fa.* files ##
for f in `ls *.fa.*`;do
        first=`echo $f | cut -d "." -f1`
        rest2=`echo $f | cut -d "." -f2`
        rest3=`echo $f | cut -d "." -f3`
        rest4=`echo $f | cut -d "." -f4`

        newfile="${first}_${rest2}.${rest3}.${rest4}"
        #echo "file: $f new: $newfile"
        mv $f $newfile
done;