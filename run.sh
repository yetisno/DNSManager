#!/bin/bash
pushd DNSAdmin;
export DNS_RELOAD_KEY=$(rake secret)
popd

pushd DNService;
bundle install;
rake start;
popd

pushd DNSAdmin;
export SECRET_KEY_BASE=$(rake secret)
bundle install;
rake assets:precompile;
rake dns:run;
popd
