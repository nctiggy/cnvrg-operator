apiVersion: v1
kind: ServiceAccount
metadata:
  name: cnvrg-spark-job
  namespace: {{ ns . }}
  annotations:
    {{- range $k, $v := .Spec.Annotations }}
    {{$k}}: "{{$v}}"
    {{- end }}
  labels:
    {{- range $k, $v := .Spec.Labels }}
    {{$k}}: "{{$v}}"
    {{- end }}
imagePullSecrets:
  - name: {{ .Spec.Registry.Name }}