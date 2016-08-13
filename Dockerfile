FROM python:2.7-alpine

WORKDIR /usr/src/app

# Add build tools
RUN apk add --no-cache git build-base tzdata

# Change timezone
ARG timezone=Asia/Bangkok
RUN echo $timezone > /etc/timezone && \
	cp /usr/share/zoneinfo/$timezone /etc/localtime

# Make source directory
RUN mkdir -p /usr/src/app && mkdir -p /config/web

# Fix numpy compilation
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

# Get bot source and build
RUN export botver=3731 && \
	apk add --no-cache git build-base python-dev && \
	git clone --recursive -b master https://github.com/PokemonGoF/PokemonGo-Bot.git /usr/src/app && \
	cd /usr/src/app && \
	pip install --no-cache-dir -r requirements.txt

# Get the encryption.so and move to right folder
RUN export botver=3731 && \
	wget http://pgoapi.com/pgoencrypt.tar.gz && \
	tar -xzvf pgoencrypt.tar.gz && \
	cd pgoencrypt/src/ && \
	make && \
	cd /usr/src/app && \
	mv pgoencrypt/src/libencrypt.so /usr/src/app/encrypt.so

# Finalize
RUN apk del git build-base tzdata && \
	rm -rf /usr/src/app/configs && \
	rm -rf /usr/src/app/web/config && \
	ln -s /config /usr/src/app/configs && \
	ln -s /config/web /usr/src/app/web/config

COPY entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

EXPOSE 8000

VOLUME ["/usr/app/configs", "/usr/src/app/web", "/config"]
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
