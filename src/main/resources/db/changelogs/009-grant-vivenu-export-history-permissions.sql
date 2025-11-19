--liquibase formatted sql

--changeset cmccarson:009-grant-vivenu-export-history-permissions
--comment: Grant privileges on vivenu_export_history to airflow_app and integrations_group
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE
ON TABLE integrations.vivenu_export_history
TO airflow_app;

GRANT SELECT
ON TABLE integrations.vivenu_export_history
TO integrations_group;
