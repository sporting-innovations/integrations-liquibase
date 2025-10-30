@Library('fanthreesixty@master') _

pipeline {
    agent {
        label 'docker'
    }
    
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['PROD', 'QA', 'DEV'],
            description: 'Select the target environment (PROD is default for main branch)'
        )
    }
    
    stages {
        stage('Declarative: Checkout SCM') {
            steps {
                checkout scm
            }
        }
        
        stage('Validate Branch') {
            steps {
                script {
                    if (env.BRANCH_NAME != 'main') {
                        error "This pipeline can only run on the 'main' branch. Current branch: ${env.BRANCH_NAME}"
                    }
                    
                    if (params.ENVIRONMENT == 'PROD' && env.BRANCH_NAME != 'main') {
                        error "PROD deployments are only allowed from the 'main' branch"
                    }
                    
                    echo "Branch validation passed: ${env.BRANCH_NAME}"
                }
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
                    // Require manual approval before running PROD updates
                    if (params.ENVIRONMENT == 'PROD') {
                        timeout(time: 5, unit: 'MINUTES') {
                            input message: "Deploy Liquibase changes to PROD?\n\nBranch: ${env.BRANCH_NAME}\nDatabase: ${env.DB_URL}", 
                                  ok: 'Deploy to PROD'
                        }
                    }

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
                        runLiquibaseUpdate()
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
            liquibase --search-path=src/main/resources/db \
                --database-changelog-lock-table-name=databasechangeloglock \
                --database-changelog-table-name=databasechangelog \
                --log-level=INFO \
                update \
                --changelog-file=changeLog.xml \
                --url=${DB_URL} \
                --username=${DB_USERNAME} \
                --password=${DB_PASSWORD} \
                --default-schema-name=integrations
        '''
    }
}
