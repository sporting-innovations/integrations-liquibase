--liquibase formatted sql

--changeset liquibase:003-create-fanatics-export-history-table
--comment: Create fanatics_export_history table (migrated from seatgeek-api)
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='integrations' AND table_name='fanatics_export_history';
CREATE TABLE integrations.fanatics_export_history (
    id uuid NOT NULL,
    org_mnemonic text NOT NULL,
    file_type text NOT NULL,
    records_processed int NOT NULL,
    export_status text NOT NULL,
    failure_details text NULL,
    create_dt_tm timestamptz NOT NULL,
    updt_dt_tm timestamptz NOT NULL,
    active_ind bool NOT NULL default true,
    CONSTRAINT fanatics_export_history_pk PRIMARY KEY (id)
);

