#!/bin/bash
if [ "$DNS_DATABASE_URL" == "" ]; then
	export DNS_DATABASE_URL="sqlite3://$(pwd)/DNService/db/dnservice.sqlite3"
fi

pushd DNService;
bundle install;
export DNS_RELOAD_KEY=$(rake secret)
export SECRET_KEY_BASE=$(rake secret)
rake start;
popd

pushd DNSAdmin;
bundle install;
rake assets:precompile;
rake dns:start;
popd