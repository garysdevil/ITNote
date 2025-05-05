---
created_date: 2022-02-04
---

[TOC]

- 参考 https://github.com/hcvst/erlang-otp-tutorial
## None OTP
### A non OTP server
- vi no_otp.erl
```erlang
%%%---------------------------------------------------------------------------
%%% @doc A simple server that does not use OTP. 
%%% @author Hans Christian v. Stockhausen 
%%% @end
%%%---------------------------------------------------------------------------

-module(no_otp).                     % module name (same as our erl filename, 
                                     % i.e. no_otp.erl) 

%% API
-export([                            % the functions we export - our API 
  start/0,                           % - start new server process
  stop/0,                            % - stop server 
  say_hello/0,                       % - print "Hello" to stdout 
  get_count/0                        % - reply with number of times the main  
  ]).                                %   loop was executed

%% Callbacks
-export([init/0]).                   % exported so we can spawn it in start/0
                                     % listed as a separate export here as a
                                     % hint to clients not to use it

-define(SERVER, ?MODULE).            % SERVER macro is an alias for MODULE, 
                                     % and expands to 'no_otp'

-record(state, {count}).             % record for our server state. Rather
                                     % arbitrarily we track how often the
                                     % main loop is run - see loop/1


%============================================================================= 
% API - functions that our clients use to interact with the server 
%=============================================================================

start() ->                           % spawn new process that calls init/0   
  spawn(?MODULE, init, []).          % the new process' PID is returned

stop() ->                            % send the atom stop to the process                            
  ?SERVER ! stop,                    % to instruct our server to shut down
  ok.                                % and return ok to caller

say_hello() ->                       % send the atom say_hello to the process
  ?SERVER ! say_hello,               % to print "Hello" to sdout
  ok.

get_count() ->                       % send callers Pid and the atom get_count
  ?SERVER ! {self(), get_count},     % to request counter value
  receive                            % wait for matching response and return
    {count, Value} -> Value          % Value to the caller 
  end.  


%=============================================================================
% callback functions - not to be used by clients directly
%============================================================================= 

init() ->                            % invoked by start/0 
  register(?SERVER, self()),         % register new process PID under no_otp 
  loop(#state{count=0}).             % start main server loop 

%=============================================================================
% internal functions - note, these functions are not exported 
%============================================================================= 

loop(#state{count=Count}) ->         % the main server loop
  receive Msg ->                     % when API functions send a message 
    case Msg of                      % check the atom contained 
      stop ->                        % if atom is 'stop'
        exit(normal);                %   exit the process 
      say_hello ->                   % if atom is 'say_hello'
        io:format("Hello~n");        %   write "Hello" to stdout
      {From, get_count} ->           % if Msg is tuple {Pid(), get_count}
        From ! {count, Count}        % reply with current counter value
    end                              %   in tagged tupple {count, Value}
  end,
  loop(#state{count = Count + 1}).   % recurse with updated state
```

### Run A non OTP server
```erlang
Eshell V5.8.5  (abort with ^G)
1> c(no_otp).
{ok,no_otp}
2> no_otp:start().
<0.39.0>
3> no_otp:get_count().
0
4> no_otp:say_hello().
Hello
ok
5> no_otp:get_count().
2
6>
```

### A non-OTP supervisor
```erlang
%%%----------------------------------------------------------------------------
%%% @doc A non-OTP supervisor
%%% @author Hans Christian v. Stockhausen 
%%% @end
%%%----------------------------------------------------------------------------

-module(sup).

%% API
-export([start_server/0]).

%% Callbacks
-export([supervise/0]).

%%=============================================================================
%% API
%%=============================================================================

start_server() ->
  spawn(?MODULE, supervise, []).

%%=============================================================================
%% Callbacks
%%=============================================================================

supervise() ->
  process_flag(trap_exit, true),    % don't crash us but rather send us a
                                    %  message when a linked process dies
  Pid = no_otp:start(),             % start our server
  link(Pid),                        % and link to it
  receive {'EXIT', Pid, Reason} ->  % wait for a message that informs us
    case Reason of                  %  that our porcess shut down
      normal -> ok;                 % if the reason is 'normal' do nothing
      _Other -> start_server()      %  otherwise start all over 
   end
  end.
```

### Run A non-OTP supervisor
```erlang
Eshell V5.8.5  (abort with ^G)
1> c(sup).                                   % compile our supervisor module
{ok,sup}
2> sup:start_server().                       % start the supervisor
<0.39.0>                                     % it got the process ID ..39..
3> whereis(no_otp).                          % let's find our no_otp process
<0.40.0>                                     % it got ..40..
4> no_otp:say_hello().                       % let's try to use the API
Hello                                        % works
ok
5> no_otp:get_count().                       % works too 
1
6> no_otp ! crash.                           % time to crash it
crash

=ERROR REPORT===
Error in process <0.40.0> with exit value: 
  {{case_clause,crash},[{no_otp,loop,1}]}   % as expected a case_clause error

7> no_otp:get_count().                      % but a new process was started
0                                           % as we can see here
8> no_otp:stop().                           % now let's stop it 'normally'
ok
9> whereis(no_otp).                         % and check for a new instance
undefined                                   % but there is none. Correct!
10>
```