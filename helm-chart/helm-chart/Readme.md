# AWS CLI Helm — Testing & Deployment Guide

Deploy minimal AWS CLI (cleanstart) with amazon/aws-cli sidecar for testing.

Prereqs: `kubectl`, `helm`.

**Image Design:**
- **Minimal Image:** Built with `ENTRYPOINT ["aws"]` + `CMD ["sleep infinity"]`
  - Can be invoked as one-shot: `docker run myimage s3 ls`
  - Or stays running: `docker run myimage` → sleeps
  - Lightweight, non-root user (clnstrt)
  - Perfect for: Batch jobs, Lambda-like use cases, AND Kubernetes deployments
- **Sidecar:** Full amazon/aws-cli for interactive testing
  - Stays running (`sleep infinity`)
  - Complete shell environment

**Setup Overview:**
- **Main container:** `docker.io/cleanstart/aws-cli:latest` (minimal ENTRYPOINT, exits by design, overridden with empty command in Helm to keep running for testing)
- **Sidecar:** `docker.io/amazon/aws-cli:latest` (full-featured, runs continuously with shell)
- **Testing:** Use direct commands for minimal image, sidecar for interactive testing

## Architecture

```
POD
├── aws-cli (cleanstart/aws-cli:latest)
│   ├── ENTRYPOINT: ["aws"]
│   ├── User: clnstrt (non-root)
│   ├── Design: One-shot execution (exits after command)
│   ├── Status: Exits (unless overridden with specific command)
│   └── Use: Batch jobs, specific AWS CLI invocations
│
└── sidecar (amazon/aws-cli:latest)  ← Primary for testing
    ├── Has shell (/bin/sh)
    ├── Runs: sleep infinity (stays running)
    ├── Status: Running
    └── Use: Interactive shell, debugging, exploring
```

## Deployment

```bash
# go to chart directory
cd ~/Repos/github.com-cleanstart-containers/aws-cli/helm-chart/helm-chart

# create namespace and install
kubectl create namespace aws-cli
helm install aws-cli . -n aws-cli

# find pod
POD=$(kubectl get pods -n aws-cli -l app=aws-cli -o jsonpath='{.items[0].metadata.name}')
```

## Testing Minimal Image (cleanstart/aws-cli)

**Note:** The minimal image uses `ENTRYPOINT ["aws"]` and exits after running commands by design. The sidecar is used for interactive testing.

To test the minimal image behavior, use direct command invocation:

### 1. Check Minimal Image Version via Sidecar

```bash
# From sidecar, you can invoke the minimal image's aws binary behavior
# The minimal image is for one-shot batch operations

kubectl exec $POD -n aws-cli -c sidecar -- aws --version
```

### 2. Minimal Image is Designed For

```
- One-shot invocation: docker run myimage s3 ls
- Kubernetes Jobs with specific AWS CLI command
- Lambda-like batch processing
- Single-command execution (exits after)
```

To use the minimal image for a specific AWS command in Kubernetes, override the command in Helm:

```yaml
container:
  command:
    - aws
    - s3
    - ls
```

This will run the AWS CLI command and exit (expected behavior).

## Testing AWS CLI via Sidecar

Use the sidecar container for interactive shell access and full-featured testing:

### 1. Open Sidecar Interactive Shell

```bash
kubectl exec -it $POD -n aws-cli -c sidecar -- /bin/sh
```

### 2. Inside Sidecar Shell - Run AWS Commands

```bash
# Check AWS CLI version (sidecar - amazon/aws-cli:latest)
aws --version

# List AWS CLI configuration
aws configure list

# Check credentials (if configured)
aws sts get-caller-identity

# List S3 buckets (if credentials available)
aws s3 ls

# Describe EC2 instances
aws ec2 describe-instances

# Get help
aws help | head -20

# Exit shell
exit
```

### 3. Direct Command Execution (Non-Interactive)

```bash
# Run commands without entering shell
kubectl exec $POD -n aws-cli -c sidecar -- aws --version
kubectl exec $POD -n aws-cli -c sidecar -- aws configure list
kubectl exec $POD -n aws-cli -c sidecar -- aws s3 ls
```

### 4. Verify Mounted Configuration

```bash
kubectl exec $POD -n aws-cli -c sidecar -- ls -la /etc/aws-cli/
kubectl exec $POD -n aws-cli -c sidecar -- cat /etc/aws-cli/aws-cli.conf
```

## Comparing Both Containers

```bash
# Minimal image version (cleanstart)
kubectl exec $POD -n aws-cli -c aws-cli -- aws --version

# Full-featured version (sidecar)
kubectl exec $POD -n aws-cli -c sidecar -- aws --version
```

## Pod Status

Expected behavior (minimal image for one-shot use):
- **Main container:** Exits after running (ENTRYPOINT-only by design, or if overridden with specific AWS command)
- **Sidecar:** Running (`sleep infinity`) - used for interactive testing

```bash
kubectl get pods -n aws-cli
# STATUS: 1/2 Running (sidecar stays running for testing)
# Main container exits or restarts (expected for one-shot image)
```

**To keep main container running for testing**, override with test command:

```yaml
container:
  command:
    - "aws"
    - "--version"
```

Or use sidecar for all testing (recommended).

## Why Two Containers?

| Component | Purpose | Features | Use Case |
|-----------|---------|----------|----------|
| cleanstart/aws-cli:latest | Minimal AWS CLI image | Lightweight, non-root user, stays running (CMD), ENTRYPOINT-based | Testing slim image, production job containers |
| amazon/aws-cli:latest (sidecar) | Full-featured testing | Complete shell (/bin/sh), debugging tools, interactive | Interactive debugging, shell exploration |

**Testing Strategy:**
- **Both testable:** Main container now runs continuously (sleeps by default thanks to CMD)
- **Minimal image:** Direct `kubectl exec` commands to test slim container behavior with shell
- **Interactive work:** Use sidecar with full shell for complex debugging
- **Comparison:** Test both to understand size/performance differences

**Production Use:**
- Both containers have the minimal image
- Override ENTRYPOINT for batch jobs: `command: ["aws", "s3", "ls"]`
- Remove sidecar by setting `testSidecar.enabled: false` in values.yaml

## Cleanup

```bash
helm uninstall aws-cli -n aws-cli
kubectl delete namespace aws-cli
```
