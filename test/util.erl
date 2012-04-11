-module(util).
-compile(export_all).

test_good(Cases) ->
    test_good(Cases, []).

test_good(Cases, Options) ->
    lists:foreach(fun(Case) -> check_good(Case, Options) end, Cases).

test_errors(Cases) ->
    lists:foreach(fun(Case) -> check_error(Case) end, Cases).

test_enc_ok(Cases, Options) ->
    lists:foreach(fun(Case) -> check_enc_ok(Case, Options) end, Cases).

ok_dec(J, _E) ->
    lists:flatten(io_lib:format("Decoded ~p.", [J])).

ok_enc(E, _J) ->
    lists:flatten(io_lib:format("Encoded ~p", [E])).

do_encode(E, Options) ->
    iolist_to_binary(jiffy:encode(E, Options)).

error_mesg(J) ->
    lists:flatten(io_lib:format("Decoding ~p returns an error.", [J])).

check_good({J, E}, Options) ->
    etap:is(jiffy:decode(J), E, ok_dec(J, E)),
    etap:is(do_encode(E, Options), J, ok_enc(E, J));
check_good({J, E, J2}, Options) ->
    etap:is(jiffy:decode(J), E, ok_dec(J, E)),
    etap:is(do_encode(E, Options), J2, ok_enc(E, J2)).

check_error({J, E}) ->
    etap:fun_is(
        fun({error, E1}) when E1 == E -> true; (E1) -> E1 end,
        (catch jiffy:decode(J)),
        error_mesg(J)
    );
check_error(J) ->
    etap:fun_is(
        fun({error, _}) -> true; (Else) -> Else end,
        (catch jiffy:decode(J)),
        error_mesg(J)
    ).

check_enc_ok({E, J}, Options) ->
    etap:is(do_encode(E, Options), J, ok_enc(E, J)).

