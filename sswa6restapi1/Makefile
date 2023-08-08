.PHONY: opa_eval

opa_eval:
	@cd rules && opa eval -i example_kubectl_fail.json -d finish.rego "data.sbercode" | jq '.result[0].expressions[0].value'