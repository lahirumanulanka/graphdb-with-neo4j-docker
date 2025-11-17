// Neo4j Browser: no params required, just run the query.
// Find the most connected users by total degree (in + out)
MATCH (n:User)
OPTIONAL MATCH (n)-[:FOLLOWS]->(o)
WITH n, count(o) AS out
OPTIONAL MATCH (i)-[:FOLLOWS]->(n)
WITH n, out, count(i) AS in
RETURN n.name AS user, (in + out) AS degree, in, out
ORDER BY degree DESC, user ASC
LIMIT 5;
