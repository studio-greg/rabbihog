FROM ghcr.io/gleam-lang/gleam:v1.14.0-erlang-alpine AS build

# APP_NAME = `name` in gleam.toml; ENTRY = module containing main()
ARG APP_NAME=rabbihog
ARG ENTRY=rabbihog

WORKDIR /app
COPY gleam.toml manifest.toml ./
RUN gleam deps download
COPY src ./src
RUN gleam build --target javascript

COPY <<EOF /site/index.html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Studio Greg</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module">
      import { main } from "/js/${APP_NAME}/${ENTRY}.mjs";
      main();
    </script>
  </body>
</html>
EOF

RUN mkdir -p /site/js && cp -r build/dev/javascript/. /site/js/

FROM caddy:2-alpine
COPY <<'EOF' /etc/caddy/Caddyfile
{
	admin off
}

:8080 {
	root * /srv
	encode zstd gzip
	try_files {path} /index.html
	file_server
}
EOF
COPY --from=build /site /srv
EXPOSE 8080
