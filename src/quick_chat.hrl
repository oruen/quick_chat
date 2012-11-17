-define(PRINT(Var), io:format("~p:~p: ~p = ~p~n", [?MODULE, ?LINE, ??Var, Var])).
-define(WSKey,{pubsub,wsbroadcast}).

-record(userinfo, {login = false}).
