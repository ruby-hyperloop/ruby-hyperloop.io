---
id: tutorial
title: Tutorial
prev: getting-started.html
next: thinking-in-react.html
---

We'll be building a simple but realistic chat client that you can drop into a blog, a basic version the chat room offered by a service like gitter.im.

We'll provide:

* A login window to register your chat handle
* A view of the current chat conversation
* An input box to submit a chat

It'll also have a few neat features:

* **Optimistic commenting:** chats appear immediately in the list so it feels fast. (TBD)
* **Live updates:** other users' chats are popped into the comment view in real time.
* **Dynamic Time Formatting:** the time format changes from hours, to day of week, to full time.
* **Markdown formatting:** users can use Markdown to format their text.
* **Uses Bootstrap:** for styling

**CURRENT STATUS**

* The chat window is working and you can view it [here](/chatrb.html)
* The chat service is hosted on heroku, so there is nothing for you to setup.
* You down load the source, and modify it on your desktop, and see what happens.
* All React.rb source is inline
* There is also a test harness (change `chat_service.js` to `test_chat_service.js`)

**Coming soon will be a full step by step tutorial**
