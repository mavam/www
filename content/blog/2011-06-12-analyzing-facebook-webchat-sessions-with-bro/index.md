---
title: 'Analyzing Facebook Webchat Sessions with Bro'
created_at: 2011-06-12
updated_at: 2012-11-24
kind: article
tags: [ 'bro', 'browser', 'reverse engineering', 'traffic analysis' ]
---

**Update** (*November 24, 2012*): After Facebook [switched to HTTPS
only](http://techcrunch.com/2012/11/18/facebook-https/), this script no longer
works with life traffic.

The Facebook webchat allows you to chat with your friends while having a
Facebook window open in the browser. In this post, I describe how the webchat
protocol works and show how to write a [Bro](http://www.bro-ids.org) script
that analyzes chat sessions.

## The Facebook Webchat Protocol

![Facebook](fb-icon.png){:.float-right .margin-left-1}
Behind the scenes, the webchat utilizes a long-lived AJAX connection to
send messages between the user and the Facebook server. A user that logs in
automatically opens such a connection, destined to
`^([0-9]+\.)+channel\.facebook.com$`, to receive asynchronous status updates
(e.g., notifications that your friends are currently typing). Whenever Facebook
wants to notify you, it encodes a message into a JSON object and ships it back
to you where some JavaScript munges on it. This AJAX channels contains both
control and data which creates an event-based communication channel to deliver
a low-latency user-experience on the client side.

As a traffic analyst, you might wonder how one can get insight into the
webchat protocol details and how to work with it at a higher level. After all,
who wants to write boilerplate code whose only purpose is to fight the
*representation of the data* rather than analyzing the data itself? Let us
extract messages from a Facebook webchat conversation and put them into
Bro data structures where they are easy to manipulate, print, and react upon.
This involves parsing the JSON objects, which look like this:

``` javascript
for (;;);{"t":"msg","c":"p_100002331422524","s":4,\
  "ms":[{"window_id":1985081376,"type":"unfocus_chat"}]}
```

The above example is an `unfocus_chat` event sent over the AJAX channel,
indicating that the user placed the focus somewhere else on the page, away from
the chat window. Here is another HTTP body:

``` javascript
for (;;);{"t":"msg","c":"p_100002331422524","s":6,"ms":[{"msg":{
  "text":"So I need the URL, dude.  What is it?","time":1303218454567,\
  "clientTime":1303218453582,"msgID":"2755876075"},"from":100002331422524,\
  "to":100002297942500,"from_name":"Mondo Cheeze","from_first_name":"Mondo",\
  "from_gender":2,"to_name":"Udder Kaos","to_first_name":"Udder",\
  "to_gender":2,"type":"msg"
}]}
```

This one is an actual chat message. The nice thing is that such messages are
self-contained and include quite some meta information: contents, timestamps,
names, unique IDs, and even genders.

## The Bro Script

Alas, the HTTP body is a big fat opaque string with no structure and parsing
nested data in strings with just regular expression is clunky at best. (For
those who have spare cycles: an extremely useful project would be to create a
Bro analyzer that exposes first-class types of the DOM tree of a document and
script-level primitives for basic JavaScript analysis.) A crude way to do this
is splitting the string on `,"`, then finding the right key-value pairs, and
populating the following Bro data structures with the parsed data:

``` bro
type chat_message: record
{
    timestamp: string;  # Message timestamp.
    from: string;       # Name of the sender
    to: string;         # Name of the recipient.
    text: string;       # The actual message.
};

type chat_session: record
{
    start: time;        # Unix timestamp of first message.
    end: time;          # Unix timestamp of last message.
    n: count;           # Total number of messages in session.
};
```

At this point it is easy to generate NOTICES with chat messages, look for
suspicious messages, and more generally, leverage Bro's full scripting language
more effectively. I wrote a basic script that uses these data types to dump a
chat session between two buddies. You can download it as a [github
gist][facebook.bro]. Here is the output of `facebook.bro` of a sample Facebook
webchat session:

``` none
1303218454567 (Mondo Cheeze -> Udder Kaos) So I need the URL, dude.  What is it?
1303218465938 (Udder Kaos -> Mondo Cheeze) the URL?
1303218474259 (Mondo Cheeze -> Udder Kaos) Yeah for the secret image
1303218481721 (Udder Kaos -> Mondo Cheeze) ok lemme see
1303218495626 (Mondo Cheeze -> Udder Kaos) Someone could be sniffing this conversation, be sure to send it safely
1303218503972 (Udder Kaos -> Mondo Cheeze) ?
1303218570782 (Mondo Cheeze -> Udder Kaos) Cmon we talked about this.  Encrypt it with WonderCipher-92 \
                                           and send me the Base64 encoding of the hex.  Usual key.
1303218587568 (Udder Kaos -> Mondo Cheeze) 'k.  So here it is:
1303218595067 (Udder Kaos -> Mondo Cheeze) NmQwMDJjZDdhZTdlYmYxNTc5MGVjZDc1YTYxNDk1OGE0ZTRhYjAzOTVi
1303218618252 (Mondo Cheeze -> Udder Kaos) What's the IV
1303218624712 (Udder Kaos -> Mondo Cheeze) huh?
1303218637197 (Mondo Cheeze -> Udder Kaos) Initialization vector, you maroon.  WC-92 is a stream cipher, you know
1303218667601 (Udder Kaos -> Mondo Cheeze) oh yeah.  I used my birthday, all as one number.
1303218685436 (Udder Kaos -> Mondo Cheeze) you *do* remember it, right?
1303218700515 (Mondo Cheeze -> Udder Kaos) yeah your an April Fool, not hard to remember
1303218710402 (Udder Kaos -> Mondo Cheeze) heh
1303218718486 (Mondo Cheeze -> Udder Kaos) K gimme a sec to decrypt then.
1303218733463 (Mondo Cheeze -> Udder Kaos) Hey idiot this isn't the secret, it's Google's home page.
1303218745028 (Udder Kaos -> Mondo Cheeze) whoops hang on, blew my cut&paste
1303218767633 (Udder Kaos -> Mondo Cheeze) okay, here's the right one:
1303218776922 (Udder Kaos -> Mondo Cheeze) NmQwMDJjZDdhZTdlYmYwMDY3MGRjZDdlYjA1NDlhODQ0ZjA1YmEyNDRm
1303218800303 (Mondo Cheeze -> Udder Kaos) And?
1303218807537 (Udder Kaos -> Mondo Cheeze) and what
1303218815022 (Mondo Cheeze -> Udder Kaos) What's the IV
1303218824330 (Udder Kaos -> Mondo Cheeze) huh?
1303218839537 (Mondo Cheeze -> Udder Kaos) yo maroon same thing as we just discussed a moment ago, sheesh
1303218855518 (Udder Kaos -> Mondo Cheeze) oh that yeah like I said my birthday
1303218869728 (Mondo Cheeze -> Udder Kaos) You used the same IV as before????
1303218889893 (Udder Kaos -> Mondo Cheeze) right, otherwise how would I remember it?
1303218900257 (Mondo Cheeze -> Udder Kaos) YOU BOZO
```

In summary, this is an example of how to translate low-level representation of
communication into higher abstractions that are easier to work with. After
creating first-class Bro types for the involved entities, one can now leverage
the real power of Bro's scripting language.

[facebook.bro]: https://gist.github.com/4141216
