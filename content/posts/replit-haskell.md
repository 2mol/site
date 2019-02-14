---
title: "Build Haskell stuff in your browser "
date: 2019-02-13T15:16:55Z
---

## tl;dr

- You can write and execute non-trivial Haskell on [repl.it](https://repl.it/), meaning that you can skip setting up a local development environment.
- The environment secretly includes not just `base`, but couple of other useful libraries.
- You can write command-line programs and have them _automatically_ served up on the web.


## What's an online REPL?

For those that don't know, [repl.it](https://repl.it) is one of many online [REPLs](https://en.wikipedia.org/wiki/REPL) that have cropped up in recent years. Generally you can (for various programming languages) type in some commands, have them executed by whatever interpreter, save code in files/modules, build interactive programs, create websites, etc.

Repl.it great, not least because it started providing a [Haskell environment](https://repl.it/site/blog/haskell) two years ago.

> sidenote: I was skeptical of online programming environments at first, since the idea sounds a bit gimmicky. I changed my mind after seeing how many children build really impressive things in them, and how joyful it feels to use one for quick demos and experiments. It's really easy to send somebody a code snippet that just executes, zero friction. Beginners can still install stack or cabal afterwards, no rush.
>
> side-sidenote: repl.it has this feature where multiple people can join the same editor and all edit at the same time, which is insanely cool. Get some friends and click the "multiplayer" button.


## The libraries nobody told you about

Ok, back to the Haskell environment. Unfortunately it's not clear which packages apart from `base` are built in. Random guessing quickly shows that at least `containers` and `text` are available, but I couldn't find a complete list anywhere. Of course we won't let that stop us. After a bit of fiddling and exploring:

`:! ls -l /opt/ghc/8.6.3/lib/ghc-8.6.3/`

Explanation: `:!` is a ghci command that lets you execute anything in the shell that you have permissions to. Since we can reasonably guess that each repl is just some environment running in a docker container, we just do `:! which ghci` and `:! ls -l something` often enough until we find the `lib` folder.

> I came across this in a [list of all ghci commands](https://downloads.haskell.org/~ghc/7.4.1/docs/html/users_guide/ghci-commands.html), hoping that there is a command that lets you just list the modules available for import in ghci. No such luck, but executing arbitrary shell commands is nice too. Let me know if there is more up-to date documentation anywhere (the above is for GHC 7.4).

Cleaning out some non-library files we find that we have access to the following:

```shell
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

For example, we can write entire interactive command-line programs that repl.it will serve on those `https://[replname].[username].repl.run` domains. [Here](https://haskeline-example.2mol.repl.run/) is an example I copied from the `haskeline` documentation.

If you're not familiar with the libraries above, here's an incomplete overview:

- The great [`containers`](https://hackage.haskell.org/package/containers) lets you use `Set`, `Map`, `Graph`, and `Tree`. The first two are especially nice if you're used to dictionaries and sets from other languages.
- The low-level [`array`](https://hackage.haskell.org/package/array) gives you a structure that is faster than list for accessing elements at an arbitrary index.
- [`parsec`](https://hackage.haskell.org/package/parsec) is your entry ticket into the world of ~~parser-combinators~~ INDUSTRIAL-STRENGTH PARSER COMBINATORS.
- [`text`](https://hackage.haskell.org/package/text) and [`bytestring`](https://hackage.haskell.org/package/bytestring) replace `String` as the proper way to do either user-readable strings or binary data respectively.
- [`mtl`](https://hackage.haskell.org/package/mtl) is how [people cooler than me](https://www.parsonsmatt.org/2018/03/22/three_layer_haskell_cake.html) structure big-boy programs.
- [`template-haskell`](https://hackage.haskell.org/package/template-haskell) is how you write Haskell that writes Haskell.
- [`filepath`](https://hackage.haskell.org/package/filepath) and [`directory`](https://hackage.haskell.org/package/directory) let you interact with the file system, which repl.it _totally lets you do_!

That's it for now, figure out the other libraries yourself. It would obviously be great to have more. For example to have [`wreq`](https://hackage.haskell.org/package/wreq) to make network requests, or some graphics package do create images or draw on the DOM.

With enough interest I'm sure repl.it can be convinced to include more packages. Before discovering all this, I messaged them on their [twitter](https://twitter.com/replit) to ask if they could update GHC from 8.0.x to 8.6.3 in the coming year, and they literally did it within an afternoon. Amazing.

## What now?

Build stuff, now that you have no more excuses. Work through the exercises from [Haskell Programming from first principles](http://haskellbook.com/) (paid, but very worth it), or [Learn You a Haskell](http://learnyouahaskell.com/) (free and utterly charming).

Use [`haskeline`](https://hackage.haskell.org/package/haskeline) and go write a clone of [Zork](https://en.wikipedia.org/wiki/Zork). Do whatever! Share what you make on [r/haskell](https://old.reddit.com/r/haskell/), and come ask questions in the #haskell channel on the [functional programming discord](https://discord.me/fp).

Here is a code snippet so that you don't get bored in the meantime. Save it into a new file in repl.it, hit run and load up the module with something like `:l Entropy.hs`.

```haskell
{-# LANGUAGE ScopedTypeVariables #-}

module Entropy where

import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as M

-- tally the number of occurrences of all the items in a list:
count :: forall a . Ord a => [a] -> Map a Int
count elements =
    foldl addCount M.empty elements
    where
        addCount :: Map a Int -> a -> Map a Int
        addCount counter el = M.insertWith (+) el 1 counter

-- calculate which element occurs which percentage of the time
proportions :: Ord a => [a] -> [Double]
proportions xs =
    [c / n | c' <- counts, let c = fromIntegral c']
    where
        counts = M.elems (count xs)

        n = fromIntegral $ length xs

-- entropy measure
-- https://en.wikipedia.org/wiki/Entropy#Statistical_mechanics
entropy :: Ord a => [a] -> Double
entropy xs =
    -sum [p * logBase 2 p | p <- proportions xs]
```

