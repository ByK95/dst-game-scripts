
apply_patches:
	for patch in patches/*.patch; do \
		git apply $$patch; \
	done

shell:
	lua -i shell.lua