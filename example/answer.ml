let io x = Firebug.console##log x

module StringBus = BroadcastChannel.Make(
  struct
    type message = Js.js_string Js.t 
  end)

let bus_test = StringBus.create "test"

let _ = 
  let f = (fun e -> io e##.data; Js._true) in 
  StringBus.addEventListener
    bus_test
    StringBus.Event.message
    (Dom.handler f)
    Js._true


(*
let _ = StringBus.onmessage 
  bus_test
  (fun ev ->
    io (ev##.data); 
    Js._true
  )
*)