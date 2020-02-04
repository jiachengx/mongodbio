# Usage:
#	$0 [0:import 1:export] [database_name] [(input/ output) folder path]
#!/bin/bash


if [ ! $1 ]; then
	printf "Usage:\n\t$0 [0:import 1:export] [database_name] [(input/ output) folder path]\n"
	exit 1
fi
if [ $1 -eq 0 ] && [ ! $2 ]; then
	printf "Usage:\n\t$0 [0:import] [database_name] [input folder path]\n"
	exit 1
elif [ $1 -eq 1 ] && [ ! $2 ]; then
	printf "Usage:\n\t$0 [1:output] [database_name] [output folder path]\n"
	exit 1
fi

io=$1
db=$2
iodir=$3

db_export() {
	tmp_file="fadlfhsdofheinwvw.js"
	echo "print('_ ' + db.getCollectionNames())" > ${tmp_file}
	collections=$(mongo ${db} ${tmp_file} |grep '_' | awk '{print $2}' | tr ',' ' ')
	for col in ${collections}
	do
		mongoexport -d ${db} -c ${col} -o ${iodir}/${col}.json
	done
	rm ${tmp_file}
}


db_import() {
	for file in ${iodir}/*.json
	do
		if [[ -f ${file} ]]; then
			echo "mongoimport --db ${db} --collection $(echo ${file##*/} | cut -d\. -f1) --file ${file}"
		fi
	done
}

# main
if [ ${io} -eq 0 ]; then
	db_import
elif [ ${io} -eq 1 ]; then
	db_export
fi
