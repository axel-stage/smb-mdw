# Small & Medium Business Modern Data Warehouse

A blueprint for a modern data warehouse (MDW) architecture designed for small and medium-sized businesses (SMBs).

## Overview

**SMB MDW** provides a production-oriented data platform for ingesting, transforming, and serving business data for analytics and reporting.

The project demonstrates modern data engineering and DevOps practices, including:

- Modern data architecture
  - Layered architecture with raw, staging, and curated layers

- ELT data ingestion pipelines
  - Automated ingestion from source systems into the data warehouse

- Data modeling
  - dimensional modeling, and reusable dbt models

- Data quality and validation
  - Schema validation, data contracts, freshness checks, and automated quality tests

- Workflow orchestration
  - Dependency-aware DAGs, scheduling, retries, backfills, and failure handling

- CI/CD
  - lint → test → build → deploy

- Observability
  - Logs, metrics, monitoring

- Testing
  - dbt tests, unit tests, integration tests, data-quality checks

- Security
  - Secrets management, RBAC, dependency scanning

- Version control
  - Git for code, SQL, dbt models, DAGs, infrastructure, and configuration

- Containerization
  - Dockerized services with reproducible development and deployment environments

## Goals

The goal is to demonstrate how a modern, maintainable data warehouse can be designed for an SMB environment while keeping cost, infrastructure complexity, and operational overhead manageable.

## Tech Stack
- **Data Warehouse:** DuckLake
- **Transformation:** dbt
- **Orchestration:** Apache Airflow

## AI-Assisted Documentation
Parts of this README were written and refined with the assistance of AI to improve readability, grammar, and spelling. The project concept, design, implementation, and all technical decisions are entirely my own. All AI-assisted content was reviewed, edited, and approved by me to ensure it accurately reflects the project.

## Project Status
🚧 **Work in Progress**