apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/proxy-send-timeout: 18000s
    nginx.ingress.kubernetes.io/proxy-read-timeout: 18000s
    nginx.ingress.kubernetes.io/proxy-body-size: 5G
    {{- range $k, $v := .Spec.Annotations }}
    {{ $k }}: "{{ $v }}"
    {{- end }}
  name: {{ .Spec.Monitoring.Grafana.SvcName }}
  namespace: {{ ns . }}
  labels:
    {{- range $k, $v := .Spec.Labels }}
    {{ $k }}: "{{ $v }}"
    {{- end }}
spec:
  rules:
  - host: "{{ .Spec.Monitoring.Grafana.SvcName }}.{{ .Spec.ClusterDomain }}"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ .Spec.Monitoring.Grafana.SvcName }}
            port:
              number: {{ .Spec.Monitoring.Grafana.Port }}
{{- if isTrue .Spec.Networking.HTTPS.Enabled }}
  tls:
  - hosts:
    - {{ .Spec.Monitoring.Grafana.SvcName }}.{{ .Spec.ClusterDomain }}
{{- if isTrue .Spec.Networking.HTTPS.AcmeSecret }}
    secretName: grafana-tls-cert
{{- else if .Spec.Networking.HTTPS.CertSecret }}
    secretName: {{ .Spec.Networking.HTTPS.CertSecret }}
{{- end }}
{{- end }}
