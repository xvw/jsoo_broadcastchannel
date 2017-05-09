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
let b = TestBus.create "test2"

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
      let _ = TestBus.post 
        b 
        (object%js 
          val x = 10 
          val y = 12
        end)
      in 
      Lwt.return_unit 
    )


