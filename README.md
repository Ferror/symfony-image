# symfony-image

## Docker sizes

* PHP 7.4 ![Docker Hub](https://badgen.net/docker/size/ferror/symfony-image/7.4)
* PHP 8.0 ![Docker Hub](https://badgen.net/docker/size/ferror/symfony-image/8.0)

## Use Case

```dockerfile
services:
    traefik:
        image: traefik:2.3
        container_name: "traefik"
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
        container_name: "symfony"
        image: ferror/symfony-image
        command: ["make", "run"]
        labels:
            - "traefik.enable=true"
            - "traefik.http.routers.symfony.rule=Host(`symfony.malcherczyk.localhost`)"
        volumes:
            - ./:/app:delegated
        networks:
            - ferror

networks:
    ferror:
        name: ferror
        driver: bridge
        ipam:
            driver: default
            config:
                - subnet: 192.168.10.0/24
```

```makefile
run:
	composer install --no-interaction --prefer-dist
	exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
```

Badges powered by [Badgen](https://badgen.net) - so if they fail - you know where to go
