// Create uniqueness constraint on `name` property of Category nodes
CREATE CONSTRAINT import_constraint ON (c:Category) ASSERT c.Name IS UNIQUE;

CALL apoc.periodic.iterate(
  'LOAD CSV FROM "file:///taxonomy_iw.csv" AS line RETURN line',
  'WITH line[0] AS cat1Name, line[1] AS cat2Name
   MERGE (n:Category {Name: cat1Name})
   MERGE (m:Category {Name: cat2Name})
   MERGE (n)-[:Super_Category]->(m)',
  {batchSize: 500, parallel: true}
)
