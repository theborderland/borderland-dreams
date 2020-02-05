LoomioThreads = {}

document.querySelectorAll("[loomio-thread]").forEach(function (el) {
    var threadInfo = {
        endpoint: "https://talk.theborderland.se",
        discussionKey: el.getAttribute('loomio-thread')
    };

    LoomioThreads[threadInfo.discussionKey] = {
        app: Elm.LoomioThread.init({
            node: el,
            flags: threadInfo
        }),
        threadInfo: threadInfo
    };
});

// To refresh all threads on the page do:
//  Object.values(LoomioThreads).forEach(t =>  t.app.ports.fetch.send(t.threadInfo));