---
title: "Build Haskell stuff in your browser"
date: 2019-02-13
draft: true
---

# Build Haskell stuff in your browser

## Too long; didn't read

- You can write and execute non-trivial Haskell on [repl.it](https://repl.it/), meaning that you can skip setting up a local development environment.
- It secretly includes not just `base`, but couple of other useful libraries.
- You can write command-line programs and have them _automatically_ served up on the web.

## What's an online REPL?

For those that don't know, [repl.it](https://repl.it) is one of many online [REPLs](https://en.wikipedia.org/wiki/REPL) that have cropped up in recent years. Generally you can (for various programming languages) type in some commands, have them executed by whatever interpreter, save code in files/modules, build interactive programs, create websites, etc.

Repl.it is my favourite, in part because it's very well executed, in part because it started providing a [Haskell environment](https://repl.it/site/blog/haskell) early on.

> Sidenote: I was very skeptical at first because an online programming environment doesn't seem Very Serious(TM). After finding myself using it for quick teaching demos and experiments, I've come around to the realization that it's actually _amazing_ to just get started coding without having to set anything up. Especially for beginners. You can still install stack or cabal afterwards, no rush.
>
> Side-sidenote: Even better, multiple people can join the same editor together and all edit at the same time, which is insanely cool. Get some friends and click the "multiplayer" button.

## The libraries nobody told you about

Ok, back to the Haskell environment. Unfortunately it's not clear which packages apart from `base` are built in. Random guessing quickly shows that at least `containers` and `text` are available, but I couldn't find a complete list anywhere. Of course we won't let that stop us. After a bit of fiddling and exploring:

`:! ls -l /opt/ghc/8.6.3/lib/ghc-8.6.3/`

Explanation: `:!` is a ghci command that lets you execute anything in the shell that you have permissions to. Since we can reasonably guess that each repl is just some environment running in a docker container, we just do `:! which ghci` and `:! ls -l something` often enough until we find the `lib` folder.

> Sidenote: I came across this in a [list of all ghci commands](https://downloads.haskell.org/~ghc/7.4.1/docs/html/users_guide/ghci-commands.html), hoping that there is a command that lets you just list the modules available for import in ghci. No such luck, but executing arbitrary shell commands is nice too. Let me know if there is more up-to date documentation anywhere, this is for GHC 7.4.

Cleaning out some non-library files we find that we have access to the following:

```
Cabal-2.4.0.1
array-0.5.3.0
base-4.12.0.0
binary-0.8.6.0
bytestring-0.10.8.2
containers-0.6.0.1
deepseq-1.4.4.0
directory-1.3.3.0
filepath-1.4.2.1
haskeline-0.7.4.3
hpc-0.6.0.3
integer-gmp-1.0.2.0
mtl-2.2.2
parsec-3.1.13.0
pretty-1.1.3.6
process-1.6.3.0
stm-2.5.0.0
template-haskell-2.14.0.0
terminfo-0.4.1.2
text-1.2.3.1
time-1.8.0.2
transformers-0.5.5.0
unix-2.7.2.2
xhtml-3000.2.2.1
```

FUN. I don't know about you, but at this point I get pretty excited, since this means that we can write a lot more serious stuff than I had initially realized.

For example, we can write entire interactive command-line programs that repl.it will serve on those https://[replname].[username].repl.run domains. I immediately thought of using `haskeline` to write an clone of [Zork](https://en.wikipedia.org/wiki/Zork).

Just some of the basic highlights:

- The great `containers` lets you use `Set`, `Map`, `Graph`, and `Tree`. The first two are especially nice if you're used to dictionaries and sets from other languages.
- The low-level `array` gives you a structure that is faster than list for accessing elements at an arbitrary index.
- `parsec` is your entry ticket into the world of ~parser-combinators~ INDUSTRIAL-STRENGTH PARSER COMBINATORS.
- `text` and `bytestring` replace `String` as the proper way to do either user-readable strings or binary data respectively.
- `mtl` is how [people cooler than me](https://www.parsonsmatt.org/2018/03/22/three_layer_haskell_cake.html) structure big-boy programs.
- `template-haskell` is how you write Haskell that writes Haskell.
- `filepath` and `directory` let you interact with the file system, which repl.it _totally let's you do_!

That's it for now. It would be great to have more libraries of course. For example to have `wreq` to make network requests, or some sort of graphics package would go a long way to make more useful programs. With a bit of luck and enough interest I'm sure repl.it can be convinced to include more packages. For example, I asked them over [twitter](https://twitter.com/replit) if they could update GHC from 8.0.x to 8.6.3 in the next couple of months, and they literally did that within an afternoon. Amazing.

Go make some cool things and share them on [r/haskell](https://old.reddit.com/r/haskell/) or come ask questions in the #haskell channel on the [functional programming discord](https://discord.me/fp).

