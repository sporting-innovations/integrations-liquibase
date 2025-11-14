--liquibase formatted sql

--changeset cmccarson:009-grant-vivenu-export-history-permissions
--comment: Grant airflow_app DML privileges on vivenu_export_history
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE
ON TABLE integrations.vivenu_export_history
TO airflow_app;
