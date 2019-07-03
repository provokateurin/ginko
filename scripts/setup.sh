#!/bin/bash
if ! [[ -x "$(command -v flutter)" ]]; then
  echo 'Error: flutter is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v dart)" ]]; then
  echo 'Error: dart is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v pub)" ]]; then
  echo 'Error: pub is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v dartfmt)" ]]; then
  echo 'Error: dartfmt is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v dartanalyzer)" ]]; then
  echo 'Error: dartanalyzer is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v node)" ]]; then
  echo 'Error: node is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v yarn)" ]]; then
  echo 'Error: yarn is not installed.' >&2
  exit 1
fi

cd server/js
yarn install
cd ../..
cd app
flutter packages get
cd ../tests
flutter packages get
cd ../models
pub get
cd ../server
pub get
cd ..
bash generate.sh