---
title: 'Email Attachment Processing with Bro'
created_at: 2009-08-16
updated_at: 2011-04-13
kind: article
tags: [ 'bro', 'email', 'intrusion detection', 'SMTP', 'traffic analysis' ]
---

Malware that spreads via email is nothing new. Particularly
[targeted][ghostnet1] [attacks][ghostnet2] against politically sensitive
institutions or individuals consist of well socially engineered mails and often
ship with custom [0-day malware][defcon17] in the form of email attachments. In
order to extract such malicious attachments, I wrote a
[Bro](http://www.bro-ids.org) policy script which records suspicious
attachments to disk for later analysis. A possible application scenario would
be to scan office documents for malicious JavaScript or executables for
viruses. Another option would be [hashing the attachment directly in
Bro][malware hash] and comparing it against a publicly available registry, such
as Seth Hall illustrates for HTTP traffic.

[ghostnet1]: http://www.scribd.com/doc/13731776/Tracking-GhostNet-Investigating-a-Cyber-Espionage-Network
[ghostnet2]: http://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-746.html
[defcon17]: http://www.defcon.org/html/defcon-17/dc-17-speakers.html#Richard
[malware hash]: http://wiki.github.com/sethhall/bro_scripts/the-malware-hash-registry-and-bro-ids

The script to extract attachments works by registering a callback handler for
the `Content-Type` header in an SMTP session. Then both MIME type and the
name of the attachment is examined. If either looks suspicious, Bro generates a
`SensitiveMIMEType` or `SensitiveExtension`
[NOTICE](http://blog.icir.org/2008/03/telling-bro-what-important.html).
The user can customize the the analyzer behavior in many ways. To change the
directory where the attachments are stored on disk, one can redefine the
`attachment_dir` variable:

``` bro
redef Email::attachment_dir = "foo";
```

The script stores the attachments by default, but this behavior can easily
changed via:

``` bro
# Whether attachments with sensitive MIME types should be stored.
redef Email::store_sensitive_mime_types = F;

# Whether attachments with sensitive file extensions should be stored.
redef Email::store_sensitive_extensions = F;
```

It is also possible to restrict or extend the regular expression used to
determine whether an attachment is sensitive or not:

``` bro
# Deem only application\/octet-stream as suspicious.
redef Email::sensitive_mime_types = /application\/octet-stream/;

# Restrict sensitive extensions to office documents and executables.
redef Email::sensitive_extensions =
    /[pP][dD][fF]$/
  | /[dD][oO][cC][xX]?$/
  | /[xX][lL][sS]$/
  | /[pP][pP][sStT]$/
  | /[eE][xX][eE]$/
  | /[cC][oO][mM]$/
  | /[bB][aA][tT]$/;
```

The script generates a file of the form `ID-filename` where `ID` is a unique
attachment ID that is monotonically increasing and `filename` is the name of
the attachment or just the MIME type if the attachment does not have a name.

The script is part of the [Bro scripts](http://git.bro-ids.org/bro-scripts.git)
git repository where you can always [download the most recent version][bro
script].

[bro script]: http://git.bro-ids.org/bro-scripts.git/blob_plain/HEAD:/mime-attachment.bro
