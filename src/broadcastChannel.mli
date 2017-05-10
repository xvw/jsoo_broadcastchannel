(* MIT License
 * 
 * Copyright (c) 2017 Xavier Van de Woestyne
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *)

(** [jsoo_broadcastchannel] provides a wrapper around the BroadcastChannel API 
    in JavaScript. 
    The BroadcastChannel interface represents a named channel that any browsing context 
    of a given origin can subscribe to. It allows communication between different documents 
    (in different windows, tabs, frames or iframes) of the same origin. Messages are 
    broadcasted via a message event fired at all BroadcastChannel objects listening 
    to the channel.

    You can have more details here : https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel
 *)


(** {1 Exceptions and types} *)

(** Exception if BroadcastChannel is not supported *)
exception Not_supported

(** Class type to define a messageEvent *)
class type ['message] messageEvent = 
  ['message] EventSource.messageEvent
  
(** Shortcut for a messageEvent *)
type 'a message = 'a messageEvent Js.t

(** Interface of a BroadcastChannel *)
class type ['message] broadcaster = 
object ('self)
  inherit Dom_html.eventTarget
  method name  : (Js.js_string Js.t) Js.readonly_prop
  method close : unit -> unit Js.meth
  method postMessage :  'message -> unit Js.meth
  method onmessage: 
    ('self Js.t, 'message message) Dom_html.event_listener Js.writeonly_prop
end

(** Shortcut for a broadcaster *)
type 'a t = 'a broadcaster Js.t

(** {1 Common functions} *)

(** Returns [true] if BroadcastChannel is supported by the 
    client's browser, false otherwise.
  *)
val is_supported : unit -> bool

(** Creates a BroadcastChannel with a name. Raise [Not_supported "BroadcastChannel"] 
    if BroadcastChannel is not supported by the client's browser.
*)
val create: string -> 'message t

(** Creates a BroadcastChannel with a name. Raise [Not_supported "BroadcastChannel"] 
    if BroadcastChannel is not supported by the client's browser.
    The functions takes a "sample of a message" to fix the types of the broadcaster. 
    The functions returns a couple of the BroadcastChannel and the [Event] (to be used)
    in [addEventListener].
*)
val create_with: string -> 'a -> ('a t * 'a message Dom.Event.typ)


(** Closes the channel object, indicating it won't get any new messages, 
    and allowing it to be, eventually, garbage collected. 
*)
val close:  'message t -> unit

(** Returns a [string], the name of the channel. *)
val name:   'message t -> string

(** Sends the message, of the broadcaster type to each BroadcastChannel 
    object listening to the same channel. 
*)
val post:   'message t -> 'message -> unit

(** Is an [EventHandler] property that specifies the function to execute
    when a message event is fired on this object.
*)
val on:     'message t -> ('message message -> bool Js.t) -> unit


(** {1 Event support} *)

(** Add an event listener. This function matches the [addEventListener] 
    DOM method, except that it returns an id for removing the listener. 
*)
val addEventListener : 
  'a t
  -> 'a message Dom.Event.typ
  -> ('a t, 'a message) Dom.event_listener
  -> bool Js.t 
  -> Dom.event_listener_id

(** An event to be used with [addEventListener] *)
val message : 'a t -> 'a message Dom.Event.typ

(** An event to be used with [Lwt_js_events] *)
val lwt_js_message: 
  ?use_capture:bool 
  -> 'a t 
  -> ('a messageEvent) Js.t Lwt.t