-module(quick_chat_ws_handler).
-include("quick_chat.hrl").
-export([init/3]).
-export([websocket_init/3, websocket_handle/3,
    websocket_info/3, websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
    {upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
    %erlang:start_timer(1000, self(), <<"Hello!">>),
    S = #userinfo{login=false},
    {ok, Req, S}.

websocket_handle({text, Msg}, Req, State) when State#userinfo.login==false ->
    Login = erlang:list_to_binary(string:substr(erlang:binary_to_list(Msg), 7)),
    State1 = State#userinfo{login=Login},
    {reply, {text, << "Hello, ", Login/binary, "!" >>}, Req, State1};
websocket_handle({text, Msg}, Req, State) ->
    Login = State#userinfo.login,
    {reply, {text, << Login/binary, ": ", Msg/binary >>}, Req, State};
websocket_handle(_Data, Req, State) ->
    {ok, Req, State}.

websocket_info({timeout, _Ref, Msg}, Req, State) ->
    %erlang:start_timer(1000, self(), <<"How' you doin'?">>),
    {reply, {text, Msg}, Req, State};
websocket_info(_Info, Req, State) ->
    {ok, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
    ok.
