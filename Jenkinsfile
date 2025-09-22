@Library('fanthreesixty@master') _

pipeline {
    agent {
        label 'docker'
    }
    
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['DEV', 'QA', 'PROD'],
            description: 'Select the target environment'
        )
    }
    
    stages {
        stage('Declarative: Checkout SCM') {
            steps {
                checkout scm
            }
        }
        
        stage('Set Environment') {
            steps {
                script {
                    switch(params.ENVIRONMENT) {
                        case 'DEV':
                            env.DB_URL = 'jdbc:postgresql://dev-fan360db.fanthreesixty.com:5432/fan360'
                            break
                        case 'QA':
                            env.DB_URL = 'jdbc:postgresql://qa-fan360db.fanthreesixty.com:5432/fan360'
                            break
                        case 'PROD':
                            env.DB_URL = 'jdbc:postgresql://produsa-fan360db.fanthreesixty.com:5432/fan360'
                            break
                        default:
                            error "Unknown environment: ${params.ENVIRONMENT}"
                    }
                    
                    echo "Environment: ${params.ENVIRONMENT}"
                    echo "Database URL: ${env.DB_URL}"
                }
            }
        }
        
        stage('Update') {
            steps {
                script {
                    def credentialId
                    switch(params.ENVIRONMENT) {
                        case 'DEV':
                            credentialId = 'integrations-admin-dev'
                            break
                        case 'QA':
                            credentialId = 'integrations-admin-qa'
                            break
                        case 'PROD':
                            credentialId = 'integrations-admin'
                            break
                        default:
                            error "Unknown environment: ${params.ENVIRONMENT}"
                    }
                    
                    echo "Using Jenkins credential: ${credentialId}"
                    
                    withCredentials([
                        usernamePassword(credentialsId: credentialId, usernameVariable: 'DB_USERNAME', passwordVariable: 'DB_PASSWORD')
                    ]) {
                        withEnv([
                            "DB_URL=${env.DB_URL}",
                            "DB_USERNAME=${DB_USERNAME}",
                            "DB_PASSWORD=${DB_PASSWORD}"
                        ]) {
                            runLiquibaseUpdate()
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}

def runLiquibaseUpdate() {
    docker.image('liquibase/liquibase:4.17.0').inside() {
        sh '''
            echo "Running Liquibase update..."

            echo "Attempting changelog-sync for baseline..."
            liquibase changelog-sync \
                --url=${DB_URL} \
                --changeLogFile=src/main/resources/db/changeLog.xml \
                --username=${DB_USERNAME} \
                --password=${DB_PASSWORD} \
                --databaseChangeLogLockTableName=databasechangeloglock \
                --databaseChangelogTableName=databasechangelog \
                --defaultSchemaName=integrations \
                --log-level=INFO || echo "changelog-sync completed or no baseline to sync"
            
            echo "Running update to apply new changesets..."
            liquibase update \
                --url=${DB_URL} \
                --changeLogFile=src/main/resources/db/changeLog.xml \
                --username=${DB_USERNAME} \
                --password=${DB_PASSWORD} \
                --databaseChangeLogLockTableName=databasechangeloglock \
                --databaseChangelogTableName=databasechangelog \
                --defaultSchemaName=integrations \
                --log-level=INFO
        '''
    }
}
