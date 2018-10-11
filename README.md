Libuv + Gauche = Violet
=======================

Overview
--------

```
Libuv <-> makiki <-> File I/O
                 <-> Network I/O
```

Run
---

```
$ docker-compose up
```

Server runs on http://localhost:2222


Requirements
------------

* libgauche
* libuv

Depends on
----------

* [Kaheka](https://github.com/torus/Gauche-makiki) -- Gauche makiki with virtual socket
* [Rheingau](https://github.com/torus/gauche-rheingau) -- a dumb package manager for Gauche

References
----------
* [An Introduction to libuv](https://nikhilm.github.io/uvbook/index.html)
