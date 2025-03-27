FROM docker.io/postgres:14
ADD https://github.com/ossc-db/pg_hint_plan/releases/download/REL14_1_4_0/pg_hint_plan14-1.4-1.el8.x86_64.rpm .
RUN  apt-get update -y ; apt-get install -y alien wget ; alien ./pg_hint_plan*.rpm ; dpkg -i pg-hint-plan*.deb
# copy the minimal files to a postgres image
FROM docker.io/postgres:14
COPY --from=0 /usr/pgsql-14/share/extension/pg_hint_plan.control /usr/share/postgresql/14/extension
COPY --from=0 /usr/pgsql-14/share/extension/pg_hint_plan--1.4.sql /usr/share/postgresql/14/extension
COPY --from=0 /usr/pgsql-14/lib/pg_hint_plan.so /usr/pgsql-14/lib/pg_hint_plan.so /usr/lib/postgresql/14/lib