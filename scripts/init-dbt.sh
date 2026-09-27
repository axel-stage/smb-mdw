
PYTHON_VERSION=3.14
PROJECT_PATH=~/projects/smb_mdw
DBT_PROJECT_NAME=mdw
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

if [[ ! -d duckdb/ ]]
then
  echo "create dbt/ folder"
  mkdir duckdb/
fi

cat <<EOF > ~/.dbt/profiles.yml
${DBT_PROFILE_NAME}:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: "${PROJECT_PATH}/duckdb/sandbox.duckdb"
      schema: main
      threads: 4
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
name: "${DBT_PROJECT_NAME}"
version: "0.1.0"
config-version: 2
profile: "${DBT_PROFILE_NAME}"
model-paths: ["${DBT_PROJECT_NAME}/models"]
analysis-paths: ["${DBT_PROJECT_NAME}/analyses"]
test-paths: ["${DBT_PROJECT_NAME}/tests"]
seed-paths: ["${DBT_PROJECT_NAME}/seeds"]
macro-paths: ["${DBT_PROJECT_NAME}/macros"]
snapshot-paths: ["${DBT_PROJECT_NAME}/snapshots"]
clean-targets:
  - "target"
  - "dbt_packages"
  - "logs"
models:
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