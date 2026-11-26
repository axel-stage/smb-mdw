
PYTHON_VERSION=3.14
PROJECT_PATH=~/projects/smb_mdw
DBT_PROJECT_NAME=ducklake
DBT_PROFILE_NAME=dbt-duckdb
DBT_ENTITY=trade

# python project and package manager
uv python install ${PYTHON_VERSION}
uv python pin ${PYTHON_VERSION}
uv init --bare
uv add -r requirements.txt

# activate virtuall env
source .venv/bin/activate && clear

# create folder
if [[ ! -d dbt/ ]]
then
  echo "create dbt/ folder"
  mkdir dbt/
fi

cat <<EOF > ~/.dbt/profiles.yml
ducklake:
  target: dev
  outputs:
    dev:
      type: duckdb
      database: lakehouse
      threads: 4

      extensions:
        - ducklake
        - postgres
        - httpfs
        - parquet

      secrets:
        - type: s3
          key_id: "{{ env_var('MINIO_ACCESS_KEY') }}"
          secret: "{{ env_var('MINIO_SECRET_KEY') }}"
          endpoint: "{{ env_var('MINIO_ENDPOINT') }}"
          use_ssl: false
          url_style: path
        - type: postgres
          name: catalog_credentials
          host: "{{ env_var('POSTGRES_HOST') }}"
          port: "{{ env_var('POSTGRES_PORT') }}"
          database: "{{ env_var('POSTGRES_DB') }}"
          user: "{{ env_var('POSTGRES_USER') }}"
          password: "{{ env_var('POSTGRES_PASSWORD') }}"
        - type: ducklake
          name: lakehouse
          metadata_path: ""
          data_path: "s3://smb-mdw/lakehouse/"
          metadata_parameters:
            TYPE: postgres
            SECRET: catalog_credentials
            SCHEMA: metadata

      attach:
        - path: "ducklake:lakehouse"
          alias: lakehouse
          is_ducklake: True
EOF

cat ~/.dbt/profiles.yml

# dbt
#####

cd dbt/ && pwd

# init project
dbt init ${DBT_PROJECT_NAME} --profile ${DBT_PROFILE_NAME}

# move connection config into project folder
cp ~/.dbt/profiles.yml .

# clean init artifacts
rm -r ${DBT_PROJECT_NAME}/models/example
rm ${DBT_PROJECT_NAME}/dbt_project.yml
rm ${DBT_PROJECT_NAME}/.gitignore
rm ${DBT_PROJECT_NAME}/README.md
rm ~/.dbt/profiles.yml

# project config
################
cat <<EOF > dbt_project.yml
name: ducklake
version: "0.1.0"
config-version: 2
profile: ducklake

model-paths: ["ducklake/models"]
analysis-paths: ["ducklake/analyses"]
test-paths: ["ducklake/tests"]
seed-paths: ["ducklake/seeds"]
macro-paths: ["ducklake/macros"]
snapshot-paths: ["ducklake/snapshots"]

clean-targets:
  - "target"
  - "dbt_packages"
  - "logs"

models:
  ducklake:
    bronze:
      +schema: bronze
      +materialized: table
    silver:
      +schema: silver
      +materialized: table
    gold:
      +schema: gold
      +materialized: table
EOF

# test
######
dbt debug

# dbt packages
##############
# Check https://github.com/metaplane/dbt-expectations/releases for the latest release

cat <<EOF > packages.yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.3
  - package: metaplane/dbt_expectations
    version: 0.10.10
EOF

dbt deps

# postprocess
#############

# create model structure
mkdir -p ${DBT_PROJECT_NAME}/models/bronze
mkdir -p ${DBT_PROJECT_NAME}/models/silver
mkdir -p ${DBT_PROJECT_NAME}/models/gold

touch ${DBT_PROJECT_NAME}/models/bronze/_${DBT_ENTITY}_doc.md
touch ${DBT_PROJECT_NAME}/models/bronze/_${DBT_ENTITY}_model.yml
touch ${DBT_PROJECT_NAME}/models/bronze/_${DBT_ENTITY}_source.yml
touch ${DBT_PROJECT_NAME}/models/bronze/bronze_${DBT_ENTITY}.sql

# loads raw data or reference data into your project
dbt seed

cd ..


# generate dummy data
uvx jafgen
