module StringBus = BroadcastChannel.Make(
  struct
    type message = Js.js_string Js.t 
  end)

let bus_test = StringBus.create "test"

let _ = 
  StringBus.addEventListener
    bus_test
    StringBus.message
    (Dom_html.handler (fun _ -> Js._true))
    Js._true