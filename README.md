# docker-pokemongo-bot
PokemonGo Bot in alpine linux docker.
build from https://github.com/PokemonGoF/PokemonGo-Bot

# Your Config Directory
PathToYouConfigDirectory/config.json (also path.gpx)
PathToYouConfigDirectory/web/userdata.js

# Run
docker run -d --name pokemongobot -p 8000:8000 -v PathToYouConfigDirectory:/config

# Fix catchable
docker exec pokemongobot touch /usr/src/app/web/catchable-UserName.json
