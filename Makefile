# See LICENSE for licensing information.

DIALYZER = dialyzer
REBAR = rebar

all: app

app: deps
	@$(REBAR) compile

deps:
	@$(REBAR) get-deps

clean:
	@$(REBAR) clean
	rm -f test/*.beam
	rm -f erl_crash.dump

tests: clean app eunit ct

eunit:
	@$(REBAR) eunit skip_deps=true

ct:
	@$(REBAR) ct

build-plt:
	@$(DIALYZER) --build_plt --output_plt .sheriff_dialyzer.plt \
		--apps kernel stdlib

dialyze:
	@$(DIALYZER) --src src --plt .sheriff_dialyzer.plt \
		-Wbehaviours -Werror_handling \
		-Wrace_conditions -Wunmatched_returns # -Wunderspecs

docs:
	@$(REBAR) doc
