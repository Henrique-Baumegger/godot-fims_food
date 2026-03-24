# godot-fims-food

## My conventions
### Function order
- possible overrider
- public : no "_" at the start
- private : "_" at the start

## Groups


## TODO
- Real icon on dobloons
- Real icons for chef hats

- Make a "GameLoopUIManager" (add it into a group) with:
meals on the center, days on the left
button, money and lives on the right.
Apply the cool styleBox to them all (except button)
potentially add outlines to button ands its text.
Make moenyLabel into MoneyManager. 

-Shop: One shop visit inbetween days. 
The more you buy of an ingredient/drink in a single shop visit, the cheaper it gets, 
so you are incentivized to buy a specific product in bulk.
(first buy is 20->19->18->...->1->1->1->1...)
Always all 3 ingredients, but only one drink type. Amount avalible is infinite.
Each product has a chance to be on sale, or expensive. This influences the initial price for it..
Also at each shop you can pay to refill your whole health. It always costs the same, no matter the health. Very expensive.
