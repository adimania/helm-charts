{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "newrelic-pixie.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "newrelic-pixie.namespace" -}}
{{- .Release.Namespace | default "pl" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "newrelic-pixie.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Generate basic labels */}}
{{- define "newrelic-pixie.labels" }}
app: {{ template "newrelic-pixie.name" . }}
app.kubernetes.io/name: {{ include "newrelic-pixie.name" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
heritage: {{.Release.Service }}
release: {{.Release.Name }}
{{- end }}

{{- define "newrelic-pixie.cluster" -}}
{{- if .Values.global -}}
  {{- if .Values.global.cluster -}}
      {{- .Values.global.cluster -}}
  {{- else -}}
      {{- .Values.cluster | default "" -}}
  {{- end -}}
{{- else -}}
  {{- .Values.cluster | default "" -}}
{{- end -}}
{{- end -}}

{{- define "newrelic-pixie.nrStaging" -}}
{{- if .Values.global }}
  {{- if .Values.global.nrStaging }}
    {{- .Values.global.nrStaging -}}
  {{- end -}}
{{- else if .Values.nrStaging }}
  {{- .Values.nrStaging -}}
{{- end -}}
{{- end -}}

{{- define "newrelic-pixie.licenseKey" -}}
{{- if .Values.global}}
  {{- if .Values.global.licenseKey }}
      {{- .Values.global.licenseKey -}}
  {{- else -}}
      {{- .Values.licenseKey | default "" -}}
  {{- end -}}
{{- else -}}
    {{- .Values.licenseKey | default "" -}}
{{- end -}}
{{- end -}}

{{- define "newrelic-pixie.apiKey" -}}
{{- if .Values.global}}
  {{- if .Values.global.apiKey }}
      {{- .Values.global.apiKey -}}
  {{- else -}}
      {{- .Values.apiKey | default "" -}}
  {{- end -}}
{{- else -}}
    {{- .Values.apiKey | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Return the customSecretName where the New Relic license key will be stored
*/}}
{{- define "newrelic-pixie.customSecretName" -}}
{{- if .Values.global }}
  {{- if .Values.global.customSecretName }}
      {{- .Values.global.customSecretName -}}
  {{- else -}}
      {{- .Values.customSecretName | default "" -}}
  {{- end -}}
{{- else -}}
    {{- .Values.customSecretName | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Return the customSecretLicenseKey
*/}}
{{- define "newrelic-pixie.customSecretLicenseKey" -}}
{{- if .Values.global }}
  {{- if .Values.global.customSecretLicenseKey }}
      {{- .Values.global.customSecretLicenseKey -}}
  {{- else -}}
      {{- .Values.customSecretLicenseKey | default "" -}}
  {{- end -}}
{{- else -}}
    {{- .Values.customSecretLicenseKey | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Return the customSecretApiKeyKey
*/}}
{{- define "newrelic-pixie.customSecretApiKeyKey" -}}
{{- if .Values.global }}
  {{- if .Values.global.customSecretApiKeyKey }}
      {{- .Values.global.customSecretApiKeyKey -}}
  {{- else -}}
      {{- .Values.customSecretApiKeyKey | default "" -}}
  {{- end -}}
{{- else -}}
    {{- .Values.customSecretApiKeyKey | default "" -}}
{{- end -}}
{{- end -}}

{{/*
Returns if the template should render, it checks if the required values
licenseKey and cluster are set.
*/}}
{{- define "newrelic-pixie.areValuesValid" -}}
{{- $cluster := include "newrelic-pixie.cluster" . -}}
{{- $licenseKey := include "newrelic-pixie.licenseKey" . -}}
{{- $apiKey := include "newrelic-pixie.apiKey" . -}}
{{- $customSecretName := include "newrelic-pixie.customSecretName" . -}}
{{- $customSecretLicenseKey := include "newrelic-pixie.customSecretLicenseKey" . -}}
{{- $customSecretApiKeyKey := include "newrelic-pixie.customSecretApiKeyKey" . -}}
{{- and (or (and $licenseKey $apiKey) (and $customSecretName $customSecretLicenseKey $customSecretApiKeyKey)) $cluster}}
{{- end -}}
