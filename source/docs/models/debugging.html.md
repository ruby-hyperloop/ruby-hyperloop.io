---
title: Models
---
## Debugging

Sometimes you need to figure out what connections are available, or what attributes are readable etc.

Its usually all to do with your policies, but perhaps you just need a little investigation.

TODO check rr has become hyperloop (as below)

You can bring up a console within the controller context by browsing `localhost:3000/hyperloop/console`

**Note:  change `rr` to wherever you are mounting Hyperloop in your routes file.**

**Note: in rails 4, you will need to add the gem 'web-console' to your development section**

Within the context you have access to `session.id` and current `acting_user` which you will need, plus some helper methods to reduce typing

- Getting auto connection channels:  
`channels(session_id = session.id, user = acting_user)`  
e.g. `channels` returns all channels connecting to this session and user providing nil as the acting_user will test if connections can be made without there being a logged in user.

- Can a specific class connection be made:
`can_connect?(channel, user = acting_user)`
e.g. `can_connect? Todo`  returns true if current acting_user can connect to the Todo class. You can also provide the class name as a string.

- Can a specific instance connection be made:
`can_connect?(channel, user = acting_user)`
e.g. `can_connect? Todo.first`  returns true if current acting_user can connect to the first Todo Model. You can also provide the instance in the form 'Todo-123'

- What attributes are accessible for a Model instance:  
`viewable_attributes(instance, user = acting_user)`

- Can the attribute be viewed:  
`view_permitted?(instance, attribute, user = acting_user)`

- Can a Model be created/updated/destroyed:
`create_permitted?(instance, user = acting_user)`  
e.g. `create_permitted?(Todo.new, nil)` can anybody save a new todo?  
e.g. `destroy_permitted?(Todo.last)` can the acting_user destroy the last Todo

You can of course simulate server side changes to your Models through this console like any other console.  For example

`Todo.new.save` will broadcast the changes to the Todo Model to any authorized channels.
