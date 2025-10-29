--liquibase formatted sql

--changeset liquibase:005-create-interceptor-config-table
--comment: Create interceptor_config table (migrated from seatgeek-api)
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='integrations' AND table_name='interceptor_config';
CREATE TABLE integrations.interceptor_config (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    org TEXT NOT NULL,
    category TEXT NOT NULL,
    vendor TEXT NOT NULL,
    src_prefix TEXT NOT NULL,
    last_key TEXT,
    cursor TIMESTAMPTZ,
    create_dt_tm TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    updt_dt_tm TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);

