source ./env

while read image; do

SIZE1=`docker images --format '{{.Repository}},{{.Size}}' $LOCAL_REGISTRY/$image`
OM1=`jq '.LayerCount,.Vulnerabilities.Negligible, .Vulnerabilities.Low, .Vulnerabilities.Medium , .Vulnerabilities.High , .Vulnerabilities.Negligible+.Vulnerabilities.Low+.Vulnerabilities.Medium+.Vulnerabilities.High | length ' logs/$image.clair.json | xargs | sed 's/ /,/g'`

sed -i "s/^Can't pull fsLayers/[\"Can't pull fsLayers\"]/g" logs/$image.clair.slim.json

SIZE2=`docker images --format '{{.Repository}},{{.Size}}' $LOCAL_REGISTRY/$image.slim`
OM2=`jq '.LayerCount?,.Vulnerabilities?.Negligible, .Vulnerabilities?.Low, .Vulnerabilities?.Medium , .Vulnerabilities?.High , .Vulnerabilities?.Negligible +.Vulnerabilities?.Low + .Vulnerabilities?.Medium + .Vulnerabilities?.High | length ' $LOGS/$image.clair.slim.json | xargs | sed 's/ /,/g'`



echo $image,$SIZE1,$OM1,$SIZE2,$OM2

done < $IMAGES_FILE
