
pipeline {
    environment {
      branchname =  env.BRANCH_NAME.toLowerCase()
      registryCredential = 'regsme'
      imagename = "registry.sme.prefeitura.sp.gov.br/" + env.branchname + "/sme-sigpae-api"
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
	    
      stage('teste1'){
	      
        steps {
             sh "echo $branchname"
	     sh "echo $imagename"
        }        
        
      }    
    }
}
