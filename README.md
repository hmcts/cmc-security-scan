# CMC Security Scan

This is the security scan using ZAP proxy.

## Getting Started

### Prerequisites

The following software needs to be installed:

* [Docker](https://www.docker.com)

### Local environment setup

In addition to above, a link to integration tests should exist as security scan runs integration tests through ZAP proxy. Link can be created using the following command:

```bash
$ ln -s <path-to-integration-tests> integration-tests
```

### Starting dockerized environment

To start environment including ZAP proxy, Selenium Webdriver and CMC service stack please run the following command:

```bash
$ ./bin/start-environment.sh
```

There is a convenience `stop-environment` script as well.

### Run integration tests through ZAP proxy

To run integration tests through ZAP proxy in attack mode please run the following command:

```bash
$ ./bin/run-integration-tests-scan.sh
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details.
