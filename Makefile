EXE=umdtalks
DB=-db "host=localhost user=umdtalks password=umdrocks"

compile: umdtalks.urp umdtalks.urs umdtalks.ur libraries
	urweb $(DB) umdtalks

run: compile
	pkill $(EXE); ./$(EXE) -p 9000 &

db: compile
	psql -f setup.sql $(EXE) $(EXE) && psql -f $(EXE).sql $(EXE) $(EXE)

stop:
	pkill $(EXE)

libraries: librandom.a libhash.a

librandom.a: librandom.o
	ar rcs $@ $<

librandom.o: random.c
	gcc -I/usr/local/include/urweb -g -c -o $@ $<

libhash.a: libhash.o
	ar rcs $@ $<

libhash.o: hash.c
	gcc -I/usr/local/include/urweb -g -c -o $@ $<

.PHONY: clean

clean:
	rm $(EXE) librandom.a librandom.o libhash.a libhash.o

