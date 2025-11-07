--liquibase formatted sql

--changeset rlokugamage:008-create-tm-full-pull-history
--comment: create table tm_full_pull_history
CREATE TABLE integrations.tm_full_pull_history (
    id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
    file_path TEXT NOT NULL UNIQUE,
    s3_location TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB
)