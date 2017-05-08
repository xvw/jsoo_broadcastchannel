let io x = Firebug.console##log x

let a = BroadcastChannel.create "testLDKZLMKD"

let () = Firebug.console##log(a)
let () = Firebug.console##log(BroadcastChannel.name a)





let _ = 
  let open Lwt_js_events in 
  async_loop 
    keydown 
    Dom_html.window 
    (fun _ _ ->
      let _ = io "test" in
      Lwt.return_unit 
    )


