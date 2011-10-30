EXE=umdtalks

compile: umdtalks.urp umdtalks.urs umdtalks.ur
	urweb umdtalks && mv $(EXE).exe $(EXE)

run: compile
	./$(EXE) &

clean:
	rm $(EXE)
