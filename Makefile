todo:
	@done=$$(grep -c "\[x\]" TODO.md); \
	total=$$(grep -c "\[ \]" TODO.md); \
	echo "✅ Done: $$done"; \
	echo "❌ Left: $$total"; \
	echo "📊 Progress: $$((100*$$done/($$done+$$total)))%"; \
	echo
	@cat TODO.md