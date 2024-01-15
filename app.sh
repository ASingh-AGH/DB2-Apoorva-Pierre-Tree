#!/bin/bash

echo -e "Welcome to my Neo4j application. We will populate the database, it could take a few minutes!\n"

import=$(/usr/bin/time -f "Data imported in %e seconds\n" cypher-shell -u neo4j -p password -f ./SetupScripts/import_data.cyp)
index=$(/usr/bin/time -f "Search index created in %e seconds\n" cypher-shell -u neo4j -p password -f ./SetupScripts/search_index.cyp)

while true
do
	echo -e "\nWhich of the following actions would you like to perform? Please enter only the number!"
	echo "1. Find all children of a node."
	echo "2. Count all children of a node."
	echo "3. Find all grandchildren of a node."
	echo "4. Find all parents of a node."
	echo "5. Count all parents of a node."
	echo "6. Find all grandparents of a node."
	echo "7. Count uniquely named nodes."
	echo "8. Find root node"
	echo "9. Find nodes with most children."
	echo "10. Find nodes with least children."
	echo "11. Rename a node"
	echo -e "12. End script\n"
	echo -e "0. DELETE ALL\n"

	echo "Enter number: "
	read action
	echo -e "\n"

	if [[ "$action" == 1 || "$action" == 2 || "$action" == 3 || "$action" == 4 || "$action" == 5 || "$action" == 6 || "$action" == 11 ]]; then
		echo "Enter the node you would like to perform the action on:"
		read given

	fi

	if [[ "$action" == 1 ]]; then
		output=$(echo "MATCH (parent:Category {Name: '$given'})
		MATCH (parent)-[:Super_Category]->(child)
		RETURN child.Name;" | time -f "\nThe action took %e seconds and the answer is the following:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 2 ]]; then
		output=$(echo "MATCH (parent:Category {Name: '$given'})
		MATCH (parent)-[:Super_Category]->(child)
		RETURN COUNT(child) AS childCount;" | time -f "\nThe action took %e seconds and the answer is the following:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 3 ]]; then
		output=$(echo "MATCH (grandparent:Category {Name: '$given'})
		MATCH (grandparent)-[:Super_Category]->(parent)-[:Super_Category]->(grandchild)
		RETURN grandchild.Name;" | time -f "\nThe action took %e seconds and the answer is the following:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 4 ]]; then
		output=$(echo "MATCH (child:Category {Name: '$given'})
		MATCH (parent)-[:Super_Category]->(child)
		RETURN parent.Name;" | time -f "\nThe action took %e seconds and the answer is the following:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 5 ]]; then
		echo "The answer is the following:"
		output=$(echo "MATCH (child:Category {Name: '$given'})
		MATCH (parent)-[:Super_Category]->(child)
		RETURN COUNT(parent) AS parentCount;" | time -f "\nThe action took %e seconds and the answer is the following:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 6 ]]; then
		output=$(echo "MATCH (grandchild:Category {Name: '$given'})
		MATCH (grandparent)-[:Super_Category]->(parent)-[:Super_Category]->(grandchild)
		RETURN grandparent.Name;" | time -f "\nThe action took %e seconds and the answer is the following:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 7 ]]; then
		output=$(echo "MATCH (n)
		RETURN count(DISTINCT n.Name) AS uniqueNodeCount;" | time -f "\nThe action took %e seconds and the answer is the following:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 8 ]]; then
		output=$(echo "MATCH (n)
		WHERE NOT ()-[:Super_Category]->(n)
		WITH n
		MATCH (n)-[:Super_Category]->(child)
		RETURN n.Name
		LIMIT 1;" | time -f "\nThe action took %e seconds and the answer is the following:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 9 ]]; then
		output=$(echo "MATCH (n)-[:Super_Category]->(child)
		WITH n, count(child) AS childCount
		ORDER BY childCount DESC
		RETURN n.Name, childCount
		LIMIT 10;" | time -f "\nThe action took %e seconds and the top 10 is:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 10 ]]; then
		output=$(echo "MATCH (parent)-[:Super_Category]->(child)
		WITH parent, COUNT(child) AS childCount
		ORDER BY childCount ASC
		LIMIT 10
		RETURN parent.Name, childCount;" | time -f "\nThe action took %e seconds and the top 10 is:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 11 ]]; then
		echo "Enter new name: "
		read NewName
		output=$(echo "MATCH (n:Category {Name: '$given'})
		SET n.Name = '$NewName'
		RETURN n.Name;" | time -f "\nThe action took %e seconds to complete:\n" cypher-shell -u neo4j -p password)
		
		node_names=$(echo "$output" | awk 'NR>1 {gsub(/"/,"",$0); print $0}')
		echo "$node_names"
	fi

	if [[ "$action" == 12 ]]; then
		exit
	fi
	
	if [[ "$action" == 0 ]]; then
		echo -e "Database cleared in following times:\n"
		time cypher-shell -u neo4j -p password -f ./SetupScripts/clear_database.cyp
	fi

done
