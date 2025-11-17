# Neo4j Graph DB with Docker (Student Notes)

This is my small Neo4j setup for a class task. I run Neo4j in Docker, load a tiny social-network dataset, and run a few example queries. I wrote these steps so I (or a teammate) can repeat everything quickly.

## What’s inside
- `task3-neo4j-graphdb/`
	- `docker/` (compose file and env if I want to use Compose)
	- `cypher/` (dataset seed + queries)
	- `docs/` (notes/results)
	- `screenshots/` (where I put browser screenshots)

## Prerequisites
- Docker Desktop running on Windows

## Option A — Quick run (single container)
I used this for development. Data resets if I remove the container.

```powershell
# pull latest neo4j image
docker pull neo4j:latest

# run neo4j (password must be 8+ chars)
docker run -d \
	--name neo4j-graphdb \
	-p 7474:7474 -p 7687:7687 \
	-e NEO4J_AUTH=neo4j/test1234 \
	neo4j:latest

# open the browser (login: neo4j / test1234)
# http://localhost:7474
```

If ports are busy, stop any old container first:
```powershell
docker stop neo4j-graphdb; docker rm neo4j-graphdb
```

## Option B — Docker Compose (optional)
There is also a compose file here:
`task3-neo4j-graphdb/docker/docker-compose.yml`

```powershell
cd "c:\\Users\\ASUS\\Documents\\graphdb-with-neo4j-docker\\task3-neo4j-graphdb\\docker"
docker compose up -d
```

Update the password in `neo4j.env` before using Compose.

## Load the dataset (15 users + follows)
I prepared a small social network in `seed.cypher`. These commands push the files into the container and run them. I also keep a cleanup script if I want to reset.

```powershell
$container = "neo4j-graphdb"
$pass = "test1234"
$root = "c:\\Users\\ASUS\\Documents\\graphdb-with-neo4j-docker\\task3-neo4j-graphdb"

# copy scripts into the container
docker cp "$root\\cypher\\cleanup.cypher" ${container}:/cleanup.cypher
docker cp "$root\\cypher\\seed.cypher" ${container}:/seed.cypher

# reset then seed
docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /cleanup.cypher
docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /seed.cypher
```

Check counts (just to be sure):
```powershell
docker exec -i neo4j-graphdb cypher-shell -u neo4j -p test1234 "MATCH (u:User) RETURN count(u) AS users;"
docker exec -i neo4j-graphdb cypher-shell -u neo4j -p test1234 "MATCH (:User)-[r:FOLLOWS]->(:User) RETURN count(r) AS follows;"
```

## Example queries (3 insights)
All query files are in `task3-neo4j-graphdb/cypher/queries`.

1) Connected users (within 3 hops)
```powershell
# Browser hint: :param name => 'Alice';
$container = "neo4j-graphdb"; $pass = "test1234"
docker cp "$root\\cypher\\queries\\q1_connected_users.cypher" ${container}:/q1.cypher

# run with a param (cypher-shell syntax)
docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /q1.cypher --param "name => 'Alice'"
```

2) Most connected users (by total degree)
```powershell
$container = "neo4j-graphdb"; $pass = "test1234"
docker cp "$root\\cypher\\queries\\q2_most_connected.cypher" ${container}:/q2.cypher

docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /q2.cypher
```

3) Shortest path between two users
```powershell
# Browser hint: :param from => 'Alice'; :param to => 'Mallory';
$container = "neo4j-graphdb"; $pass = "test1234"
docker cp "$root\\cypher\\queries\\q3_shortest_path.cypher" ${container}:/q3.cypher

docker exec -i ${container} cypher-shell -u neo4j -p ${pass} -f /q3.cypher --param "from => 'Alice'" --param "to => 'Mallory'"
```

## Screenshots for the report
I save these in `task3-neo4j-graphdb/screenshots/` with these names:
- `browser_create_data.png` (after seeding, show counts)
- `query1_output.png` (connected users)
- `query2_output.png` (most connected)
- `query3_output.png` (shortest path)

Tip: I also exported plain text outputs to the same folder (`*.txt`) for easy copy/paste.

## Troubleshooting
- Password must be at least 8 characters (Neo4j rule). If it fails, pick a longer one, e.g., `test1234`.
- If connection is refused right after `docker run`, wait a few seconds and try again (Neo4j needs a moment to start).
- Port already in use? Stop/remove old containers: `docker ps -a`, then `docker stop ...; docker rm ...`.
- cypher-shell params use this syntax: `--param "name => 'Alice'"`.

## Clean up
```powershell
# stop and remove the quick-run container
docker stop neo4j-graphdb
docker rm neo4j-graphdb

# if using compose
cd "c:\\Users\\ASUS\\Documents\\graphdb-with-neo4j-docker\\task3-neo4j-graphdb\\docker"
docker compose down
```