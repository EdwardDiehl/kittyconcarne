var Event = React.createClass({
  post: function(url) {
    $.ajax({
      type: 'POST',
      url: url,
      dataType: 'JSON',
      data: {'event_id': this.props.data.id},
      success: $.proxy(function(response, status, xhr) {
        this.props.reload();
      }, this),
      error: function(xhr, status, error) {
        console.log(error);
      }
    });
  },
  saveEvent: function() {
    this.post('/events/save');
  },
  removeEvent: function() {
    this.post('/events/remove');
  },
  render: function() {
    var actionButton;

    if (this.props.data.status) {
      actionButton = (
        <div className="col-md-6 fa remove" onClick={this.removeEvent}>
          <span className="fa-times"></span>
        </div>
      );
    } else {
      actionButton = (
        <div className="col-md-6 fa save" onClick={this.saveEvent}>
          <span className="fa-plus-circle"></span>
        </div>
      );
    }

    function formatName(name, className = "band") {
      if (name === undefined) return;

      if (name.indexOf('\n') !== -1) bands = name.split('\n');
      else bands = [name];

      return bands.map(function(band) {
        return <div className={className}>{band}</div>;
      })
    }

    function formatDate(dateString) {
      var date = new Date(dateString);
      return date.getMonth() + 1 + '/' + date.getDate() + '/' + date.getFullYear();
    }

    return (
      <div data-id={this.props.data.id} className="row event">
        <a href={this.props.data.url} target="_blank">
          <div className="col-md-9 event-info">
            {formatName(this.props.data.name)}
            {formatName(this.props.data.description, 'description')}
            <div className="location">{formatDate(this.props.data.date)}</div>
            <div className="location">{this.props.data.venue.name}</div>
          </div>
        </a>
        <div className="col-md-3 buttons">
          <div className="row">
            {actionButton}
          </div>
        </div>
      </div>
    );
  }
});
