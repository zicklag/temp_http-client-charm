#!/bin/bash

set -ex

status=""
has_relation="false"

for relation_id in $(lucky relation list-ids --relation-name http); do
	for unit_name in $(lucky relation list-units --relation-id $relation_id); do
		has_relation="true"

		hostname=$(lucky relation get -r $relation_id -u $unit_name hostname)
		port=$(lucky relation get -r $relation_id -u $unit_name port)
		
		status="$status $unit_name: hostname=$hostname port=$port;"
	done
done

if [ "$has_relation" = "true" ]; then
	lucky set-status active "$status"
else
	lucky set-status waiting "Waiting for http relation"
fi

