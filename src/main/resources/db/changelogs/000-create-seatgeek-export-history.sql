--liquibase formatted sql

--changeset liquibase:000-create-seatgeek-export-history-table
--comment: Create seatgeek_export_history table (migrated from seatgeek-api)
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='integrations' AND table_name='seatgeek_export_history';
CREATE TABLE integrations.seatgeek_export_history (
    id uuid NOT NULL,
    org_id uuid NOT NULL,
    file_type text NOT NULL,
    start_cursor text NULL,
    end_cursor text NULL,
    records_processed int NOT NULL,
    export_status text NOT NULL,
    failure_details jsonb NULL,
    create_dt_tm timestamptz NOT NULL,
    updt_dt_tm timestamptz NOT NULL,
    active_ind bool NOT NULL default true,
    CONSTRAINT seatgeek_export_history_pk PRIMARY KEY (id)
);

--changeset liquibase:000-create-seatgeek-export-history-index
--comment: Create index for seatgeek_export_history
--preconditions onFail:MARK_RAN
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM pg_indexes WHERE schemaname='integrations' AND indexname='seatgeek_org_id_file_type_idx';
CREATE INDEX seatgeek_org_id_file_type_idx ON integrations.seatgeek_export_history (org_id, file_type, active_ind);

