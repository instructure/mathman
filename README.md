# MathMan by Instructure
## Introduction
This is a simple microservice that converts LaTeX formulae to MathML and SVG.
It can either be run locally via `docker-compose`, or on Amazon Lambda.

## Quick start (for Docker)
1. Install docker and docker-compose.
2. Run `docker-compose up`.

This will launch the microservice, along with a Redis cache.

### Notes
This image is based on `instructure/node-passenger:4.3`, so most of the
configuration options for that container also apply to this one.

## Quick start (for Amazon Lambda)
Todo.
