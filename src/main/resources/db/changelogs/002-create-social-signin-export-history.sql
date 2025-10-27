--liquibase formatted sql

--changeset liquibase:002-create-social-sign-in-export-history-table
--comment: Create social_sign_in_export_history table (migrated from seatgeek-api)
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='integrations' AND table_name='social_sign_in_export_history';
CREATE TABLE integrations.social_sign_in_export_history (
    id uuid NOT NULL,
    org_mnemonic text NOT NULL,
    file_type text NOT NULL,
    start_tm timestamptz NULL,
    end_tm timestamptz NULL,
    records_processed int NOT NULL,
    export_status text NOT NULL,
    failure_details text NULL,
    create_dt_tm timestamptz NOT NULL,
    updt_dt_tm timestamptz NOT NULL,
    active_ind bool NOT NULL default true,
    CONSTRAINT social_sign_in_export_history_pk PRIMARY KEY (id)
);

--changeset liquibase:002-create-social-sign-in-export-history-index
--comment: Create index for social_sign_in_export_history
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM pg_indexes WHERE schemaname='integrations' AND indexname='social_sign_in_org_mnemonic_file_type_export_status_idx';
CREATE INDEX social_sign_in_org_mnemonic_file_type_export_status_idx ON integrations.social_sign_in_export_history (org_mnemonic, file_type, export_status, create_dt_tm, active_ind);

