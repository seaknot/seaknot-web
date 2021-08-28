SCRIPT=script.scm

.PHONY: doc

run: $(TARGET) $(RHEINGAU)
	while true; do violet $(SCRIPT); echo restarting...; sleep 60; done

clean:
	rm -rf *~ *.o $(TARGET) gosh-modules $(RHEINGAU) $(TARGET).dSYM

doc: static/playlogic.html

static/%.html: docs/%.md templates/default.html
	docker-compose run pandoc pandoc $< -f markdown -t html --template=templates/default.html -s -o $@
