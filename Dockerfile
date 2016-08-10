FROM python:2.7-alpine

# Add build tools
RUN apk add --no-cache git build-base

# Make source directory
RUN mkdir -p /usr/src/app && mkdir -p /config/web

# Fix numpy compilation
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

# Get bot source and build
RUN apk add --no-cache git build-base python-dev py-virtualenv && \
	git clone --recursive -b master https://github.com/PokemonGoF/PokemonGo-Bot.git /usr/src/app && \
	cd /usr/src/app && \
	virtualenv . && \
	source bin/activate && \
	pip install --no-cache-dir -r requirements.txt && \
	apk del git build-base && \
	ln -s /usr/src/app/configs/ /config && \
	ln -s /usr/src/app/web/config/ /config/web

WORKDIR /config
VOLUME ["/config"]
EXPOSE 8000

CMD python -m SimpleHTTPServer 8000 &
ENTRYPOINT ["python", "-u", "/usr/src/app/pokecli.py"]
