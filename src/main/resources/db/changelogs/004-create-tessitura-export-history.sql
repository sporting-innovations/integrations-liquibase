--liquibase formatted sql

--changeset liquibase:004-create-tessitura-export-history-table
--comment: Create tessitura_export_history table (manually created, now documented)
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='integrations' AND table_name='tessitura_export_history';
CREATE TABLE integrations.tessitura_export_history (
    id UUID NOT NULL,
    org_mnemonic TEXT NOT NULL,
    start_date TEXT,
    end_date TEXT,
    records_processed INTEGER NOT NULL,
    export_status TEXT NOT NULL,
    failure_details TEXT,
    create_dt_tm TIMESTAMPTZ NOT NULL,
    updt_dt_tm TIMESTAMPTZ NOT NULL,
    active_ind BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT tessitura_export_history_pk PRIMARY KEY (id)
);


--changeset liquibase:004-create-tessitura-export-history-index
--comment: Create index for tessitura_export_history
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM pg_indexes WHERE schemaname='integrations' AND indexname='tessitura_org_mnemonic_export_status_idx';
CREATE INDEX tessitura_org_mnemonic_export_status_idx 
ON integrations.tessitura_export_history (org_mnemonic, export_status, create_dt_tm, active_ind);
