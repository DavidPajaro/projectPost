%% @author usuario
%% @doc @todo Add description to post.


-module(secs).

%% ====================================================================
%% API functions
%% ====================================================================
-export([]).
-compile(export_all).

%% ====================================================================
%% CALCULO SEGUNDOS PARA ESCOLLER O HORARIO
%% ====================================================================

%% Acha os segundos dos días que transcurriron dende 
%% o 1 de Xaneiro de 1970.
calc_sec_days_since_1970() ->
	Diff = calendar:time_difference({{1970,1,1},{0,0,0}},{date(),{0,0,0}}),
	element(1,Diff) * 24 * 60 * 60.

%% Campo HOUR --> pasalo en formato de 24 horas
%% 				  Ex: 00, 01, 02, .. , 12, 13, .. , 18, 19, 20, 21, 22, 23.  
%% Campo HALF --> opcións: 0 (hora en punto) ou 1 (e media (Hour + 30min))
calc_sec_hour(Hour, Half) -> 
%% 	TotalSecInADay = 24*60*60,
%% 	TotalSecAt12pm = 12*60*60,
	case Half of
		1 -> Secs = ((Hour - 1) * 60 * 60) + (30 * 60);
		_ -> Secs = (Hour - 1) * 60 * 60
	end,
	Secs.

%% Campo HOUR --> pasalo en formato de 24 horas
%% 				  Ex: 00, 01, 02, .. , 12, 13, .. , 18, 19, 20, 21, 22, 23.  
%% Campo HALF --> opcións: 0 (hora en punto) ou 1 (e media (Hour + 30min))
calc_schedule(Hour, Half) -> 
	calc_sec_days_since_1970() + calc_sec_hour(Hour, Half).