# Jsoo_broadcastchannel 

[Checkout the documentation](https://xvw.github.io/jsoo_broadcastchannel/)

> The **BroadcastChannel** interface represents a named channel that any browsing context 
> of a given origin can subscribe to. It allows communication between different documents 
> (in different windows, tabs, frames or iframes) of the same origin. Messages are broadcasted 
> via a message event fired at all **BroadcastChannel** objects listening to the channel.
[Reference](https://developer.mozilla.org/fr/docs/Web/API/BroadcastChannel)



![An example (see the `example` directory)](http://full.ouplo.com/11/13/4MWF.gif)




**Jsoo_broadcastchannel** is a binding for the [BroadcastChannel Api](https://developer.mozilla.org/fr/docs/Web/API/BroadcastChannel). The library provides a 
functor to build *Typed Bus*. 

For example, a bus for String : 

```ocaml
(* Creation a module to build String bus *)
module StringBus = BroadcastChannel.Make(
  struct 
    type message = Js.js_string Js.t 
  end
)

(* Bus 's creation)
let a_bus = StringBus.create "my_first_bus"
```

## Listening

You have 3 ways to listen on a bus : 

### AddEventListener

```ocaml
let _ =
  StringBus.addEventListener
    a_bus 
    StringBus.Event.message 
    (Dom.handler (fun ev -> ... ; Js._true end))
    Js._true
```

### With OnMessage

```ocaml
let _ =
  StringBus.onmessage
    a_bus 
    (fun ev -> ... ; Js._true end)
```

### With `Lwt_js_events`

```ocaml
let _ = 
  Lwt_js_events.(
    async_loop
      Common.StringBus.Event.lwt_js_message
      bus
      (fun ev _ -> ... ; Lwt.return_unit
      )
  )
```



