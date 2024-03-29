# symfony-image

## Docker sizes

| Image | Size |
| ----- | ---- |
| PHP 7.4 | ![Docker Hub](https://badgen.net/docker/size/ferror/symfony-image/7.4)      |
| PHP 8.0 | ![Docker Hub](https://badgen.net/docker/size/ferror/symfony-image/8.0)      |
| PHP 8.1 | ![Docker Hub](https://badgen.net/docker/size/ferror/symfony-image/8.1)      |
| GRPC    | ![Docker Hub](https://badgen.net/docker/size/ferror/symfony-image/8.0-grpc) |
| DEV     | ![Docker Hub](https://badgen.net/docker/size/ferror/symfony-image/dev)      |

## Use Case
### Docker Compose
```dockerfile
services:
    traefik:
        image: traefik:2.3
        command:
            - "--log.level=DEBUG"
            - "--api.insecure=true"
            - "--providers.docker=true"
            - "--providers.docker.exposedbydefault=false"
            - "--entrypoints.web.address=:80"
        ports:
            - "80:80"
            - "8080:8080"
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock:ro
        networks:
            ferror:
                ipv4_address: 192.168.10.2

    symfony:
        image: ferror/symfony-image:{IMAGE_VERSION}
        command: ["make", "run"]
        labels:
            - "traefik.enable=true"
            - "traefik.http.routers.symfony.rule=Host(`symfony.malcherczyk.localhost`)"
        volumes:
            - ./:/app:delegated
        depends_on:
            - traefik
	networks:
            - ferror

networks:
    ferror:
        driver: bridge
        ipam:
            driver: default
            config:
                - subnet: 192.168.10.0/24
```

### Makefile
```makefile
run:
	composer install --no-interaction --prefer-dist
	exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
```

## Development
### Build Dockerfile Image

`docker build -t docker-name .`

### Get into the container

`docker run -i -t docker-name`

Badges powered by [Badgen](https://badgen.net) - so if they fail - you know where to go
