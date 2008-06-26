/*  ResizeableTextarea for the Prototype JavaScript framework, version 0.2
 *  (c) 2006 Bermi Ferrer <info -a-t bermi org>
 *
 *  ResizeableTextarea is freely distributable under the terms of an MIT-style license.
 *
 *  Requirements: Prototype JS framework http://prototypejs.org/
 *  Ussage: Add this attribute to the textarea you want to resize 
 *
 *    onfocus="new ResizeableTextarea(this);"
 *
/*--------------------------------------------------------------------------*/

ResizeableTextarea = Class.create();
ResizeableTextarea.prototype = {
    initialize: function(element, options) {
        this.element = $(element);
        this.size = parseFloat(this.element.getStyle('height') || '100');
        this.options = Object.extend({
            inScreen: false,
            resizeStep: 10,
            minHeight: this.size
        }, options || {});
        Event.observe(this.element, "keyup", this.resize.bindAsEventListener(this));
        if ( !this.options.inScreen ) {
            this.element.style.overflow = 'hidden';
        }
        this.element.setAttribute("wrap","virtual");
        this.resize();
    },
    resize : function(){
        this.shrink();
        this.grow();
    },
    shrink : function(){
        if ( this.size <= this.options.minHeight ){
            return;
        }
        if ( this.element.scrollHeight <= this.element.clientHeight) {
            this.size -= this.options.resizeStep;
            this.element.style.height = this.size+'px';
            this.shrink();
        }
    },
    grow : function(){
        if ( this.element.scrollHeight > this.element.clientHeight ) {
            if ( this.options.inScreen && (20 + this.element.offsetTop + this.element.clientHeight) > document.body.clientHeight ) {
                return;
            }
            this.size += (this.element.scrollHeight - this.element.clientHeight) + this.options.resizeStep;
            this.element.style.height = this.size+'px';
            this.grow();
        }
    }
}