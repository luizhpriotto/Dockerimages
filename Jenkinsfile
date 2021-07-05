
pipeline {
    environment {
      imagename = "registry.sme.prefeitura.sp.gov.br/"+env.BRANCH_NAME.toLowerCase()+"/sme-sigpae-api"
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
      stage{
        
        steps {
             sh "echo $imagename"
        }        
        
      }    
    }
}
