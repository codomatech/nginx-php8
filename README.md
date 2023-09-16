This is a docker image of the mainline version of nginx and the latest stable version of PHP, 
configured to work together and serve both static and PHP scripts.

# How to use
From the root directory of your site, the command looks like this
```bash
  docker run \
      -p 8080:80 \
      -v $PWD:/usr/share/nginx/html \
      codomatech/nginx-php8
```

---
A work of ❤️ by [Codoma.tech](https://www.codoma.tech/).

