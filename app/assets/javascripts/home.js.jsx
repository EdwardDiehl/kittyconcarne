/** @jsx React.DOM */

var Home = React.createClass({
  getInitialState: function() {
    return {
      eventsData: null
    };
  },
  load: function() {
    var setEvents = $.proxy(function(response) {
      this.setState({
        eventsData: response
      });
    }, this);

    function loadEvents(callback) {
      $.ajax({
        type: 'GET',
        dataType: 'json',
        url: '/events',
        success: function(response, status, xhr) {
          callback(response);
        },
        error: function(xhr, status, error) {

        }
      });
    }

    loadEvents(setEvents);
  },
  componentDidMount: function() {
    this.load();
  },
  render: function() {
    var _self = this;
    var events;

    if (this.state.eventsData) {
      events = this.state.eventsData.map(function(venue) {
        return (
          <li>
            <h1>{venue.venue.name}</h1>
            <ul>
              {venue.events.map(function(event) {
                return (
                  <li>
                    <a href={event.url}>
                      <h3>{event.name}</h3>
                      <p>{event.description}</p>
                    </a>
                  </li>
                )
              })}
            </ul>
          </li>
        )
      })
    } else {
      events = <div>No Events</div>;
    }

    return (
      <ul>
        {events}
      </ul>
    );
  }
});

function renderHome() {
  React.render(
    <Home />,
    document.getElementById('container')
  );
};

$(document).ready(renderHome);
