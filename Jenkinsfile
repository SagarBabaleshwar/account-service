podTemplate(cloud: 'kubernetes',label: 'kubernetes',
            containers: [
                    containerTemplate(name: 'podman', image: 'quay.io/containers/podman', privileged: true, command: 'cat', ttyEnabled: true)
					
            ]) 
{
node{
 def MAVEN_HOME = tool "mymaven"
 env.PATH = "${env.PATH}:${MAVEN_HOME}/bin"
 def now = new Date()
 env.TIME = now.format("yyMMdd.HHmm", TimeZone.getTimeZone('UTC'))
  
  stage('checkout'){  
       checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/SagarBabaleshwar/account-service.git']]])
  }
  
  stage('compile'){
      sh 'mvn clean compile'
  }
  
  
  stage('unit testing'){
      sh 'mvn test'
  }
  
  
  
    stage('Code quality analysis') 
	{
		withSonarQubeEnv('sagarsonar'){
                 sh 'mvn sonar:sonar -Dsonar.organization=sagarinfotech -Dsonar.projectKey=credit-service-sagarb'		
    		}
	 }

  	/*stage("Quality Gate"){
          timeout(time: 1, unit: 'HOURS') {
              def qg = waitForQualityGate()
              if (qg.status != 'OK') {
                  error "Pipeline aborted due to quality gate failure: ${qg.status}"
              }
          }
      }*/
	
	 stage('Code Build') 
	{
		sh 'mvn package'
		stash includes: 'Dockerfile', name: 'dfile'
		stash includes: 'target/', name: 'efile'
	 }
}

node('kubernetes'){
   container('podman') {
			stage('build')
			{
			unstash 'dfile'
			unstash 'efile'
			sh 'podman build -t quay.io/babaleshwarsagar/account-service:latest .'
			withCredentials([usernamePassword(credentialsId: 'babaleshwarsagar', passwordVariable: 'PWDD', usernameVariable: 'USER')]) {	
			sh 'podman login quay.io -u $USER -p $PWDD'
			}
			sh 'podman image push quay.io/babaleshwarsagar/account-service:latest'
			
		       }
	  }
  }
	


}
