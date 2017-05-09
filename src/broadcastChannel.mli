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
 *)


(** {1 Common API} *)

(** Checks if the BroadcastChannel is available for the client *)
val is_supported : unit -> bool

(** {1 Functors and interfaces} *)

(** A Required interfaces to built a BroadCaster *)
module type REQUIRED = 
sig 
  type message
end


(** The interface of a broadcaster *)
module type BROADCASTER = 
sig

  include REQUIRED

  class type broadcaster = 
  object 
    inherit Dom_html.eventTarget
    method name  : (Js.js_string Js.t) Js.readonly_prop
    method close : unit -> unit Js.meth
    method postMessage :  message -> unit Js.meth
  end

  type t = broadcaster Js.t

  val create: string -> t
  val close: t -> unit
  val name: t-> string
  val post: t -> message -> unit

end

(** Functor to built a typed broadcaster *)
module Make (B : REQUIRED ) : BROADCASTER 
  with type message = B.message
