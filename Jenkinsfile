#!groovy

properties(
  [[$class: 'GithubProjectProperty', displayName: 'Security scan', projectUrlStr: 'https://github.com/hmcts/cmc-security-scan'],
   pipelineTriggers([
     [$class: 'GitHubPushTrigger'],
     [$class: 'hudson.triggers.TimerTrigger', spec: 'H 1 * * *']
   ])]
)

def secrets = [
  [$class: 'VaultSecret', path: 'secret/test/cc/payment/api/gov-pay-keys/cmc', secretValues:
    [
      [$class: 'VaultSecretValue', envVar: 'GOV_PAY_AUTH_KEY_CMC', vaultKey: 'value']
    ]
  ],
  [$class: 'VaultSecret', path: 'secret/dev/cmc/notify/integration-tests/test_mode_api_key', secretValues:
    [
      [$class: 'VaultSecretValue', envVar: 'GOV_NOTIFY_API_KEY', vaultKey: 'value']
    ]
  ]
]

String dockerCompose = "docker-compose -f integration-tests/docker-compose.yml -f docker-compose.yml --project-name ${env.BUILD_TAG}"
String execParams = '-u $(id -u) -T'
GString exec = "exec ${execParams}"
env.COMPOSE_HTTP_TIMEOUT = 240

node {
  wrap([$class: 'VaultBuildWrapper', vaultSecrets: secrets]) {
    stage('Checkout') {
      deleteDir()
      checkout scm
      checkoutIntegrationTests()
    }

    stage('Update images') {
      sh "${dockerCompose} pull"
    }

    try {
      stage('Start & setup environment') {
        sh 'mkdir -p output'
        sh 'mkdir -p reports'
        sh "${dockerCompose} up -d zap-proxy remote-webdriver citizen-frontend legal-frontend"
        sh "./bin/set-scanning-exclusions.sh ${execParams}"
      }

      stage('Run user journey through ZAP') {
        sh "${dockerCompose} up --no-deps --no-color integration-tests"

        def testExitCode = steps.sh returnStdout: true, script: "${dockerCompose} ps -q integration-tests | xargs docker inspect -f '{{ .State.ExitCode }}'"
        if (testExitCode.toInteger() > 0) {
          archiveArtifacts 'output/*.png'
          error('Integration tests failed')
        }

        sh "${dockerCompose} ${exec} zap-proxy zap-cli report -o /zap/reports/zap-scan-report.html -f html"
        archiveArtifacts 'reports/zap-scan-report.html'
      }
    } finally {
      stage('Stop environments') {
        sh "${dockerCompose} logs --no-color > output/logs.txt"
        archiveArtifacts 'output/logs.txt'

        sh "${dockerCompose} down --remove-orphans"
      }
    }
  }
}

private void checkoutIntegrationTests() {
  checkout([
    $class: 'GitSCM',
    branches: [[name: 'master']],
    userRemoteConfigs: [[url: 'https://github.com/hmcts/cmc-integration-tests.git']],
    extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'integration-tests']]
  ])
}
