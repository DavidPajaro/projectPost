%% @author usuario
%% @doc @todo Add description to post.


-module(post).

%% ====================================================================
%% API functions
%% ====================================================================
-export([]).
-compile(export_all).

create_post(NumPista, User, Hour, Half) -> 
	inets:start(),
	content_type(NumPista, User, Hour, Half).

content_type(NumPista, User, Hour, Half) -> 
	Url = "http://www.centrosupera.com/fileadmin/templates/php/reservar_instalacion.php",
	ContentType = "multipart/form-data; boundary=---------------------------265001916915724",
	Referer = lists:concat(["http://www.centrosupera.com/fileadmin/templates/php/reservar_instalacion.php?",
							"horario=", data:pista(NumPista), "&idusuario=", data:usuario(User),
							 "&centro=1&hoy=", secs:calc_schedule(Hour, Half)]),
	%Referer2 = "http://www.centrosupera.com/index.php?id=79",
	Cookie = lists:concat([" __utma=269849187.282543652.1363288802.1363298117.1363428519.3; __utmz=269849187.1363288802.1.1.utmcsr=google|",
						   "utmccn=(organic)|utmcmd=organic|utmctr=centrosupera; fe_typo_user=e0050532c1e0dd366a0a868b57731945; ",
						   "SERVERID=serv1; __utmb=269849187.1.10.1363428519; __utmc=269849187; PHPSESSID=n0uaj7eedg1lhq1sbmsfmhnmf6"
						   ]),
    Headers = [{"Host", "www.centrosupera.com"},
			   {"User-Agent", "Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20100101 Firefox/7.0.1"},
			   {"Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"},
			   {"Accept-Language", "es-es,es;q=0.8,en-us;q=0.5,en;q=0.3"},
			   {"Accept-Encoding", "gzip, deflate"},
			   {"Accept-Charset", "ISO-8859-1,utf-8;q=0.7,*;q=0.7"},
			   {"Connection", "keep-alive"},
			   {"Referer", Referer},
			   {"Cookie", Cookie},
			   {"Content-Type", "multipart/form-data; boundary=---------------------------265001916915724"},
			   {"Content-Length", integer_to_list(length(body_multipart(NumPista, User, Hour, Half)))}
			   ],
	
	io:format("Headers: ~p~n",[Headers]),
	%io:format("Body: ~p~n",[body_multipart(NumPista, User, Hour, Half)]),
	%{Res,{State,Head, BodyResponse}} = httpc:request(get, {Url, Headers},[],[]),
	{Res,{State,Head, BodyResponse}} = httpc:request(post, {Url, Headers, ContentType, body_multipart(NumPista, User, Hour, Half)}, [], []),
	io:format("Peticion POST: ~p~n",[Res]),
	io:format("Peticion POST: ~p~n",[State]),
  	io:format("Peticion POST: ~p~n",[Head]),
	io:format("Peticion POST-P: ~p~n",[BodyResponse]),
	io:format("Peticion POST-S: ~s~n",[BodyResponse]),
	io:format("Peticion POST-W: ~w~n",[BodyResponse]).
  %  A = httpc:request(post, {Url, Headers, ContentType, body_multipart(NumPista, User, Hour, Half)}, [], []),
%	io:format("Peticion POST:~p~n",[A]).

body_multipart(NumPista, User, Hour, Half) ->
	lists:concat([	"-----------------------------265001916915724
					Content-Disposition: form-data; name=\"acti\"
					
					", NumPista ,"
					-----------------------------265001916915724
					Content-Disposition: form-data; name=\"usu\"
					
					", User ,"
					-----------------------------265001916915724
					Content-Disposition: form-data; name=\"centro\"
					
					1
					-----------------------------265001916915724
					Content-Disposition: form-data; name=\"hoy\"
					
					", secs:calc_schedule(Hour, Half) ,"
					-----------------------------265001916915724
					Content-Disposition: form-data; name=\"puestos\"
					
					
					-----------------------------265001916915724
					Content-Disposition: form-data; name=\"confirmacion\"
					
					Confirmar
					-----------------------------265001916915724--"]).
body_multipart() -> 
		"-----------------------------265001916915724
		Content-Disposition: form-data; name=\"acti\"
		
		82
		-----------------------------265001916915724
		Content-Disposition: form-data; name=\"usu\"
		
		126328
		-----------------------------265001916915724
		Content-Disposition: form-data; name=\"centro\"
		
		1
		-----------------------------265001916915724
		Content-Disposition: form-data; name=\"hoy\"
		
		1363460400
		-----------------------------265001916915724
		Content-Disposition: form-data; name=\"puestos\"
		
		
		-----------------------------265001916915724
		Content-Disposition: form-data; name=""confirmacion""
		
		Confirmar
		-----------------------------265001916915724--".

%% @doc encode fields and file for HTTP post multipart/form-data.
%% @reference Inspired by <a href="http://code.activestate.com/recipes/146306/">Python implementation</a>.
format_multipart_formdata(Boundary, Fields, Files) ->
    FieldParts = lists:map(fun({FieldName, FieldContent}) ->
                                   [lists:concat(["--", Boundary]),
                                    lists:concat(["Content-Disposition: form-data; name=\"",atom_to_list(FieldName),"\""]),
                                    "",
                                    FieldContent]
                           end, Fields),
    FieldParts2 = lists:append(FieldParts),
    FileParts = lists:map(fun({FieldName, FileName, FileContent}) ->
                                  [lists:concat(["--", Boundary]),
                                   lists:concat(["Content-Disposition: format-data; name=\"",atom_to_list(FieldName),"\"; filename=\"",FileName,"\""]),
                                   lists:concat(["Content-Type: ", "application/octet-stream"]),
                                   "",
                                   FileContent]
                          end, Files),
    FileParts2 = lists:append(FileParts),
    EndingParts = [lists:concat(["--", Boundary, "--"]), ""],
    Parts = lists:append([FieldParts2, FileParts2, EndingParts]),
    string:join(Parts, "\r\n").

