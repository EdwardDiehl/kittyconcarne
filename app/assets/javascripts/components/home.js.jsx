var Home = React.createClass({
  getInitialState: function() {
    return {
      eventsData: [],
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
          console.log(error);
        }
      });
    }

    loadEvents(setEvents);
  },
  componentDidMount: function() {
    this.load();
  },
  render: function() {
    var AllEvents = this.state.eventsData.map($.proxy(function(event) {
      return <Event data={event} reload={this.load} key={event.id} />;
    }, this));

    var SavedEvents = this.state.eventsData.map($.proxy(function(event) {
      if (event.status) {
        return <Event data={event} reload={this.load} key={event.id} />;
      }
    }, this));

    if (this.state.eventsData.length > 0) {
      return (
        <div id="venue-container" className="container-fluid">
          <div className="row">
            <div className="col-md-3 venue">
              <div className="venue-name">All Events</div>
              <div>
                <div className="events-container">{AllEvents}</div>
              </div>
            </div>
            <div className="col-md-3 venue">
              <div className="venue-name">Saved</div>
              <div>
                <div className="events-container">{SavedEvents}</div>
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

function render() {
  React.render(
    <Home />,
    document.getElementById('container')
  );
};

$(document).ready(render);
