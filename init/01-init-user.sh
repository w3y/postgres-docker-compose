#!/bin/bash

set -o errexit

readonly REQUIRED_ENV_VARS=(
  "DB_NAME"
  "DB_USERNAME"
  "DB_PASSWORD"
  "POSTGRES_USER"
  "POSTGRES_PASSWORD")

main() {
  check_env_vars_set
  init_user_and_db
}

check_env_vars_set() {
  for required_env_var in ${REQUIRED_ENV_VARS[@]}; do
    if [[ -z "${!required_env_var}" ]]; then
      echo "Error:
    Environment variable '$required_env_var' not set.
    Make sure you have the following environment variables set:
      ${REQUIRED_ENV_VARS[@]}
Aborting."
      exit 1
    fi
  done
}

init_user_and_db() {
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
     CREATE USER $DB_USERNAME WITH PASSWORD '$DB_PASSWORD';
     CREATE DATABASE $DB_NAME;
     GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USERNAME;
EOSQL
}

main "$@"