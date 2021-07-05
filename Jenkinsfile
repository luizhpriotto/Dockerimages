
pipeline {
    environment {
      imagename = "registry.sme.prefeitura.sp.gov.br/"
      branchname =  env.BRANCH_NAME.toLowerCase()
      registryCredential = 'regsme'
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
      stage('teste1'){
	      
        steps {
             sh "echo $imagename"
        }        
        
      }    
    }
}
