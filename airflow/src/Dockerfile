FROM --platform=linux/amd64 apache/airflow:2.10.5-python3.12

ARG MAIN_PYTHON_VERSION=3.12
ARG MAIN_AIRFLOW_VERSION=2.10.5

ARG RUNTIME_APT_DEPS_INSTALL="\
       build-essential \
       curl \
       libpq-dev \
       dnsutils \
       git"

ARG CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${MAIN_AIRFLOW_VERSION}/constraints-${MAIN_PYTHON_VERSION}.txt"

ENV RUNTIME_APT_DEPS=${RUNTIME_APT_DEPS}
ENV SCRIPTS=/scripts

USER root
RUN set -ex \
  && apt-get update -y \
  # installing apt dependencies
  && apt-get install -y --no-install-recommends \
        ${RUNTIME_APT_DEPS} \
  # removing unecessary files
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -vrf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY ./python_requirements.txt ${SCRIPTS}/python_requirements.txt
COPY ./airflow_requirements.txt ${SCRIPTS}/airflow_requirements.txt
RUN pip3 install --no-cache-dir -r "${SCRIPTS}/python_requirements.txt" --constraint ${CONSTRAINT_URL}
RUN pip3 install --no-cache-dir apache-airflow["$(grep -v '^#' ${SCRIPTS}/airflow_requirements.txt | tr -s "( |\n)" , | head -c -1)"]==${AIRFLOW_VERSION} --constraint ${CONSTRAINT_URL}
