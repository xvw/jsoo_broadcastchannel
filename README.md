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
module StringBus = BroadcastChannel.Make(
  struct 
    type message = Js.js_string Js.t 
  end
)
```

