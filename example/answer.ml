let io x = Firebug.console##log x

module StringBus = BroadcastChannel.Make(
  struct
    type message = Js.js_string Js.t 
  end)

let bus_test = StringBus.create "test"

let _ = StringBus.onmessage 
  bus_test
  (fun ev ->
    io (ev##.data); 
    Js._true
  )