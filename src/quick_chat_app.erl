%%
%% quick_chat_app.erl
%% quick_chat application
%%
-module(quick_chat_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ~~~~~~~~~~~~~~~~~~~~~
%% Application callbacks
%% ~~~~~~~~~~~~~~~~~~~~~

start(_StartType, _StartArgs) ->
    Dispatch = [
      {'_', [
        {['...'], cowboy_static, [
          {directory, {priv_dir, quick_chat, []}},
          {mimetypes, {fun mimetypes:path_to_mimes/2, default}}
        ]}
      ]}
    ],
    {ok, _} = cowboy:start_http(http, 100, [{port, 8080}], [
      {dispatch, Dispatch}
    ]),
    WsDispatch = [
      {'_', [
        {'_', quick_chat_ws_handler, []}
      ]}
    ],
    {ok, _} = cowboy:start_http(quick_chat_websocket, 100, [{port, 10100}], [
      {dispatch, WsDispatch}
    ]),
    quick_chat_sup:start_link().

stop(_State) ->
    ok.

