#!/bin/bash

source ./env

if [[ -f summarized-data.csv ]]; then
	echo "Summarized data detected from previous run. File will be removed if you conintue."
	read -e -p "Continue [y/N]? " choice
	[[ "$choice" == [Nn]* ]] && echo "Selected No. Exiting." && exit

	echo "Selected Yes; continuing..."
	rm summarized-data.csv

fi

while read image; do
	SIZE1=`docker images --format '{{.Repository}},{{.Size}}' $LOCAL_REGISTRY/$image`
	OM1=`jq '.LayerCount,.Vulnerabilities.Negligible, .Vulnerabilities.Low, .Vulnerabilities.Medium , .Vulnerabilities.High , .Vulnerabilities.Negligible+.Vulnerabilities.Low+.Vulnerabilities.Medium+.Vulnerabilities.High | length ' logs/$image.clair.json | xargs | sed 's/ /,/g'`

	# Ensure the log file can be parsed by jq if no image was found
	#   A log file wilil contain the string below, but not in valid JSON, if the slimming did not create an image.
	sed -i "s/^Can't pull fsLayers/[\"Can't pull fsLayers\"]/g" logs/$image.clair.slim.json

	SIZE2=`docker images --format '{{.Repository}},{{.Size}}' $LOCAL_REGISTRY/$image.slim`
	OM2=`jq '.LayerCount?,.Vulnerabilities?.Negligible, .Vulnerabilities?.Low, .Vulnerabilities?.Medium , .Vulnerabilities?.High , .Vulnerabilities?.Negligible +.Vulnerabilities?.Low + .Vulnerabilities?.Medium + .Vulnerabilities?.High | length ' $LOGS/$image.clair.slim.json | xargs | sed 's/ /,/g'`

	echo $image,$SIZE1,$OM1,$SIZE2,$OM2

done < $IMAGES_FILE
