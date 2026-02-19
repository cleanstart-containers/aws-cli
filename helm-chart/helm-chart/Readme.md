# AWS CLI Helm — Testing Guide

Deploy and test AWS CLI container with busybox sidecar.

Prereqs: `kubectl`, `helm`.

**Note:** This chart is configured for the minimal prod AWS CLI image (`docker.io/cleanstart/aws-cli:latest`), which requires:
- No custom startup command (uses image ENTRYPOINT)
- Writable filesystem (`readOnlyRootFilesystem: false`)
- Root/standard permissions (not restricted to non-root user)

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

## Testing Sidecar Container

### 1. Access Sidecar Shell

```bash
kubectl exec -it $POD -n aws-cli -c sidecar -- /bin/sh
```

All tests below run **inside the sidecar shell** to verify mounted volumes and configuration.

### 2. Verify Mounted Configuration Files

```bash
ls -la /etc/aws-cli
cat /etc/aws-cli/aws-cli.conf
```

Expected output: Shows mounted ConfigMap with AWS CLI configuration.

### 3. Check Temporary Volume

```bash
ls -la /tmp
```

Expected output: Shared temp directory accessible from sidecar.

### 4. Environment Variables

```bash
env | grep -E "SIDECAR|TARGET|APPLICATION"
```

Expected output: Sidecar metadata environment variables.

### 5. Available Tools in Sidecar

```bash
which sh
which ls
which cat
which grep
```

Expected: Basic busybox utilities available.

### 6. Test Volume Accessibility

```bash
test -r /etc/aws-cli/aws-cli.conf && echo "Config file is readable" || echo "Config file not readable"
test -w /tmp && echo "Temp directory is writable" || echo "Temp directory not writable"
```

### Exit Sidecar Shell

```bash
exit
```

## Cleanup

```bash
helm uninstall aws-cli -n aws-cli
kubectl delete namespace aws-cli
```
