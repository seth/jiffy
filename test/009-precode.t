#! /usr/bin/env escript
% This file is part of Jiffy released under the MIT license.
% See the LICENSE file for more information.

main([]) ->
    code:add_pathz("ebin"),
    code:add_pathz("test"),

    etap:plan(3),
    util:test_enc_ok(good(), [{precoder, fun(V) -> precoder(V) end}]),
    %util:test_errors(errors()),
    etap:end_tests().

precoder({Y, M, D}) when is_integer(Y); is_integer(M); is_integer(D) ->
    Fmt = "~4.10.0B-~2.10.0B-~2.10.0B",
    list_to_binary(io_lib:format(Fmt, [Y, M, D]));
precoder(O) ->
    O.

good() ->
    [
        {{2012, 4, 11}, <<"\"2012-04-11\"">>},
        {[{2012, 4, 11}], <<"[\"2012-04-11\"]">>},
        {
            {[{<<"foo">>, {2012, 4, 11}}]},
            <<"{\"foo\":\"2012-04-11\"}">>
        }
    ].

errors() ->
    [
        {foo},
        {[{<<"foo">>, {bang}}]},
        [{bong}]
    ].
