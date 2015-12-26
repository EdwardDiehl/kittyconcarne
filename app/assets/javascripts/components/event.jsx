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
    var eventClasses, namesMarkup, actionButton;

    var splitAtNewline = $.proxy(function(str) {
      var text;

      if (str.indexOf('\n') !== -1) text = str.split('\n');
      else text = [str];

      return text;
    }, this);

    function formatDate(dateString) {
      var date = new Date(dateString);
      return date.getMonth() + 1 + '/' + date.getDate() + '/' + date.getFullYear();
    }

    eventClasses = 'row event ';
    if (event.seen) eventClasses += 'seen';

    namesMarkup = splitAtNewline(this.props.data.name).map(function(name) {
      return <div className="name">{name}</div>;
    });

    if (this.props.data.saved) {
      actionButton = (
        <div className="col-md-6 fa button remove" onClick={this.removeEvent}>
          <span className="fa-times"></span>
        </div>
      );
    } else {
      actionButton = (
        <div className="col-md-6 fa button save" onClick={this.saveEvent}>
          <span className="fa-plus-circle"></span>
        </div>
      );
    }

    return (
      <div data-id={this.props.data.id} className={eventClasses}>
        <div className="col-md-9 info">
          <a href={this.props.data.url} target="_blank">
            {namesMarkup}
          </a>
          <div className="description">{this.props.data.description.substring(0, 256)}</div>
          <div className="date">{formatDate(this.props.data.date)}</div>
          <div className="venue">{this.props.data.venue.name}</div>
        </div>
        <div className="col-md-3">
          <div className="row">
            {actionButton}
          </div>
        </div>
      </div>
    );
  }
});
