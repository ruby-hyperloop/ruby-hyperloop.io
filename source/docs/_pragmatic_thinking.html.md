Hyperloop provides all the architectural constructs you need for a well designed, modern web application but we are **not strongly opinionated** as to how you use it. We would like you to find your own way through this architecture, to use the parts that make the most sense for your application and coding style.

Here are a few pragmatic pointers which might help you:

+ If a state is only mutated inside of a Component then leave it as a state in the Component. For example, a state that is tracking the current value of some input.
+ Otherwise, if it is a single application-wide state object (like a cart), then use a Store, and group Operations in the Store's namespace.
+ Otherwise, if you are going to have instances of the state (like you have a Store that manages a random feed of objects like tweets, GitHub users etc) then use a Store and add accessor and mutators to the store's API. Those methods may need Operations (which can be name spaced inside the store) to deal with APIs, server side code etc.

**Why?**

+ because its simple... don't use Stores, Operations, or anything else if you don't need to. Don't unnecessarily expose the internals of a Component.
+ because you want to centralize Stores, and using Operations to mutate the store provides a consistent interface to the outside. If mutating the Store becomes more complex the power of the Operation can be used without an API change.
+ because in this case trying to use Operations becomes more cumbersome than its worth. You would have to pass the instance variable around to the Operation and simple things like `tweet_feed.next!` and `tweet_feed.avatar` would look like `StreamStore::Next(feed: tweet_feed)` and `StreamStore.avatar(tweet_feed)`.
+ So in this case, since you are building more complex Store it is reasonable to hide the Operation (which will still exist) inside the `StreamStore#next!` method
