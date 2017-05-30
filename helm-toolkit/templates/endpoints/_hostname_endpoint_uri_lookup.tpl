# Copyright 2017 The Openstack-Helm Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This function returns hostnames from endpoint definitions for use cases
# where the uri style return is not appropriate, and only the hostname
# portion is used or relevant in the template:
# { tuple "memcache" "internal" "portName" . | include "helm-toolkit.endpoints.hostname_endpoint_uri_lookup" }
# returns: internal_host:port
#
# Output that requires the port aspect striped could simply split the output based on ':'

{{- define "helm-toolkit.endpoints.hostname_endpoint_uri_lookup" -}}
{{- $type := index . 0 -}}
{{- $endpoint := index . 1 -}}
{{- $port := index . 2 -}}
{{- $context := index . 3 -}}
{{- $endpointMap := index $context.Values.endpoints $type }}
{{- $fqdn := $context.Release.Namespace -}}
{{- if $context.Values.endpoints.fqdn -}}
{{- $fqdn := $context.Values.endpoints.fqdn -}}
{{- end -}}
{{- with $endpointMap -}}
{{- $endpointScheme := .scheme }}
{{- $endpointHost := index .hosts $endpoint | default .hosts.default}}
{{- $endpointPort := index .port $port | default .port.default }}
{{- printf "%s.%s:%1.f" $endpointHost $fqdn $endpointPort -}}
{{- end -}}
{{- end -}}
