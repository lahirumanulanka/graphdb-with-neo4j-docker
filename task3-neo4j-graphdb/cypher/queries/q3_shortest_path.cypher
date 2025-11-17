// Neo4j Browser usage:
// :param from => 'Alice'; :param to => 'Mallory';
// Shortest path between two users (undirected); limit length to avoid expansion blow-up
// Params: $from (string), $to (string)
MATCH (a:User {name: $from}), (b:User {name: $to})
MATCH p = shortestPath( (a)-[:FOLLOWS*..15]-(b) )
RETURN p AS path, length(p) AS hops;
