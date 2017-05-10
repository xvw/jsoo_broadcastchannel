# Jsoo_broadcastchannel 

[Checkout the documentation](https://xvw.github.io/jsoo_broadcastchannel/)

> The **BroadcastChannel** interface represents a named channel that any browsing context 
> of a given origin can subscribe to. It allows communication between different documents 
> (in different windows, tabs, frames or iframes) of the same origin. Messages are broadcasted 
> via a message event fired at all **BroadcastChannel** objects listening to the channel.
[Reference](https://developer.mozilla.org/fr/docs/Web/API/BroadcastChannel)


**Jsoo_broadcastchannel** is a binding for the [BroadcastChannel Api](https://developer.mozilla.org/fr/docs/Web/API/BroadcastChannel). 

## Example of use

### Creating a channel an post message (on a first file)  : 

```ocaml
let channel = BroadcastChannel.create "my_first_channel"
let _ = BroadcastChannel.post channel (Js.string "Hello World")
```

### Receiving message from the channel `my_first_channel` on an another file with `onmessage`

```ocaml
(* Retreive the channel *)
let channel : Js.string Js.t BroadcastChannel.t = 
  BroadcastChannel.create "my_first_channel"
(* You have to fix the type of the channel, you can also use [BroadcastChannel.create_with] *)

let _ = 
  BroadcastChannel.on
    channel 
    (fun ev -> 
      (* Use the ev object *)
      Js._true
    )
```

### Receiving message from the channel `my_first_channel` on an another file with `addEventListener`

```ocaml
(* Retreive the channel *)
let channel : Js.string Js.t BroadcastChannel.t = 
    BroadcastChannel.create "my_first_channel"
(* You have to fix the type of the channel, you can also use [BroadcastChannel.create_with] *)

let _ = 
  BroadcastChannel.addEventListener
    channel
    (BroadcastChannel.message channel)
    (Dom.handler (fun ev -> ... Js._true))
    Js._true
```

Or you can use `BroadcastChannel.create_with` (for a more conveinent usage, without type anotation)

```ocaml
(* Retreive the channel *)
let (channel, message_event) = 
  BroadcastChannel.create_with 
    "my_first_channel"
    (Js.string "a sample")

let _ = 
  BroadcastChannel.addEventListener
    channel
    message_event
    (Dom.handler (fun ev -> ... Js._true))
    Js._true
```

### Receiving message from the channel `my_first_channel` on an another file with `Lwt_js_events`

```ocaml
(* Retreive the channel *)
let channel : Js.string Js.t BroadcastChannel.t = 
  BroadcastChannel.create "my_first_channel"

let _ = 
  Lwt_js_events.async_loop 
    BroadcastChannel.lwt_js_message
    channel
    (fun ev _ -> 
      ... 
      Lwt.return_unit
    )
```



## Special thanks
I would like to sincerely thank @drup for his advice on the implementation 
and the design of the API !

## Sample 

![An example (see the `example` directory)](http://full.ouplo.com/11/13/4MWF.gif)

