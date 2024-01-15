DROP INDEX search_index;

MATCH(n) DETACH DELETE(n);
