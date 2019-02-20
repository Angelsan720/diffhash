rm /data/angelsan720/diffhashtmp/*
for a in `ls -1 $(cat datadir)`;
	do echo "do tar -xf $(cat datadir)/$a -C /data/angelsan720/diffhashtmp/";tar -xf $(cat datadir)/$a -C /data/angelsan720/diffhashtmp/
done

#echo "" > DataFrame
#echo "rep_id	group	lib_sizes"
#for a in `ls -1 /data/angelsan720/diffhashtmp/`;
#
#	if [ $a == *"ATCACG"* ];
#		then echo "$a	1	1";
#	else
#		echo "$a	1	1";
#	fi
#done
#do gzip -dc $a | tar xf -; done