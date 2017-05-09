let io x = Firebug.console##log x

module StringBus = BroadcastChannel.Make(
  struct
    type message = Js.js_string Js.t 
  end)

module TestBus = BroadcastChannel.Make(
  struct 
    type message = <
      x : int Js.readonly_prop; 
      y : int Js.readonly_prop
    > Js.t
  end
)


let a = StringBus.create "test"

let () = io a
let () = io (StringBus.name a)





let _ = 
  let open Lwt_js_events in 
  async_loop 
    keydown 
    Dom_html.window 
    (fun _ _ ->
      let _ = StringBus.post a (Js.string "JKSJDLSJLKD") in
      Lwt.return_unit 
    )


