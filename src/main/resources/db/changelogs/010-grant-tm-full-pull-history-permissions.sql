--liquibase formatted sql

--changeset cmccarson:010-grant-tm-full-pull-history-permissions
--comment: Grant privileges on tm_full_pull_history to airflow_app and integrations_group
GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, TRUNCATE, UPDATE
ON TABLE integrations.tm_full_pull_history
TO airflow_app;

GRANT SELECT
ON TABLE integrations.tm_full_pull_history
TO integrations_group;

