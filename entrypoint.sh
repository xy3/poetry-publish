#!/bin/bash

set -e

if [ $1 != 'latest' ]; then
  pyenv latest install $1
  pyenv latest global $1
  pyenv rehash
fi

if [ -z $8 ]; then
  pre=""
else
  pre="--pre"
fi

if [ $2 != 'latest' ]; then
  pip install poetry$2 $pre
else
  pip install poetry $pre
fi

if [ -z $7 ]; then
  poetry install
else
  poetry install --no-dev
fi

version=$(git describe --tags --abbrev=0)
poetry version "${version}"

if [ -z $6 ]; then
  poetry build
else
  poetry build --format $6
fi

if [ -z $4 ] || [ -z $5 ]; then
  poetry config pypi-token.pypi $3
  poetry publish
else
  poetry config pypi-token.$4 $3
  poetry config repositories.$4 $5
  poetry publish --repository $4
fi
