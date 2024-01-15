sudo apt-get install openjdk-11-jdk

sudo apt install curl

curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key |sudo gpg --dearmor -o /usr/share/keyrings/neo4j.gpg

echo "deb [signed-by=/usr/share/keyrings/neo4j.gpg] https://debian.neo4j.com stable 4.1" | sudo tee -a /etc/apt/sources.list.d/neo4j.list

sudo apt update	 
sudo apt install neo4j

sudo mv RequiredFiles/apoc-4.1.0.0-all.jar /var/lib/neo4j/plugins/

sudo gunzip RequiredFiles/taxonomy_iw.csv.gz
sudo mv RequiredFiles/taxonomy_iw.csv /var/lib/neo4j/import/

sudo bash SetupScripts/neo4j_conf_change.sh

sudo neo4j start
