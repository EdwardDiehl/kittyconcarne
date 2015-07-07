/** @jsx React.DOM */

// EVENTS

var Events = React.createClass({
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
      events = this.state.eventsData.map(function(venueObj) {
        return (
          <li key={venueObj.venue.id} >
            <h1>{venueObj.venue.name}</h1>
            <ul>
              {venueObj.events.map(function(event) {
                return (
                  <li key={event.id} >
                    <a href={event.url} >
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
      <div id="events-container">
        <ul>
          {events}
        </ul>
      </div>
    );
  }
});

// MAP

var Map = React.createClass({
  getInitialState: function() {
    return {

    };
  },
  buildMap: function() {
    var map, mapTileLayer;

    map = L.map('map-container').setView([51.505, -0.09], 13);
  },
  componentDidMount: function() {
    this.buildMap();
  },
  render: function() {
    return (
      <div id="map-container"></div>
    );
  }
});

// HOME

var Home = React.createClass({
  render: function() {
    return (
      <div>
        <Events />
        <Map />
      </div>
    );
  }
});

function render() {
  React.render(
    <Home />,
    document.getElementById('container')
  );
};

$(document).ready(render);
