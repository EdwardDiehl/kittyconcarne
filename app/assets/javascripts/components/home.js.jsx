// VENUES
var Venues = React.createClass({
  getInitialState: function() {
    return {
      eventsData: [],
      bookmarks: []
    };
  },
  enableActions: function() {
    var eventId;

    $('.bookmark').on('click', function() {
      eventId = $(this).parents().eq(2).data().id;

      var bookmark = $('span', this);
      var attending = $('span', $(this).next());

      if (bookmark.hasClass('fa-bookmark-o')) {
        bookmark.removeClass('fa-bookmark-o').addClass('fa-bookmark clicked');
        attending.removeClass('clicked');
        post('/bookmark');
      } else {
        bookmark.removeClass('fa-bookmark clicked').addClass('fa-bookmark-o');
        post('/clear')
      }
    });

    $('.attend').on('click', function() {
      eventId = $(this).parents().eq(2).data().id;

      $('span', this).toggleClass('clicked');
      $('span', $(this).prev()).removeClass('fa-bookmark clicked').addClass('fa-bookmark-o')

      if ($('span', this).hasClass('clicked')) {
        post('/attend');
      } else {
        post('/clear')
      }
    });

    function post(url) {
      $.ajax({
        type: 'POST',
        url: url,
        dataType: 'JSON',
        data: {'event_id': eventId},
        success: function(response, status, xhr) {
          console.log(eventId);
        },
        error: function(xhr, status, error) {
        }
      });
    }
  },
  load: function() {
    var _self = this;

    var setEvents = $.proxy(function(response) {
      this.setState({
        eventsData: response
      });

      _self.enableActions();
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
    var bookmark, attend;

    function buildButtons(status) {
      if (status === 'bookmarked') {
        bookmark = <span className="fa-bookmark clicked"></span>;
        attend = <span className="fa-plus-circle"></span>;
      } else if (status === 'attending') {
        bookmark = <span className="fa-bookmark-o"></span>;
        attend = <span className="fa-plus-circle clicked"></span>;
      } else if (!status) {
        bookmark = <span className="fa-bookmark-o"></span>;
        attend = <span className="fa-plus-circle"></span>;
      }

      return (
        <div className="col-md-3 buttons">
          <div className="row">
            <div className="col-md-6 fa bookmark">
              {bookmark}
            </div>
            <div className="col-md-6 fa attend">
              {attend}
            </div>
          </div>
        </div>
      );
    }

    function formatName(name, className = "band") {
      if (name === undefined) return;

      if (name.indexOf('\n') !== -1) bands = name.split('\n');
      else bands = [name];

      return bands.map(function(band) {
        return <div className={className}>{band}</div>
      })
    }

    function formatDate(dateString) {
      var date = new Date(dateString);
      return date.getMonth() + 1 + '/' + date.getDate() + '/' + date.getFullYear();
    }

    function eventList (event) {
      return (
        <div key={event.id} data-id={event.id} className="row event">
          <a href={event.url} target="_blank">
            <div className="col-md-9 event-info">
              {formatName(event.name)}
              {formatName(event.description, "description")}
              <div className="location">{formatDate(event.date)}</div>
              <div className="location">{event.venue.name}</div>
            </div>
          </a>
          {buildButtons(event.status)}
        </div>
      );
    }

    if (this.state.eventsData) {
      return (
        <div id="venue-container" className="container-fluid">
          <div className="row">
            <div className="col-md-3 venue">
              <div className="venue-name">All Events</div>
              <div>
                <div className="events-container">
                {this.state.eventsData.map(function(event) {
                  return eventList(event)
                })}
                </div>
              </div>
            </div>
            <div className="col-md-3 venue">
              <div className="venue-name">Bookmarks</div>
              <div>
                <div className="events-container">
                {this.state.bookmarks.map(function(event) {
                  return eventList(event)
                })}
                </div>
              </div>
            </div>
          </div>
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
