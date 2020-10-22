export CATALOG=https://geosource-back.recette.data.grandlyon.com/geonetwork
export CATALOG=http://localhost:8080/geonetwork
export CATALOGUSER=fxp
export CATALOGPASS=admin
export PROCESS=notset


rm -f /tmp/cookie;
curl -s -c /tmp/cookie -o /dev/null -X POST "$CATALOG/srv/eng/info?type=me";
export TOKEN=`grep XSRF-TOKEN /tmp/cookie | cut -f 7`;
curl -X POST -H "X-XSRF-TOKEN: $TOKEN" --user $CATALOGUSER:$CATALOGPASS -b /tmp/cookie \
  "$CATALOG/srv/eng/info?type=me"


curl -X PUT "$CATALOG/srv/api/tools/migration/steps/org.fao.geonet.MetadataResourceDatabaseMigration" \
  -H "accept: text/plain" -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS
