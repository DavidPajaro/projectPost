%% @author usuario
%% @doc @todo Add description to data.


-module(data).

%% ====================================================================
%% API functions
%% ====================================================================
-export([]).
-compile(export_all).

%% NumPista: 1 para badminton 1
%%			 2 para badminton 2
pista(NumPista) ->
	case NumPista of
		2 -> Pista = 82;
		_ -> Pista = 97
	end,
	Pista.

usuario(User) ->
	case User of 
		"david" -> Id = 126319;
		"outro" -> Id = 126328;
		"javi"  -> Id = 126321
	end,
	Id.