// Neo4j Browser usage:
// :param name => 'Alice';
// :play/query to run this file manually or paste query below.
// Find users connected (within 3 hops) to a specific user
// Params: $name (string)
MATCH (target:User {name: $name})
MATCH p = (target)-[*..3]-(other:User)
WHERE other <> target
WITH other, length(p) AS hops
RETURN other.name AS user, min(hops) AS minHops
ORDER BY minHops ASC, user ASC;
