var ResizingTextArea = Class.create();

ResizingTextArea.prototype = {
    defaultRows: 1,

    initialize: function(field)
    {
        this.defaultRows = Math.max(field.rows, 1);
        this.resizeNeeded = this.resizeNeeded.bindAsEventListener(this);
        Event.observe(field, "click", this.resizeNeeded);
        Event.observe(field, "keyup", this.resizeNeeded);
    },

    resizeNeeded: function(event)
    {
        var t = Event.element(event);
        var lines = t.value.split('\n');
        var newRows = lines.length + 1;
        var oldRows = t.rows;
        for (var i = 0; i < lines.length; i++)
        {
            var line = lines[i];
            if (line.length >= t.cols) newRows += Math.floor(line.length / t.cols);
        }
        if (newRows > t.rows) t.rows = newRows;
        if (newRows < t.rows) t.rows = Math.max(this.defaultRows, newRows);
    }
}