#!/bin/bash
if [ "$DNS_DATABASE_URL" == "" ]; then
	export DNS_DATABASE_URL="sqlite3://$(pwd)/DNService/db/dnservice.sqlite3"
fi

pushd DNSAdmin;
rake dns:stop;
popd

pushd DNService;
rake stop;
popd
