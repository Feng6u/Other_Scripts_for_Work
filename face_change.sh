#!/bin/bash

mkdir ~/Desktop/Face_Images/top_left/
mkdir ~/Desktop/Face_Images/bottom_left/
mkdir ~/Desktop/Face_Images/top_right/
mkdir ~/Desktop/Face_Images/bottom_right/

mkdir -p ~/Desktop/Face_Images/EMO/Positive/
mkdir -p ~/Desktop/Face_Images/EMO/Negative/
mkdir -p ~/Desktop/Face_Images/EMO/Neutral/
mkdir -p  ~/Desktop/Face_Images/EMO/Not_sure/


for i in {1..168}
do
convert ~/Desktop/Face_Images/Slide\ $i.jpg -crop 370x370+0+30 ~/Desktop/Face_Images/top_left/${i}_TL.jpg

convert ~/Desktop/Face_Images/Slide\ $i.jpg -crop 370x370+0+390 ~/Desktop/Face_Images/bottom_left/${i}_BL.jpg

convert ~/Desktop/Face_Images/Slide\ $i.jpg -crop 370x370+650+25 ~/Desktop/Face_Images/top_right/${i}_TR.jpg

convert ~/Desktop/Face_Images/Slide\ $i.jpg -crop 370x370+650+380 ~/Desktop/Face_Images/bottom_right/${i}_BR.jpg
done


for o in /home/cranilab/Desktop/Face_Images/*_*/*.jpg
do

echo "Type 'pos' for a positive expression. Type 'neg' for a negative expression. Type 'neu' for a neutral expression. If you are not sure, press ENTER."

display $o

read EMO

if [ $EMO == "pos" ]
then 
	echo "Moving this image into 'Postive'." 
	mv $o  ~/Desktop/Face_Images/EMO/Positive
elif [ $EMO == "neg" ]
then 
	echo "Moving this image into 'Negative'." 
	mv $o  ~/Desktop/Face_Images/EMO/Negative
elif [ $EMO == "neu" ]
then 
	echo "Moving this image into 'Neutral'."
	mv $o ~/Desktop/Face_Images/EMO/Neutral
else 
	echo "Moving this image into 'Not_sure'."
	mv $o ~/Desktop/Face_Images/EMO/Not_sure
fi

done
