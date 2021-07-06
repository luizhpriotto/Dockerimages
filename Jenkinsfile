pipeline {
    environment {
      branchname =  env.BRANCH_NAME.toLowerCase()
      registryCredential = 'regsme'
      kubeconfig = "${env.branchname == 'master' ? 'config_prd' : 'unknow' }"
      kubeconfig = "${env.branchname == 'main' ? 'config_prd' : 'unknow' }"
      kubeconfig = "${env.branchname == 'homolog' ? 'config_hom' : 'unknow' }"
      kubeconfig = "${env.branchname == 'development' ? 'config_dev' : 'unknow' }"
      imagetag = "${env.branchname == 'main' ? 'latest' : 'unknow' }"
      imagetag = "${env.branchname == 'master' ? 'latest' : 'unknow' }"
      imagetag = "${env.branchname == 'homolog' ? 'homolog' : 'unknow' }"
      imagetag = "${env.branchname == 'development' ? 'dev' : 'unknow' }"
    }
  
    agent {
      node {
        label 'python-36-rc'
      }
    }

    options {
      buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
      disableConcurrentBuilds()
      skipDefaultCheckout()
    }
  
    stages {

        stage('CheckOut') {            
            steps {
              checkout scm
            }            
        }

        stage('AmbienteTestes') {
            agent {
                label 'master'
            }
            steps {
                script {
                    CONTAINER_ID = sh (script: 'docker ps -q --filter "name=terceirizadas-db"',returnStdout: true).trim()
                    if (CONTAINER_ID) {
                        sh "echo nome é: ${CONTAINER_ID}"
                        sh "docker rm -f ${CONTAINER_ID}"
                        sh 'docker run -d --rm --cap-add SYS_TIME --name terceirizadas-db --network python-network -p 5432 -e TZ="America/Sao_Paulo" -e POSTGRES_DB=terceirizadas -e POSTGRES_PASSWORD=adminadmin -e POSTGRES_USER=postgres postgres:9-alpine'
                    } 
                    else {
                        sh 'docker run -d --rm --cap-add SYS_TIME --name terceirizadas-db --network python-network -p 5432 -e TZ="America/Sao_Paulo" -e POSTGRES_DB=terceirizadas -e POSTGRES_PASSWORD=adminadmin -e POSTGRES_USER=postgres postgres:9-alpine'
                    }
                }
            }
        }
        
        stage('Testes') {
          when { branch 'homolog' }
          steps {
             sh 'pip install --user pipenv'
             sh 'pipenv install --dev'
             sh 'pipenv run pytest'
             sh 'pipenv run flake8'
          }
          post {
            success{
              //  Publicando arquivo de cobertura
              publishCoverage adapters: [coberturaAdapter('coverage.xml')], sourceFileResolver: sourceFiles('NEVER_STORE')
            }
          }
        }

        stage('AnaliseCodigo') {
	      when { branch 'homolog' }
          steps {
            sh 'echo "[ INFO ] Iniciando analise Sonar..." && sonar-scanner \
              -Dsonar.projectKey=SME-Terceirizadas \
              -Dsonar.sources=. \
              -Dsonar.host.url=http://sonar.sme.prefeitura.sp.gov.br \
              -Dsonar.login=0d279825541065cf66a60cbdfe9b8a25ec357226'
          }
        }

        stage('Build') {
          when { anyOf { branch 'master'; branch 'main'; branch "story/*"; branch 'development'; branch 'release';  } } 
          steps {
            script {
              def imagename = [ "registry.sme.prefeitura.sp.gov.br/${env.branchname}/sme-sigpae-api", "registry.sme.prefeitura.sp.gov.br/${env.branchname}/sme-sigpae-api2" ]               
              def steps = imagename.collectEntries {
                    ["image $it": job(it)]
               }
              parallel steps
            }
          }
        }
	    
        stage('Deploy'){
            when { anyOf {  branch 'master'; branch 'main'; branch "story/*"; branch 'development'; branch 'release';  } }        
            steps {
                script{
                    if ( env.branchname == 'main' ||  env.branchname == 'master' || env.branchname == 'homolog' ) {
                        sendTelegram("🤩 [Deploy] Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nStatus: Me aprove! \nLog: \n${env.BUILD_URL}")
                        timeout(time: 24, unit: "HOURS") {
                            input message: 'Deseja realizar o deploy?', ok: 'SIM', submitter: 'admin'
                        }
                        withCredentials([file(credentialsId: "${kubeconfig}", variable: 'config')]){
                            sh('cp $config '+"$home"+'/.kube/config')
                            sh( 'kubectl get nodes')
                            sh('rm -f '+"$home"+'/.kube/config')
                        }
                    }
                    else{
                        withCredentials([file(credentialsId: "${kubeconfig}", variable: 'config')]){
                            sh('cp $config '+"$home"+'/.kube/config')
                            sh( 'kubectl get nodes')
                            sh('rm -f '+"$home"+'/.kube/config')
                        }
                    }
                }
            }           
        }    
    }

  post {
    success {
      sendTelegram("🚀 Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nStatus: Success \nLog: \n${env.BUILD_URL}console")
    }
    unstable {
      sendTelegram("💣 Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nStatus: Unstable \nLog: \n${env.BUILD_URL}console")
    }
    failure {
      sendTelegram("💥 Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nStatus: Failure \nLog: \n${env.BUILD_URL}console")
    }
    aborted {
      sendTelegram ("😥 Job Name: ${JOB_NAME} \nBuild: ${BUILD_DISPLAY_NAME} \nStatus: Aborted \nLog: \n${env.BUILD_URL}console")
    }
  }
}
def sendTelegram(message) {
    def encodedMessage = URLEncoder.encode(message, "UTF-8")

    withCredentials([string(credentialsId: 'telegramToken', variable: 'TOKEN'),
    string(credentialsId: 'telegramChatId', variable: 'CHAT_ID')]) {

        response = httpRequest (consoleLogResponseBody: true,
                contentType: 'APPLICATION_JSON',
                httpMode: 'GET',
                url: 'https://api.telegram.org/bot'+"$TOKEN"+'/sendMessage?text='+encodedMessage+'&chat_id='+"$CHAT_ID"+'&disable_web_page_preview=true',
                validResponseCodes: '200')
        return response
    }
}
def job(image){
    return{
        dockerImage = docker.build image
        docker.withRegistry( 'https://registry.sme.prefeitura.sp.gov.br', registryCredential ) {
        dockerImage.push(imagetag)
        }
        sh "docker rmi $imagename:$imagetag"
    }
}
