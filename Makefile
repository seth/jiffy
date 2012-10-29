REBAR?=./rebar


all: build


clean:
	$(REBAR) clean
	rm -rf logs
	rm -rf .eunit
	rm -f test/*.beam


distclean: clean
	git clean -fxd


build:
	$(REBAR) compile


etap: test/etap.beam test/util.beam
	prove test/*.t


eunit: deps/proper/ebin/proper.beam
	ERL_COMPILER_OPTIONS="[{d,'JIFFY_DEBUG'}]" \
	ERL_FLAGS='-pa deps/proper/ebin' $(REBAR) eunit skip_deps=true


check: build etap eunit


%.beam: %.erl
	erlc -o test/ $<


deps/proper/ebin/proper.beam: deps/proper
	cd proper; $(REBAR) compile


deps/proper:
	mkdir -p deps
	cd deps; git clone git://github.com/manopapad/proper.git;


.PHONY: all clean distclean depends build etap eunit check
