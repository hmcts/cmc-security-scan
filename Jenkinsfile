#!groovy

java.lang.String dockerCompose = 'docker-compose -f integration-tests/docker-compose.yml -f docker-compose.yml -p security-scan'
java.lang.String serviceURL = 'https://www-local.moneyclaim.reform.hmcts.net:3000'

properties(
  [[$class: 'GithubProjectProperty', displayName: 'Security scan', projectUrlStr: 'https://git.reform.hmcts.net/cmc/security-scan/'],
   pipelineTriggers([
     [$class: 'GitHubPushTrigger'],
     [$class: 'hudson.triggers.TimerTrigger', spec: 'H 1 * * *']
   ])]
)

node {
  stage('Checkout') {
    deleteDir()
    checkout scm
    checkoutIntegrationTests()
  }

  stage('Update images') {
    sh "${dockerCompose} pull"
  }

  try {
    stage('Start environment') {
      sh "${dockerCompose} up -d zap-proxy remote-webdriver citizen-frontend"
    }

    stage('Run integration tests') {
      sh 'mkdir -p output'
      sh "${dockerCompose} up --no-deps --no-color integration-tests"

      def testExitCode = steps.sh returnStdout: true,
        script: "${dockerCompose} ps -q integration-tests | xargs docker inspect -f '{{ .State.ExitCode }}'"

      if (testExitCode.toInteger() > 0) {
        archiveArtifacts 'output/*.png'
        error('Integration tests failed')
      }

      sh 'mkdir -p reports'
      sh "${dockerCompose} exec zap-proxy zap-cli report -o /zap/reports/integration-tests-scan.html -f html"
      archiveArtifacts 'reports/integration-tests-scan.html'
    }

    stage('Run active scan') {
      sh "${dockerCompose} exec zap-proxy zap-cli open-url ${serviceURL}"
      sh "${dockerCompose} exec zap-proxy zap-cli active-scan --scanners all --recursive ${serviceURL}"
      sh "${dockerCompose} exec zap-proxy zap-cli report -o /zap/reports/active-scan.html -f html"
      archiveArtifacts 'reports/active-scan.html'
    }
  } finally {
    sh "mkdir -p output && ${dockerCompose} logs --no-color > output/logs.txt"
    archiveArtifacts 'output/logs.txt'

    sh "${dockerCompose} down --remove-orphans"
  }
}

private void checkoutIntegrationTests() {
  checkout([
    $class: 'GitSCM',
    branches: [[name: 'master']],
    userRemoteConfigs: [[url: 'git@git.reform.hmcts.net:cmc/integration-tests.git']],
    extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'integration-tests']]
  ])
}
