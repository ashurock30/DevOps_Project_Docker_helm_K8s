pipeline{

    agent {
        label 'DEVLINUX'
    } 

    parameters {
        booleanParam description: 'Set to True if you want to perform the SonarQube Scan & Quality Gate Check', name: 'Sonarqube_Scan'
        booleanParam description: 'Set to True if you want to Used Nexus', name: 'Nexus_Enabled'
    }
    
    stages {
        stage('Git Checkout'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ashurock30/DevOps_Project_Docker_helm_K8s.git']]])
            }
        }

        stage('Stage To Decide to use Nexus or Not') {
            steps{
                script {
                    if (params.Nexus_Enabled) {
                        env.MAVEN_SETTINGS_CONFIG = 'maven-settings'
                        echo 'Using Nexus......'
                    }
                    else {
                        env.MAVEN_SETTINGS_CONFIG = ''
                        echo "Not Using Nexus......"
                    }
                }
            }
        }

        stage('UNIT testing'){
            steps{ 
                script{
                    withMaven(globalMavenSettingsConfig: '', jdk: 'JDK11', maven: 'Maven-3.9.5', mavenSettingsConfig: "${MAVEN_SETTINGS_CONFIG}", traceability: true) {
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('Integration testing'){
            steps{
                script{
                    withMaven(globalMavenSettingsConfig: '', jdk: 'JDK11', maven: 'Maven-3.9.5', mavenSettingsConfig: "${MAVEN_SETTINGS_CONFIG}", traceability: true) {
                        sh 'mvn verify -DskipUnitTests'
                    }
                }
            }
        }

        stage('Maven build'){
            steps{ 
                script{
                    withMaven(globalMavenSettingsConfig: '', jdk: 'JDK11', maven: 'Maven-3.9.5', mavenSettingsConfig: "${MAVEN_SETTINGS_CONFIG}", traceability: true) {
                        sh 'mvn clean install'
                    }
                }
            }
        }

        stage('SonarQube Scan '){
            when {
                environment name: 'Sonarqube_Scan', value: 'true'
            }
            steps{
               script{
                    withSonarQubeEnv(credentialsId: 'sonar-test', installationName:'SonarQube') {
                        withMaven(globalMavenSettingsConfig: '', jdk: 'JDK11', maven: 'Maven-3.9.5', mavenSettingsConfig: '', traceability: true) { 
                            sh 'mvn clean package sonar:sonar -Dsonar.projectKey=org.springframework.boot:spring-boot-starter-parent -Dsonar.projectName="Sonar-Docker-Test-App"' 
                        }
                    }
               }
            }
        }

        stage('Quality Gate Status'){    
            when {
                environment name: 'Sonarqube_Scan', value: 'true'
            }    
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-test'
                }
            }
        }
    }
        
}