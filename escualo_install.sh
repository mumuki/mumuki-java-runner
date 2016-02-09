#/bin/bash
REV=$1

echo "[Escualo::JunitServer] Fetching GIT revision"
echo -n $REV > version

echo "[Escualo::JunitServer] Pulling docker image"
docker pull mumuki/mumuki-junit-worker