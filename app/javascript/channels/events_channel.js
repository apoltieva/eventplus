import consumer from "./consumer";


consumer.subscriptions.create('EventsChannel', {
    received(data) {
        const eventsElement = document.querySelector('main.events div.container')
        if (eventsElement) {
            eventsElement.innerHTML = data.html
        }
    }
});
