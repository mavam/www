---
title: 'The Doom of Client-Side Wireless Network Security'
created_at: 2008-05-10
kind: article
tags: [ 'browser', 'cookies', 'exploits', 'metasploit', 'wireless' ]
disqus: 3054697649706319082
---

HD Moore [recently announced](http://hamsterswheel.com/techblog/?p=55) the
integration of the [KARMA](http://www.theta44.org/karma) tools with the
[metasploit](http://www.metasploit.com) framework. The implications of this
fusion are devastating. In an interview with Patrick Gray, HD presents the new
powerful capabilities that take client-side wireless exploitation to a new
level. Technically, HD rewrote parts of the original KARMA driver, included 
[some](http://digininja.org)
[patches](http://blog.metasploit.com/2008/02/rise-security-vs-asus-eee-pc.html),
and integrated the KARMA user-land daemons into the metasploit framework.

To illustrate the new potent features of metasploit, consider the following
scenario. A user opens his laptop on the plane to watch a DVD. If he ever
connected to an insecure access point, it will be in his list of list of
preferred wireless networks. Since the operating system attempts to connect to
all known wireless networks at boot time or when waking up from hibernation, it
sends out probes to look for known networks. An attacker, a couple of rows
behind, responds to the probes, provides an IP address to victim by DHCP and is
now rigged up to launch a multitude of client-side attacks.

Unaware of being owned, the victim's mail client periodically tries to re-send
emails laying around in the outbox. The DNS request for the SMTP server is
intercepted by the attacker who returns his own address. Further, he mimics the
entire SMTP connection handshake when the victim connects. Thus the victim
sends his emails directly to the attacker through a fake SMTP channel.
This scenario extends of course to any other plain-text protocol (HTTP, FTP,
POP3, etc.). Clearly, the dominant position of the attacker yields
ample opportunity for more sophisticated client-side wireless attacks, as the
next examples by HD show.

- **Massive cookie stealing**.  Traditional [cookie
  stealing](http://community.corest.com/~hochoa/wifizoo/index.html) presupposes
  that the victim *actively* transmits a cookie from a particular web site in
  order to be captured by the attacker. In contrast, this attack only requires
  a single HTTP request to originate from the victim to hijack *all* cookies
  from the victim's browser. In general, only the requested site is allowed to
  read that particular cookie. With a malicous server responding to all client
  request, the attacker can bypass this restriction. When a victim sends a HTTP
  request, the attacker returns a chosen list of web sites (say the current top
  500 sites) and the browser then tries to connect to each site with the
  corresponding cookie. Because all sites resolve back to the same attacker's
  hostname, all cookies arrive in the hands of the attacker. Thus, by merely
  trying to access an arbitrary page in the Internet, the victim exposed all
  his cookies that correspond to entry in the attacker's list of sites.

- **Browser credential theft**. The next interesting step from the attacker's
  perspective is it to hunt for usernames and passwords. To this end, HD wrote
  a little script storing all form information of the top 500 websites, e.g.
  forms asking for personal data, SSN, bank account number, MySpace and
  Facebook logins, and so on. When the victim visits *any* arbitrary website,
  the attackers returns a page full of frames that open the pages from the list
  and contain the saved form snippets. If the victim enabled automatic form
  fill-out in his browser preferences, the forms are auto-populated with
  sensitive user data. In addition to the form snippets the attacker delivers a
  malicious piece of JavaScript that grabs the form contents after filled out
  by the browser and sends them back to the attacker.  Hence a single page
  visit results in a complete compromise of the victim's login credentials and
  personal data.

- **Web-based SMB relay exploitation**. Worse, if the victim happens to use
  Internet Explorer, a [weakness][SMB reflection] in Microsoft's SMB file
  sharing authentication protocol can be [exploited][tactical exploitation] to
  own the victim's machine completely. By including a link pointing to a
  network file share, the victim is forced to authenticate to the attacker's
  fake SMB server. This exposes the challenge key that can in turn fed back to
  the client.  Essentially, the victim now authenticates against himself. Once
  connected, the incoming connection is disconnected and the new session serves
  as a vehicle to execute arbitrary shellcode.

Who knows what HD's new toy features beyond the sketched scenarios? In any
case, these attack vectors witness how broken the actual model of wireless
security on the client-side is. While the industry tries to fix wireless
encryption schemes, the actual targets, the users themselves, are not
considered in the equation. These new techniques essentially render networking
in any wireless environment tremendously insecure.

[SMB reflection]: http://perimetergrid.com/wp/2007/11/27/smb-reflection-made-way-too-easy
[tactical exploitation]: http://www.metasploit.net/data/confs/blackhat2007/tactical_paper.pdf
