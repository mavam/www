---
title: 'Omni, Take Two'
created_at: 2011-06-15
kind: article
math: true
tags: [ 'math' ]
---

Did you know that 2 equals 1? Here is the
[proof](http://en.wikipedia.org/wiki/Mathematical_fallacy):

``` none
(1) X = Y                         ; Given
(2) X^2 = XY                      ; Multiply both sides by X
(3) X^2-Y^2 = XY-Y^2              ; Subtract Y^2 from both sides
(4) (X+Y)(X-Y) = Y(X-Y)           ; Factor
(5) X+Y = Y                       ; Cancel out (X-Y) term
(6) 2Y = Y                        ; Substitute X for Y, by equation 1
(7) 2 = 1                         ; Divide both sides by Y
                -- "Omni", proof that 2 equals 1
```

If you think this is too easy, here is another neat proof spotted by my friend
Avital Steinitz while teaching a Signals and Systems course.

> Consider the function $$f : \mathbb{R} \to \mathbb{C}$$ given by the rule
> $$f(t) = e^{i2\pi t}$$, also known as the phaser with frequency $$2\pi$$. We
> show that this function is in fact the constant function $$1$$:

$$
\forall t \in \mathbb{R}: 
f(t) = e^{i2\pi t} = \left(e^{i2\pi}\right)^t = 1^t = 1.
$$

\$$\square$$
{:.float-right}
