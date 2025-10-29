--liquibase formatted sql

--changeset cmccarson:006-create-vivenu-export-history-table
--comment: Create vivenu_export_history table for tracking Vivenu API export runs
CREATE TABLE integrations.vivenu_export_history (
    id UUID NOT NULL,
    org_mnemonic TEXT NOT NULL,
    export_type TEXT NOT NULL,
    last_updated_at TEXT,
    records_processed INTEGER NOT NULL,
    export_status TEXT NOT NULL,
    failure_details TEXT,
    create_dt_tm TIMESTAMPTZ NOT NULL,
    updt_dt_tm TIMESTAMPTZ NOT NULL,
    active_ind BOOLEAN NOT NULL DEFAULT true
);

ALTER TABLE integrations.vivenu_export_history ADD CONSTRAINT vivenu_export_history_pk PRIMARY KEY (id);

-- Index optimized for the main query: finding latest successful export by org/type
CREATE INDEX vivenu_export_lookup_idx ON integrations.vivenu_export_history 
(org_mnemonic, export_type, export_status, active_ind, create_dt_tm DESC);
