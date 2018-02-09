---
title: 'Github Commit Emails with Full Diff of Changes'
created_at: 2012-12-18
kind: article
tags: [ 'email', 'tools', 'ruby' ]
---

![Finally, diff emails for github!](octocat.jpeg){:.float-right}
Folks who excessively use version control software like to track the progress
of a project by just inspecting the commit messages which contain an
incremental diff. Git users who manage their own repository infrastructure can
already today enjoy Robin Sommer's [git-notifier][git-notifier], a small
utility which sends out emails containing detailed diffs of the changes. It
works by adding git-notifier as [post-receive
hook](http://git-scm.com/book/en/Customizing-Git-Git-Hooks) in the remote bare
repository.

When hosting the repository at github this doesn't work anymore, because github
does not offer direct access to the bare repository, but instead offers a
predefined set of [service hooks](https://github.com/github/github-services).
Alas, the [existing email
hook](https://github.com/github/github-services/blob/master/services/email.rb)
cannot send out diffs, which greatly limits its usefulness. This poses the
question: can github users still obtain emails with diffs? 

## git-notifier + github = gitdub

Enter [gitdub][gitdub]: a slim [sinatra](http://www.sinatrarb.com/) HTTP server
that utilizes github's [webhook
API](https://help.github.com/articles/post-receive-hooks) to feed git-notifier.
More specifically, when adding gitdub as webhook for your git repository, each
push elicits a HTTP POST request with [details about the
changeset](https://gist.github.com/2732972). Gitdub parses this data, updates
its corresponding local bare git repository, and then invokes git-notifier to
mail out the diffs.

## Setup

To start dubbing your commits with gitdub, you only need a machine with a
public IP address that can receive inbound TCP connections. In a nutshell,
setting up gitdub involves [configuring a
webhook](https://help.github.com/articles/post-receive-hooks) for your
github repository creating a YAML configuration file. The example below shows a
brief configuration file, a [more detailed, commented
version](https://github.com/mavam/gitdub/blob/master/config.yml.example) exist
in the repository.

``` yaml
gitdub:
  bind: 0.0.0.0
  port: 8888
  allowed_sources: [207.97.227.253, 50.57.128.197, 108.171.174.178]

notifier:
  from: gitdub
  to: [user1@host.com, user2@host.com]

github:
  - id: mavam/gitdub
    to: [vallentin@icir.org]
    subject: '[git/gitdub]'
  - id: mavam/.*
    to: [vallentin@icir.org]
```

The last block `github` contains information about your github repositories.
Gitdub processes the blocks sequentially and tries to match the `id` field
against the data from the commit, where the first match "wins." In the above
example, there exists an entry for `mavam/gitdub` and then a wildcard entry for
all commits of user `mavam`. In each entry, you can overload settings from the
`notifier` block. For a complete example, please refer to the [gitdub
README][gitdub].

## Example

An exemplary email from git-notifier looks like this:

``` none
Repository : ssh://git@bro-ids.icir.org/bro

On branch  : topic/matthias/opaque
Link       : http://tracker.bro-ids.org/bro/changeset/483cc6bd9eebb4883b5784f39325253581e9cb30/bro

>---------------------------------------------------------------

commit 483cc6bd9eebb4883b5784f39325253581e9cb30
Author: Matthias Vallentin <vallentin@icir.org>
Date:   Thu Dec 13 17:51:42 2012 -0800

    Fix a hard-to-spot bug.


>---------------------------------------------------------------

483cc6bd9eebb4883b5784f39325253581e9cb30
 src/Type.cc |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/Type.cc b/src/Type.cc
index 30ff3ce..a78da7f 100644
--- a/src/Type.cc
+++ b/src/Type.cc
@@ -1294,7 +1294,7 @@ bool OpaqueType::DoUnserialize(UnserialInfo* info)
        {
        DO_UNSERIALIZE(BroType);
        char const* n;
-       if ( ! UNSERIALIZE_STR(&n, 0) );
+       if ( ! UNSERIALIZE_STR(&n, 0) )
          return false;
        name = n;
        return true;
```

Gitdub code comes with a BSD-style license. I much appreciate feature requests,
bug reports, or any other form of feedback. Happy project tracking!

[git-notifier]: http://www.icir.org/robin/git-notifier/
[gitdub]: https://github.com/mavam/gitdub
