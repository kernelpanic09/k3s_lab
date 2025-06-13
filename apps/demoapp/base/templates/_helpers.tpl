{{/*
Return the app name
*/}}
{{- define "demoapp.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Return the full app name
*/}}
{{- define "demoapp.fullname" -}}
{{- printf "%s" (include "demoapp.name" .) -}}
{{- end }}
