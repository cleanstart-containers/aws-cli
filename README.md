# CleanStart Container for AWS CLI

Official AWS Command Line Interface (CLI) container image providing a unified tool to manage AWS services. This enterprise-ready container includes the latest AWS CLI v2, with support for all AWS services and commands. Features include AWS IAM authentication, S3 operations, EC2 management, and other AWS service interactions. Built on a security-hardened base image with minimal attack surface and FIPS-compliant cryptographic modules.

**📌 CleanStart Foundation:** Security-hardened, minimal base OS designed for enterprise containerized environments.

**Image Path:** `ghcr.io/cleanstart-containers/aws-cli`

**Registry:** CleanStart Registry

---

## Overview

The AWS CLI (Command Line Interface) is a unified tool to manage AWS services from the command line. This CleanStart container provides AWS CLI v2 with comprehensive functionality for interacting with all AWS services, built on a security-hardened foundation optimized for enterprise deployments.

---

## Key Features

Core capabilities and strengths of this container:

- Complete AWS CLI v2 functionality with all service commands
- Built-in credential management and AWS IAM integration
- Support for AWS profiles and configuration
- FIPS 140-2 compliant cryptographic modules for secure operations
- Security-hardened base image
- Minimal attack surface
- Enterprise-ready configuration

---

## Common Use Cases

Typical scenarios where this container excels:

- Automated AWS infrastructure management and deployment
- S3 bucket operations and file transfers
- EC2 instance management and monitoring
- CloudFormation stack deployment and updates
- Lambda function deployment and management
- AWS resource automation in CI/CD pipelines
- Multi-account AWS operations
- Infrastructure as Code deployments

---

## Quick Start

### Pull Latest Image

Download the container image from the registry:
```bash
docker pull ghcr.io/cleanstart-containers/aws-cli:latest
```
```bash
docker pull ghcr.io/cleanstart-containers/aws-cli:latest-dev
```

### Basic Run

Run the container with basic configuration:
```bash
docker run -it --name aws-cli-test ghcr.io/cleanstart-containers/aws-cli:latest-dev --version
```

### Check AWS CLI Version
```bash
docker run --rm ghcr.io/cleanstart-containers/aws-cli:latest-dev --version
```

### Run AWS Commands
```bash
docker run --rm \
  -v ~/.aws:/home/aws/.aws:ro \
  ghcr.io/cleanstart-containers/aws-cli:latest-dev s3 ls
```

### Production Deployment

Deploy with production security settings:
```bash
docker run -d --name aws-cli-prod \
  --read-only \
  --security-opt=no-new-privileges \
  --user 1000:1000 \
  -v ~/.aws:/home/aws/.aws:ro \
  ghcr.io/cleanstart-containers/aws-cli:latest
```

### Interactive Shell
```bash
docker run -it --rm \
  -v ~/.aws:/home/aws/.aws:ro \
  --entrypoint /bin/sh
  ghcr.io/cleanstart-containers/aws-cli:latest-dev
```

---

## Configuration

### AWS Credentials

Mount your AWS credentials directory:
```bash
-v ~/.aws:/home/aws/.aws:ro
```

### Environment Variables

You can also pass AWS credentials via environment variables:
```bash
docker run --rm \
  -e AWS_ACCESS_KEY_ID=your-access-key \
  -e AWS_SECRET_ACCESS_KEY=your-secret-key \
  -e AWS_DEFAULT_REGION=us-east-1 \
  ghcr.io/cleanstart-containers/aws-cli:latest-dev s3 ls
```

### AWS Profiles

Use specific AWS profiles:
```bash
docker run --rm \
  -v ~/.aws:/home/aws/.aws:ro \
  ghcr.io/cleanstart-containers/aws-cli:latest-dev s3 ls --profile production
```

---

## Architecture Support

CleanStart images support multiple architectures to ensure compatibility across different deployment environments:

- **AMD64**: Intel and AMD x86-64 processors
- **ARM64**: ARM-based processors including Apple Silicon and ARM servers

### Multi-Platform Images
```bash
docker pull --platform linux/amd64 ghcr.io/cleanstart-containers/aws-cli:latest
```
```bash
docker pull --platform linux/arm64 ghcr.io/cleanstart-containers/aws-cli:latest
```

---

## Resources

- **Official Documentation:** https://docs.aws.amazon.com/cli/latest/userguide/
- **AWS CLI Command Reference:** https://docs.aws.amazon.com/cli/latest/reference/
- **Provenance / SBOM / Signature:** https://images.cleanstart.com/images/aws-cli
- **Docker Hub:** https://hub.docker.com/r/cleanstart/aws-cli
- **CleanStart All Images:** https://images.cleanstart.com/images/aws-cli/details
- **CleanStart Community Images:** https://hub.docker.com/u/cleanstart

---

## Vulnerability Disclaimer

CleanStart offers Docker images that include third-party open-source libraries and packages maintained by independent contributors. While CleanStart maintains these images and applies industry-standard security practices, it cannot guarantee the security or integrity of upstream components beyond its control.

Users acknowledge and agree that open-source software may contain undiscovered vulnerabilities or introduce new risks through updates. CleanStart shall not be liable for security issues originating from third-party libraries, including but not limited to zero-day exploits, supply chain attacks, or contributor-introduced risks.

**Security remains a shared responsibility:** CleanStart provides updated images and guidance where possible, while users are responsible for evaluating deployments and implementing appropriate controls.
