FROM alpine:latest

# Setup userland
RUN addgroup -S amon \
  && adduser -h /etc/opt/amon/ -s /bin/false -S -D amon -G amon

RUN mkdir -p /opt/amon \
  && mkdir -p /var/log/amon \
  && mkdir -p /etc/opt/amon

RUN chown -R amon:amon /opt/amon \
  && chown -R amon:amon /etc/opt/amon \
  && chown -R amon:amon /var/log/amon

RUN apk --no-cache --update add \
  gcc \
  python3 \
  python3-dev \
  git \
  postgresql-dev \
  musl-dev \
  nginx

WORKDIR /opt/amon

RUN git clone https://github.com/amonapp/amon.git . \
  && git checkout master

RUN pip3 install -r ./requirements.txt

COPY ./docker-entrypoint.sh /entrypoint

ENTRYPOINT ["/entrypoint"]

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

CMD ["gunicorn", "wsgi", "-c", "./gunicorn.conf"]
