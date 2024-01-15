//Search index
DROP CONSTRAINT import_constraint;

CREATE INDEX search_index FOR (c:Category) ON (c.Name);
