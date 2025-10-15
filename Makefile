SCRIPT=script.scm

.PHONY: doc

run: $(TARGET) $(RHEINGAU)
	echo NODEMON = $$NODEMON
	echo SLEEPTIME = $$SLEEPTIME
	if [ v"$$NODEMON" != v ]; \
	    then nodemon --exec violet $(SCRIPT); \
	else while true; \
	    do sh -c 'echo $$$$ > violet-pid; exec violet $(SCRIPT)'; \
	        echo restarting...; sleep $$SLEEPTIME; \
	    done; \
	fi

clean:
	rm -rf *~ *.o $(TARGET) gosh-modules $(RHEINGAU) $(TARGET).dSYM

doc: static/playlogic.html

static/%.html: docs/%.md templates/default.html
	docker-compose run pandoc pandoc $< -f markdown -t html --template=templates/default.html -s -o $@
