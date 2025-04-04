#!/bin/bash

# run command: bash create_env.sh env.template

if [ ! -f "${1}" ] || [ ! $(basename ${1}) == 'env.template' ]; then >&2 echo "A path to a valid 'env.template' must be provided" && exit 1; fi
environment_base_file_name=$(basename ${1})
environment_base_rel_path=$(dirname ${1})
environment_base_abs_path=$(cd ${environment_base_rel_path} ; pwd -P)
environment_base_env_template="${environment_base_abs_path}/env.template"

# default functions
gen_password () { docker run --rm ubuntu:19.10 bash -c "head /dev/urandom | tr -dc A-Za-z0-9 | head -c ${1:-32}"; }
gen_htpasswd () { docker run --rm --entrypoint htpasswd registry:2 -C 6 -Bbn ${1} ${2}; }
gen_fernet_key () { docker run --rm continuumio/miniconda3 python3 -c 'from cryptography.fernet import Fernet; FERNET_KEY=Fernet.generate_key().decode(); print(str(FERNET_KEY))'; }

# source variables
source ${environment_base_env_template}

# print variables
LIST_OF_VARIABLES=$(grep -rhIEo 'export [^ =]+' ${environment_base_env_template} | cut -c 7- | env LC_COLLATE=C sort)

for x in ${LIST_OF_VARIABLES}
do
  if [ ${2:-''} == '-e' ]
  then
    echo "export ${x}='${!x}'"
  else
    echo "${x}=${!x}"
  fi
done
