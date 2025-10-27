--liquibase formatted sql

--changeset liquibase:001-create-shopify-export-history-table
--comment: Create shopify_export_history table (migrated from seatgeek-api)
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='integrations' AND table_name='shopify_export_history';
CREATE TABLE integrations.shopify_export_history (
    id uuid NOT NULL,
    org_mnemonic text NOT NULL,
    file_type text NOT NULL,
    start_id text NULL,
    end_id text NULL,
    records_processed int NOT NULL,
    export_status text NOT NULL,
    failure_details text NULL,
    create_dt_tm timestamptz NOT NULL,
    updt_dt_tm timestamptz NOT NULL,
    active_ind bool NOT NULL default true,
    CONSTRAINT shopify_export_history_pk PRIMARY KEY (id)
);

--changeset liquibase:001-create-shopify-export-history-index
--comment: Create index for shopify_export_history
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM pg_indexes WHERE schemaname='integrations' AND indexname='shopify_org_mnemonic_file_type_export_status_idx';
CREATE INDEX shopify_org_mnemonic_file_type_export_status_idx ON integrations.shopify_export_history (org_mnemonic, file_type, export_status, create_dt_tm, active_ind);

