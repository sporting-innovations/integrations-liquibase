--liquibase formatted sql

--changeset cmccarson:007-add-export-type-to-tessitura-export-history
--comment: Add export_type column to tessitura_export_history
ALTER TABLE integrations.tessitura_export_history
ADD COLUMN export_type TEXT;

--changeset cmccarson:007-backfill-export-type-tessitura
--comment: Backfill existing rows as 'tickets' to maintain continuity
UPDATE integrations.tessitura_export_history
SET export_type = 'tickets'
WHERE export_type IS NULL;

--changeset cmccarson:007-index-export-type-tessitura
--comment: Add index including export_type for query performance
CREATE INDEX tessitura_org_export_type_status_idx 
ON integrations.tessitura_export_history (org_mnemonic, export_type, export_status, create_dt_tm, active_ind);


