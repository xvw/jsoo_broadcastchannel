let io x = Firebug.console##log x

module StringBus = BroadcastChannel.Make(
  struct
    type message = Js.js_string Js.t 
  end)


let a = StringBus.create "test"

let () = Firebug.console##log(a)
let () = Firebug.console##log(StringBus.name a)





let _ = 
  let open Lwt_js_events in 
  async_loop 
    keydown 
    Dom_html.window 
    (fun _ _ ->
      let _ = io "test" in
      let _ = StringBus.post a (Js.string "Hello World") in
      Lwt.return_unit 
    )


