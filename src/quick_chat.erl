%%
%% quick_chat.erl
%% quick_chat entry point
%%
-module(quick_chat).

-export([start/0, start_link/0, stop/0]).

start_link() ->
    quick_chat_sup:start_link().

start() ->
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(quick_chat).

stop() ->
    application:stop(quick_chat).

