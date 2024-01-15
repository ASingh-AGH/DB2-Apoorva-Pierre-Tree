#!/bin/bash

new_line="dbms.security.procedures.unrestricted=algo.*,apoc.*"

conf_file="/etc/neo4j/neo4j.conf"

# Check if the file exists
if [ ! -f "$conf_file" ]; then
    echo "Error: Neo4j configuration file not found!"
    exit 1
fi

# Add the line to the file
sudo sh -c "echo \"$new_line\" >> \"$conf_file\""

