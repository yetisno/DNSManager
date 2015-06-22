#!/bin/bash
pushd DNSAdmin;
rake dns:stop;
popd

pushd DNService;
rake stop;
popd
