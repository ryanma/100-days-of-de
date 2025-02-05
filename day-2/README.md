Lessons from Day 2 of #100DaysOfDataEngineering

- Know your tools
- If you're getting caught up in details with no idea what's going on, question your assumptions
- Read the documentation, or at least skim most of it

Struggled to get much of anything done today, for very silly reasons. I intended to work myself through a SQL refresher. Things like various joins, maybe case statements. 

What happened was getting bogged down in learning Docker and my tools. I'm a Ubuntu fan and a command line junkie at heart, so DHH's [Omakub](https://omakub.org) was irresistible. Full of self confidence, I was convinced that starting Postgres in a Docker container with an initialization script with a practice database would be a piece of cake. 

Some things I ran into today:
- The seamless looking "Docker" app was really LazyDocker (which seems awesome, just not the tool I was expecting!)
- Example commands for tools (like Postgres) are not assuming that tool is in a container. Gotta connect to the container first
- Read the documentation around the practice resources you're using. Neon's practice PG Employees dataset was create with the `pgdump` utility, and those files don't load automatically in the standard postgres container when you dump them into the `docker-entrypoint-initdb.d` directory

About two hours later, I'm now querying the Titanic passenger data from a container that I can throw away and restart from a clean slate! Interesting fact: Mr. William Henry Tornquist was the only person aboard the Titanic who both paid no fare (he was an employee of the cruise line) and survived. The ship he was supposed to sail on had been delayed due to high coal costs, so he bummed a free ride on the Titanic.

#upskilling #dataengineering #softwareengineering

Links:
[Neon Practice datasets](https://github.com/neondatabase-labs/postgres-sample-dbs)
[Omakub](https://omakub.org)
