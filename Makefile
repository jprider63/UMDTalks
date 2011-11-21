EXE=umdtalks

compile: umdtalks.urp umdtalks.urs umdtalks.ur
	urweb umdtalks && mv $(EXE).exe $(EXE)

run: compile
	pkill $(EXE); ./$(EXE) -p 9000 &

stop:
	pkill $(EXE)

clean:
	rm $(EXE)
