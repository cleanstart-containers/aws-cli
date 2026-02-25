{{/*
Expand the name of the chart.
*/}}
{{- define "aws-cli.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "aws-cli.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aws-cli.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "aws-cli.labels" -}}
helm.sh/chart: {{ include "aws-cli.chart" . }}
{{ include "aws-cli.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.labels.common }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aws-cli.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aws-cli.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Values.app.name }}
{{- end }}

{{/*
Full image path for main container
*/}}
{{- define "aws-cli.image" -}}
{{- if .Values.image.repository }}
{{- printf "%s/%s/%s/%s:%s" .Values.image.registry .Values.image.project .Values.image.repository .Values.image.name .Values.image.tag }}
{{- else }}
{{- printf "%s/%s/%s:%s" .Values.image.registry .Values.image.project .Values.image.name .Values.image.tag }}
{{- end }}
{{- end }}

{{/*
Full image path for test sidecar
*/}}
{{- define "aws-cli.sidecarImage" -}}
{{- if .Values.testSidecar.image.repository }}
{{- printf "%s/%s/%s/%s:%s" .Values.testSidecar.image.registry .Values.testSidecar.image.project .Values.testSidecar.image.repository .Values.testSidecar.image.name .Values.testSidecar.image.tag }}
{{- else }}
{{- printf "%s/%s/%s:%s" .Values.testSidecar.image.registry .Values.testSidecar.image.project .Values.testSidecar.image.name .Values.testSidecar.image.tag }}
{{- end }}
{{- end }}

{{/*
Init container image
*/}}
{{- define "aws-cli.initImage" -}}
{{- if .Values.fips.enabled }}
{{- printf "%s/%s/container-images/cleanstart-base-fips:latest-dev" .Values.image.registry .Values.image.project }}
{{- else }}
{{- printf "%s/%s/container-images/cleanstart-base:latest-dev" .Values.image.registry .Values.image.project }}
{{- end }}
{{- end }}
