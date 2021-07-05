
pipeline {
    environment {
      branchname =  env.BRANCH_NAME.toLowerCase()
      registryCredential = 'regsme'
      imagename = "registry.sme.prefeitura.sp.gov.br/${env.branchname}/sme-sigpae-api"
      kubeconfig = "${env.branchname == 'main' ? 'config_dev' : 'config_hom'}"
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
        stage('.oO CheckOut Oo.') {            
            steps {
            checkout scm
            }            
        }
	    
        stage('Acesso Cluster'){
            when { anyOf { branch 'main'; branch "story/*"; branch 'development'; branch 'release';  } }        
            steps {
                script{
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
