# CMC Security Scan

This is the security scan using ZAP proxy.

## Getting Started

### Prerequisites

The following software need to be installed:

* [Docker](https://www.docker.com)

In addition to the above a link to integration tests should exists as security scan runs integration tests through ZAP proxy. Link can be created using the following command:

```bash
$ ln <path-to-integration-tests> integration-tests
```

### Staring environment

To start environment including ZAP proxy, Selenium Webdriver and service stack please run the following command:

```bash
$ ./bin/start-environment.sh
```

### Run integration tests through ZAP proxy

To run integration tests through ZAP proxy in attack mode please run the following command:

```bash
$ ./bin/run-integration-tests-scan.sh
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.txt) file for details
