{{- define "helm-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.name }}
{{ .Values.serviceAccount.name }}
{{- else }}
{{ .Chart.Name }}
{{- end }}
{{- end }}
