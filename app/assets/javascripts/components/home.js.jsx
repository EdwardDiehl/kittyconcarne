// EVENT TICKER

var EventTicker = React.createClass({
  render: function() {
    return (
      <div id="event-ticker-container">Event Ticker</div>
    );
  }
});

// VENUES

var Venues = React.createClass({
  getInitialState: function() {
    return {
      eventsData: null
    };
  },
  enableSaving: function() {
    $('.add').on('click', function() {
      var eventId = $(this).parent().data().id;

      $.ajax({
        type: 'POST',
        url: '/save',
        dataType: 'JSON',
        data: {'event_id': eventId},
        success: function(response, status, xhr) {
          console.log(eventId);
        },
        error: function(xhr, status, error) {
        }
      });
    });
  },
  load: function() {
    var _self = this;

    var setEvents = $.proxy(function(response) {
      this.setState({
        eventsData: response
      });

      _self.enableSaving();
    }, this);

    function loadEvents(callback) {
      $.ajax({
        type: 'GET',
        dataType: 'json',
        url: '/events',
        success: function(response, status, xhr) {
          console.log(response)
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
    var venues;

    if (this.state.eventsData) {
      return (
        <div id="venue-container">
        {this.state.eventsData.map(function(venueObj) {
          return (
            <div key={venueObj.venue.id} className="venue">
              <div className="venue-name">
                <span>{venueObj.venue.name}</span>
              </div>
              <div>
                {venueObj.events.map(function(event) {
                  return (
                    <div key={event.id} data-id={event.id} className="event">
                      <div className="event-info">
                        <a href={event.url} >
                          <span className="event-name">{event.name}</span>
                        </a>
                        <div className="description">{event.description}</div>
                        <div className="date">{event.date}</div>
                      </div>
                      <div className="fa fa-plus add"></div>
                    </div>
                  )
                })}
              </div>
            </div>
          )
        })}
        </div>
      )
    } 
    else {
      return (
        <div id="venue-container no-events"></div>
      )
    }
  }
});

// FILTERS

var Filters = React.createClass({
  render: function() {
    return (
      <div id="filters-container">Filters</div>
    );
  }
});

// MAP

var Map = React.createClass({
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

// SAVED EVENTS

var SavedEvents = React.createClass({
  render: function() {
    return (
      <div id="saved-events-container">Saved Events</div>
    );
  }
});

// HOME

var Home = React.createClass({
  render: function() {
        // <EventTicker />
        // <SavedEvents />
        // <Filters />
        // <Map />
        
    return (
      <div>
        <Venues />
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
